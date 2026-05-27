from __future__ import annotations
import io
import os
import sys
import time
import logging
from typing import Dict, Any, List, Optional

from fastapi import FastAPI, File, UploadFile, HTTPException, Request
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import uvicorn

from PIL import Image, UnidentifiedImageError
import torch
from torchvision import transforms, models


# App and logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
logger = logging.getLogger("cervicai")

APP = FastAPI()
APP.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])  # dev-friendly

# Frontend directories
STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")
FRONTEND_DIST = os.path.join(os.path.dirname(__file__), "frontend", "dist")
if not os.path.isdir(STATIC_DIR):
    os.makedirs(STATIC_DIR, exist_ok=True)

APP.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")
if os.path.isdir(FRONTEND_DIST):
    APP.mount("/assets", StaticFiles(directory=os.path.join(FRONTEND_DIST, 'assets')), name="assets")
    APP.mount("/favicon.ico", StaticFiles(directory=FRONTEND_DIST), name="favicon")

# Models directory
MODELS_DIR = os.environ.get("MODELS_DIR", os.path.join(os.path.dirname(__file__), "models"))
if not os.path.isdir(MODELS_DIR):
    os.makedirs(MODELS_DIR, exist_ok=True)

# Model file names (expected)
MODEL_FILES = {
    'resnet50': os.path.join(MODELS_DIR, 'resnet50.pth'),
    'densenet121': os.path.join(MODELS_DIR, 'densenet121.pth'),
    'efficientnet_b3': os.path.join(MODELS_DIR, 'efficientnet_b3.pth'),
}
ENSEMBLE_FILE = os.path.join(MODELS_DIR, 'ensemble.pth')

# Ensemble weights
WEIGHTS = {'resnet50': 0.40, 'densenet121': 0.38, 'efficientnet_b3': 0.22}

# Class names and categories (exact order required)
CLASS_NAMES = [
    'Dyskeratotic',
    'Koilocytotic',
    'Metaplastic',
    'Parabasal',
    'Superficial-Intermediate',
]

CATEGORY = {
    'Dyskeratotic':              ('Abnormal', 'high'),
    'Koilocytotic':              ('Abnormal', 'high'),
    'Metaplastic':               ('Benign',   'medium'),
    'Parabasal':                 ('Normal',   'low'),
    'Superficial-Intermediate':  ('Normal',   'low'),
}

# Device auto-detection: CUDA -> MPS -> CPU
def detect_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device('cuda')
    # torch.backends.mps may not exist on older torch, guard accordingly
    try:
        if getattr(torch.backends, 'mps', None) is not None and torch.backends.mps.is_available():
            return torch.device('mps')
    except Exception:
        pass
    return torch.device('cpu')


device = detect_device()
logger.info(f"Using device: {device}")

# Model builders
def build_resnet50() -> torch.nn.Module:
    m = models.resnet50(weights=None)
    m.fc = torch.nn.Linear(m.fc.in_features, 5)
    return m


def build_densenet121() -> torch.nn.Module:
    m = models.densenet121(weights=None)
    m.classifier = torch.nn.Linear(m.classifier.in_features, 5)
    return m


def build_efficientnet_b3() -> torch.nn.Module:
    m = models.efficientnet_b3(weights=None)
    m.classifier[1] = torch.nn.Linear(m.classifier[1].in_features, 5)
    return m


# Preprocessing transform (must match training exactly)
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225],
    ),
])


# Load models at startup and keep in memory
MODELS: Dict[str, torch.nn.Module] = {}

def load_models_or_exit() -> List[str]:
    # If a single ensemble file exists, try to load per-model state_dicts from it.
    if os.path.isfile(ENSEMBLE_FILE):
        logger.info(f"Found ensemble file {ENSEMBLE_FILE}; attempting to load combined state dicts")
        data = torch.load(ENSEMBLE_FILE, map_location=device)
        if isinstance(data, dict) and all(k in data for k in ['resnet50', 'densenet121', 'efficientnet_b3']):
            # load each model from sub-dicts
            for name, builder in [('resnet50', build_resnet50), ('densenet121', build_densenet121), ('efficientnet_b3', build_efficientnet_b3)]:
                logger.info(f"Building {name} from ensemble file")
                m = builder()
                state = data[name]
                m.load_state_dict(state)
                m.to(device)
                m.eval()
                MODELS[name] = m
            logger.info(f"All models loaded from ensemble file: {list(MODELS.keys())}")
            return list(MODELS.keys())
        else:
            logger.warning("Ensemble file found but does not contain expected per-model keys; falling back to individual files")

    # Fallback: require individual files
    missing = [name for name, path in MODEL_FILES.items() if not os.path.isfile(path)]
    if missing:
        logger.error(f"Missing model files in {MODELS_DIR}: {missing}")
        sys.exit(1)

    # Build and load individual model files
    for name, path in MODEL_FILES.items():
        logger.info(f"Loading {name} from {path}")
        if name == 'resnet50':
            m = build_resnet50()
        elif name == 'densenet121':
            m = build_densenet121()
        elif name == 'efficientnet_b3':
            m = build_efficientnet_b3()
        else:
            raise RuntimeError(f"Unknown model {name}")

        state = torch.load(path, map_location=device)
        m.load_state_dict(state)
        m.to(device)
        m.eval()
        MODELS[name] = m

    logger.info(f"All models loaded: {list(MODELS.keys())}")
    return list(MODELS.keys())


@torch.no_grad()
def predict_ensemble(pil_image: Image.Image) -> Dict[str, Any]:
    """Run weighted soft-voting ensemble on a PIL image.

    The ensemble implements weighted soft voting: each model emits a probability
    distribution p_i over the 5 classes (via softmax over logits). We compute
    fused = sum_w (w_i * p_i). The predicted class is argmax(fused).

    Returns a dictionary matching the API contract with probabilities and per-model breakdown.
    """
    x = transform(pil_image.convert("RGB")).unsqueeze(0).to(device)

    per_model_probs: Dict[str, List[float]] = {}
    fused = torch.zeros(1, 5, device=device)

    for name, model in MODELS.items():
        logits = model(x)
        probs = torch.softmax(logits, dim=1)
        per_model_probs[name] = probs[0].cpu().tolist()
        fused += WEIGHTS[name] * probs

    fused_list = fused[0].cpu().tolist()
    pred_idx = int(max(range(5), key=lambda i: fused_list[i]))
    pred_class = CLASS_NAMES[pred_idx]
    confidence = float(fused_list[pred_idx])
    category, risk = CATEGORY[pred_class]

    # Log prediction
    logger.info(f"Prediction: {pred_class} confidence={confidence:.4f}")

    return {
        "predicted_class": pred_class,
        "confidence": confidence,
        "category": category,
        "risk_level": risk,
        "all_probabilities": dict(zip(CLASS_NAMES, fused_list)),
        "model_outputs": {
            name: max(p) for name, p in per_model_probs.items()
        },
        "ensemble_score": confidence,
        "per_model_probabilities": {
            name: dict(zip(CLASS_NAMES, p)) for name, p in per_model_probs.items()
        },
        "ensemble_members": [
            {"model": "ResNet50",        "weight": WEIGHTS['resnet50']},
            {"model": "DenseNet121",     "weight": WEIGHTS['densenet121']},
            {"model": "EfficientNet-B3", "weight": WEIGHTS['efficientnet_b3']},
        ],
    }


# Startup: load models
loaded = load_models_or_exit()


# Routes
@APP.get('/', response_class=HTMLResponse)
async def index() -> HTMLResponse:
    # Prefer React frontend build when available, otherwise fallback to legacy static HTML
    if os.path.isdir(FRONTEND_DIST):
        index_path = os.path.join(FRONTEND_DIST, 'index.html')
        if os.path.isfile(index_path):
            return HTMLResponse(open(index_path, 'r', encoding='utf-8').read())
    index_path = os.path.join(STATIC_DIR, 'index.html')
    if os.path.isfile(index_path):
        return HTMLResponse(open(index_path, 'r', encoding='utf-8').read())
    return HTMLResponse("<html><body><h1>CerviAI</h1><p>UI not found.</p></body></html>")


@APP.get('/health')
async def health() -> JSONResponse:
    return JSONResponse({"status": "ok", "models_loaded": loaded})


@APP.post('/predict', response_model=None)
async def predict(file: UploadFile = File(...)):
    # Validate filename/content-type
    filename = file.filename or 'unnamed'
    lower = filename.lower()
    allowed_ext = ('.jpg', '.jpeg', '.png', '.bmp')
    if not lower.endswith(allowed_ext) and not (file.content_type and file.content_type.startswith('image/')):
        raise HTTPException(status_code=400, detail='Invalid file type. Please upload an image (.jpg, .png, .bmp).')

    contents = await file.read()
    max_size = 10 * 1024 * 1024
    if len(contents) > max_size:
        raise HTTPException(status_code=400, detail='File too large. Maximum size is 10 MB.')

    try:
        img = Image.open(io.BytesIO(contents))
        img.verify()  # verify will raise if not image
        # reopen to reset file pointer
        img = Image.open(io.BytesIO(contents)).convert('RGB')
    except (UnidentifiedImageError, Exception):
        raise HTTPException(status_code=400, detail='Uploaded file is not a valid image.')

    start = time.time()
    try:
        result = predict_ensemble(img)
    except Exception as exc:
        logger.exception('Error during prediction')
        raise HTTPException(status_code=500, detail='Internal error during prediction.')
    duration = time.time() - start

    # Add metadata
    result['_meta'] = {'inference_time_seconds': duration}

    # Log timestamped prediction summary (no PII)
    logger.info(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - predicted={result['predicted_class']} confidence={result['confidence']:.4f}")

    return JSONResponse(result)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', '8000'))
    uvicorn.run(APP, host='0.0.0.0', port=port, reload=False)
