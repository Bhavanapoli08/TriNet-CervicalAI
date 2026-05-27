# CerviAI — Cervical Cancer Cell Classifier (Local)

Quick start

1. Create and activate a Python 3.10+ virtual environment.
2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. Place the trained model weight files in `models/`:

- `resnet50.pth`
- `densenet121.pth`
- `efficientnet_b3.pth`

Alternatively you can provide a single `ensemble.pth` file containing a dict with keys `resnet50`, `densenet121`, and `efficientnet_b3` mapping to each model's `state_dict`. The server will prefer `ensemble.pth` when present.

You can set a custom models directory with the `MODELS_DIR` env var.

Run the app:

```bash
python app.py
```

Open http://localhost:8000 in your browser.

Frontend setup
- The React/Tailwind UI is located in `frontend/`.
- To run the frontend in development mode:

```bash
cd frontend
npm install
npm run dev
```

- To build the production frontend and serve it from the backend:

```bash
cd frontend
npm install
npm run build
cd ..
python app.py
```

Open http://localhost:8000 once the backend is running.

Notes
- The app auto-detects device: CUDA → MPS (Apple Silicon) → CPU.
- To change the port: `PORT=8080 python app.py`.
- To swap model weights: replace the `.pth` files in `models/` and restart the server.

API
- `GET /` — serves the web UI
- `POST /predict` — multipart form with field `file`, returns JSON with the following fields:

```json
{
  "predicted_class": "Dyskeratotic",
  "confidence": 0.985,
  "category": "Abnormal",
  "risk_level": "high",
  "all_probabilities": {"Dyskeratotic": 0.985, ...},
  "per_model_probabilities": {"resnet50": {..}, "densenet121": {..}, "efficientnet_b3": {..}},
  "ensemble_members": [{"model":"ResNet50","weight":0.4}, ...],
  "_meta": {"inference_time_seconds": 0.12}
}
```

Troubleshooting
- If the server exits with an error about missing model files, ensure the three `.pth` files are present in `models/` (or `MODELS_DIR`). The server refuses to start without them to avoid partially loading the ensemble.
- If you see slow inference on CPU, consider using a smaller batch or enabling GPU if available.
