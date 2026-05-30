# 🔬 CerviAI

### A Hybrid Ensemble Deep Learning Framework for Automated Cervical Cancer Cell Classification

**Mobile · Web · Cloud — one model, three ways to run it.**

[![Model](https://img.shields.io/badge/Test%20Accuracy-97.34%25-brightgreen)]()
[![F1](https://img.shields.io/badge/Macro%20F1-0.9751-blue)]()
[![AUC](https://img.shields.io/badge/Macro%20AUC-0.9984-blueviolet)]()
[![Flutter](https://img.shields.io/badge/Mobile-Flutter-02569B?logo=flutter)]()
[![Cloud Run](https://img.shields.io/badge/Cloud-Google%20Cloud%20Run-4285F4?logo=googlecloud&logoColor=white)]()
[![License](https://img.shields.io/badge/License-MIT-yellow)]()

<img width="272" height="596" alt="image" src="https://github.com/user-attachments/assets/4ba781df-3762-4f30-ba8d-37fbda09a856" />



</div>

---

> **Medical disclaimer.** CerviAI is a research and educational decision-support prototype. It is **not** a diagnostic device and must not be used as a substitute for professional medical advice, diagnosis, or treatment. All predictions should be reviewed by a qualified pathologist or gynaecologist.

---

## 📑 Table of Contents

- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [Screenshots](#-screenshots)
- [How It Works](#-how-it-works)
- [Model & Results](#-model--results)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [REST API Reference](#-rest-api-reference)
- [Cloud Deployment](#-cloud-deployment)
- [Dataset](#-dataset)
- [Limitations](#-limitations)
- [Roadmap](#-roadmap)
- [Authors & Acknowledgements](#-authors--acknowledgements)
- [Citation](#-citation)
- [License](#-license)

---

## 📖 About the Project

Cervical cancer is one of the leading causes of cancer death among women worldwide, yet it is almost entirely preventable through early screening. Manual interpretation of Pap-smear cytology requires trained pathologists, who are scarce in low-resource settings.

**CerviAI** automates Pap-smear cell classification using a **heterogeneous ensemble of three convolutional neural networks** — ResNet50, DenseNet121, and EfficientNet-B3 — combined via **soft voting**. Trained on the publicly available **SIPaKMeD** dataset across five clinical classes, the ensemble reaches **97.34% test accuracy**, a **macro F1 of 0.9751**, and a **macro AUC of 0.9984**.

The same model is shipped in three complementary ways:

1. **📱 Mobile app (Flutter)** — an on-device **TensorFlow Lite** build of EfficientNet-B3 (42.7 MB, ~200 ms inference) that works **fully offline** after install.
2. **🌐 Web app** — an interactive dashboard for upload, prediction, per-model contributions, history, and PDF export.
3. **☁️ Cloud REST API (FastAPI on Google Cloud Run)** — the always-latest model for integration with clinical systems.

A **Gemini-powered chatbot** provides educational follow-up, locked by a system prompt to cervical-cancer education and explicitly forbidden from giving diagnoses.

### Project goals

- Achieve **>97%** classification accuracy on the SIPaKMeD test set.
- Map 5 cellular classes onto a clinically meaningful **3-tier triage**: *Normal / Benign / Abnormal*.
- Run **fully offline** on entry-level smartphones after install.
- Provide a **cloud REST API** for integration with clinic management systems.
- Offer educational follow-up via an LLM chatbot with strict guardrails.

---

## ✨ Key Features

| Area | Capability |
|------|------------|
| **Classification** | 5-class Pap-smear cell classification with confidence scores |
| **Triage mapping** | Collapses 5 classes into Normal / Benign / Abnormal for actionable output |
| **Offline inference** | On-device TFLite EfficientNet-B3, no network required (~200 ms) |
| **Cloud inference** | FastAPI `/predict` endpoint on Cloud Run (~600 ms incl. network) |
| **Three inference paths** | On-device (default) · Cloud REST (fallback / always-latest) · Chatbot (educational) |
| **Educational chatbot** | Gemini 2.5 Flash-Lite, system-prompt-locked to cervical health |
| **Confidence guardrail** | Low-confidence abnormal predictions trigger an explicit *"please refer"* message |
| **Reports** | Scan history + PDF export of results |
| **Auth** | Firebase Auth (email/password + Google OAuth) |
| **Audit trail** | Every cloud prediction logged to Cloud Logging |

---

## 📸 Screenshots

> **Add your own images.** Drop your PNGs into a `screenshots/` folder at the repo root using the filenames below and they will render automatically. Recommended width ~300px per mobile shot and full-width for the web dashboard.

### 📱 Mobile App (Flutter)

| Onboarding | Home | Upload / Capture |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/d0996e29-9034-4944-a2a2-cec89933b92d" width="230"/> | <img width="272" height="596" alt="image" src="https://github.com/user-attachments/assets/f0f7804a-c1e7-4ee6-871e-643d7abe2fa3" width="230"/> | <img width="272" height="596" alt="image" src="https://github.com/user-attachments/assets/a87fee1a-ee30-4f6e-8a13-a28ae723079a" width="230"/> |

| Analysis Result | Chatbot | Reports / History |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/ec414de3-afb7-4025-b825-35c3c3b223b9" width="230"/> | <img src="https://github.com/user-attachments/assets/f45f70a1-d5f0-4ee0-8dd6-1d40af786517" width="230"/> | <img src="https://github.com/user-attachments/assets/a3ba5ec0-0187-4c4e-ae0f-753fe8f560e0" width="230"/> |

### 🌐 Web Application 

| Upload & Predict |
|:---:|
| <img width="1280" height="687" alt="image" src="https://github.com/user-attachments/assets/226b0353-7cc7-4626-8130-32e761eff4ac" /> |
| <img width="1280" height="687" alt="image" src="https://github.com/user-attachments/assets/8892abbe-a41e-4a69-ab06-b0b8c73a939a" /> |
| <img width="1280" height="687" alt="image" src="https://github.com/user-attachments/assets/0f59d5b3-71f2-4975-8824-dfc0e5ccc085" /> |
| <img width="1280" height="687" alt="image" src="https://github.com/user-attachments/assets/31031722-408b-4a3d-9ed4-28b72c5937b0" /> |
| <img width="1280" height="687" alt="image" src="https://github.com/user-attachments/assets/08e9e598-9bb4-4197-a253-7d2fcf9fab17" /> |

---

## 🧠 How It Works

```
                ┌─────────────────────────────────────────────┐
   Pap-smear    │            Preprocessing (Albumentations)    │
   cell image ──▶  Resize 224×224 · CLAHE · ImageNet normalise │
                └───────────────────────┬─────────────────────┘
                                         │  [B, 3, 224, 224]
            ┌────────────────────────────┼────────────────────────────┐
            ▼                            ▼                             ▼
      ┌───────────┐              ┌─────────────┐              ┌────────────────┐
      │ ResNet50  │              │ DenseNet121 │              │ EfficientNet-B3│
      └─────┬─────┘              └──────┬──────┘              └───────┬────────┘
            │ softmax(5)                │ softmax(5)                  │ softmax(5)
            └───────────────┬───────────┴──────────────┬─────────────┘
                            ▼                           ▼
                    ┌──────────────────────────────────────────┐
                    │   Soft-Voting Fusion (weighted ensemble)   │
                    │   P = 0.40·R + 0.38·D + 0.22·Eff           │
                    └────────────────────┬───────────────────────┘
                                         ▼
                         argmax → predicted class + confidence
                                         ▼
                    Dyskeratotic · Koilocytotic · Metaplastic ·
                    Parabasal · Superficial-Intermediate
                       (→ Abnormal / Benign / Normal triage)
```

### Three inference paths

- **Path A — On-device TFLite (default):** zero network calls, ~200 ms, full privacy.
- **Path B — Cloud REST:** ~600 ms incl. network; used when the user opts into the always-latest model or on-device inference fails.
- **Path C — Chatbot:** text-only, calls the Gemini API for educational follow-up after a result is shown.

---

## 📊 Model & Results

All figures are on the **held-out test set**, stratified across all five classes.

### Headline metrics (soft-voting ensemble)

| Metric | Value | Interpretation |
|--------|-------|----------------|
| Test accuracy | **97.34%** | 733 / 753 images correct |
| Macro F1-score | **0.9751** | Balanced precision–recall across classes |
| Macro AUC-ROC | **0.9984** | Near-perfect class discrimination |
| Macro precision | 0.9758 | |
| Macro recall | 0.9744 | |
| Cohen's κ | 0.9667 | Almost-perfect agreement |

### Per-model vs ensemble

| Strategy | Macro F1 | Accuracy | Macro AUC |
|----------|:---:|:---:|:---:|
| ResNet50 alone | 0.9624 | 96.41% | 0.9952 |
| DenseNet121 alone | 0.9568 | 95.88% | 0.9941 |
| EfficientNet-B3 alone | 0.9520 | 95.35% | 0.9928 |
| **Soft-Voting Ensemble** | **0.9751** | **97.34%** | **0.9984** |

### Per-class performance (ensemble)

| Class | Category | F1 | Precision | Recall |
|-------|----------|:---:|:---:|:---:|
| Dyskeratotic | Abnormal | 0.9720 | 0.9719 | 0.9721 |
| Koilocytotic | Abnormal | 0.9467 | 0.9485 | 0.9450 |
| Metaplastic | Benign | 0.9605 | 0.9614 | 0.9596 |
| Parabasal | Normal | **1.0000** | 1.0000 | 1.0000 |
| Superficial-Intermediate | Normal | 0.9963 | 0.9970 | 0.9956 |

> **Clinically safe error pattern.** Residual errors cluster between *Dyskeratotic* and *Koilocytotic* — **both abnormal** — so the model rarely commits the dangerous error of labelling an abnormal cell as Normal. False reassurance, the worst failure for a screening tool, is driven close to zero.

### Why an ensemble?

- **Accuracy** — the ensemble beats every single backbone by a clear margin.
- **Robustness** — when one network errs, the others' votes overwhelm the mistake (the ensemble corrected ~64% of ResNet50's validation errors).
- **Safety** — errors stay inside the same clinical category, never crossing the abnormal/normal boundary.

### Deployed vs research model

| Strategy | F1 | Total size | Mobile latency | Use |
|----------|:---:|:---:|:---:|-----|
| Full ensemble (3 nets) | 0.9751 | 176 MB | ~600 ms | Research, validation, headline metrics |
| **EfficientNet-B3 only** | 0.9520 | **42.7 MB** | **~200 ms** | **Production (mobile + cloud)** |

The deployed single model trades ~2.3 F1 points for **4× smaller files and 3× faster inference**, and stays conservative: when confidence on an abnormal class drops below **0.6**, the app shows a *low-confidence, please refer* message instead of a confident answer.

---

## 🛠 Tech Stack

**Machine learning**
- PyTorch / TIMM (training & benchmarking)
- TensorFlow Lite (on-device deployment)
- Albumentations (preprocessing & augmentation)
- ResNet50 · DenseNet121 · EfficientNet-B3 (ensemble members)

**Mobile**
- Flutter (Android / iOS)
- `tflite_flutter` for on-device inference

**Web & API**
- FastAPI · Uvicorn (REST service)
- Flask (interactive web app backend)
- Pillow (image handling)

**Cloud (Google Cloud Platform)**
- Cloud Run · Artifact Registry · Cloud Build · Cloud Logging · IAM
- Firebase Auth (email + Google OAuth)
- Google Gemini API (2.5 Flash-Lite) for the educational chatbot

---

## 📂 Project Structure

```
CerviAI/
├── model/                       # Training, ensemble calibration, evaluation
│   ├── train.py
│   ├── ensemble.py              # Soft-voting fusion
│   ├── export_tflite.py         # EfficientNet-B3 → .tflite
│   └── weights/                 # .pth / .tflite artifacts
│
├── api/                         # FastAPI Cloud Run service
│   ├── main.py                  # POST /predict
│   ├── Dockerfile
│   └── efficientnet_b3.tflite   # bundled model (42.7 MB)
│
├── web/                         # Flask interactive web application
│   ├── app.py
│   ├── templates/
│   └── static/
│
├── frontend_cerviai/            # Flutter mobile application
│   ├── lib/
│   │   ├── features/            # 13 feature modules
│   │   └── services/
│   │       ├── tflite_service.dart
│   │       ├── api_service.dart
│   │       ├── chat_service.dart
│   │       └── api_keys.dart    # gitignored
│   ├── assets/efficientnet_b3.tflite
│   └── pubspec.yaml
│
├── screenshots/                 # README images (add your own)
└── README.md
```

### Flutter feature modules

| Group | Modules | Purpose |
|-------|---------|---------|
| Onboarding | `splash`, `onboarding` | First-launch tutorial and intro |
| Authentication | `auth`, `profile` | Email + Google sign-in, user profile |
| Core analysis | `home`, `upload`, `analysis`, `results` | Capture/upload, run inference, show result |
| Educational | `cancer_info`, `foods_nutrition` | Static content about cervical cancer & nutrition |
| Clinical | `doctor_consultation`, `reports` | Find gynaecologists, scan history, PDF export |
| AI assistant | `chatbot` | Gemini-powered Q&A about cervical health |

---

## 🚀 Getting Started

### Prerequisites

- Python 3.11+
- Flutter SDK 3.x and Dart
- (For cloud) Google Cloud SDK (`gcloud`) and a GCP project
- A Google Gemini API key for the chatbot

### 1. Clone

```bash
git clone https://github.com/<your-username>/CerviAI.git
cd CerviAI
```

### 2. Cloud REST API (FastAPI)

```bash
cd api
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt          # fastapi, uvicorn, tensorflow-cpu, pillow
uvicorn main:app --reload --port 8080
# → http://localhost:8080/predict
```

### 3. Web application (Flask)

```bash
cd web
pip install -r requirements.txt
python app.py
# → http://localhost:5000
```

### 4. Mobile application (Flutter)

```bash
cd frontend_cerviai
flutter pub get
# Add your Gemini key to lib/services/api_keys.dart (gitignored)
flutter run                                # run on a connected device/emulator
flutter build apk --release                # build a release APK
```

---

## 🔌 REST API Reference

**`POST /predict`** — classify a single Pap-smear cell image.

**Request** — `multipart/form-data`

| Field | Type | Description |
|-------|------|-------------|
| `image` | file | The cell image to classify |

**Example**

```bash
curl -X POST "https://<cloud-run-url>/predict" \
  -F "image=@sample_cell.png"
```

**Response** — `application/json`

```json
{
  "predicted_class": "Koilocytotic",
  "confidence": 0.967,
  "all_probabilities": {
    "Dyskeratotic": 0.012,
    "Koilocytotic": 0.967,
    "Metaplastic": 0.009,
    "Parabasal": 0.005,
    "Superficial-Intermediate": 0.007
  },
  "inference_time_ms": 612,
  "disclaimer": "Research prototype — not a diagnostic device. Consult a clinician."
}
```

---

## ☁️ Cloud Deployment

CerviAI is deployed on **Google Cloud Platform** (`asia-south1` / Mumbai).

| Component | Role |
|-----------|------|
| **Cloud Run** (`cervical-api`) | Serverless container, 2 GB RAM / 2 vCPU, scales to zero, ~10 s cold start, ~600 ms warm |
| **Artifact Registry** | Stores the Docker image (model bundled, no runtime download) |
| **Cloud Build** | CI/CD via `gcloud run deploy --source .`, one-click rollback |
| **Cloud Logging** | Audit trail of every request, response, error, and latency |
| **Firebase Auth** | Email/password + Google OAuth, tokens exchanged with the API |
| **Gemini API** | Educational chatbot, system-prompt-locked, permanent disclaimer banner |

**Deploy:**

```bash
cd api
gcloud run deploy cervical-api --source . --region asia-south1 --allow-unauthenticated
```

**Minimum IAM roles** (least privilege): `roles/run.admin`, `roles/storage.admin`, `roles/artifactregistry.writer`, `roles/logging.logWriter`.

---

## 🗂 Dataset

[**SIPaKMeD**](https://www.cs.uoi.gr/~marina/sipakmed.html) — publicly available Pap-smear cell images annotated by experienced cytologists, across five clinically meaningful classes:

| Class | Clinical category | Significance |
|-------|-------------------|--------------|
| Dyskeratotic | Abnormal | Premalignant keratin disorder |
| Koilocytotic | Abnormal | Hallmark of HPV infection |
| Metaplastic | Benign | Normal cellular adaptation |
| Parabasal | Normal | Healthy squamous epithelium |
| Superficial-Intermediate | Normal | Mature healthy cells |

**Split:** stratified 70 / 15 / 15 (train / validation / test), fixed random seed = 42.
**Preprocessing:** resize to 224×224 · CLAHE contrast enhancement · ImageNet normalisation; training-only augmentation (flips, ±15° rotation, colour jitter, random erasing).

---


---

## 🧭 Roadmap

- [ ] **Knowledge distillation** — train a small student network to mimic the ensemble, closing the deployed-vs-research gap at single-model cost.
- [ ] **Cross-dataset validation** — Herlev, ISBI 2014, and multi-centre clinical scans.
- [ ] **Whole-slide pipeline** — integrate a cell detector (e.g. YOLOv8) to process raw slide scans.
- [ ] **Active-learning loop** — route difficult field cases to expert review and periodically retrain.
- [ ] **Multi-language UI** — extend the Flutter app to local Indian languages.
- [ ] **Learned voting weights** — generalise uniform/weighted soft voting to validation-learned weights and stacking meta-learners.

---

## 👩‍🔬 Authors & Acknowledgements

- **Bhavana Poli** — author and developer

Department of Computer Science and Engineering,
**Amrita School of Engineering, Bengaluru — Amrita Vishwa Vidyapeetham.**

Built on the SIPaKMeD dataset (Plissiti et al.) and pretrained ImageNet backbones via PyTorch / TIMM.

---

## 📚 Citation

If you use this work, please cite the companion paper:

```bibtex
@inproceedings{poli_cerviai_2025,
  title     = {Cervical Cancer Cell Classification on the SIPaKMeD Dataset:
               A Comparative Study of Ten Deep Learning Architectures
               with a Soft-Voting Top-3 Ensemble},
  author    = {Poli, Bhavana},
  booktitle = {Procedia Computer Science},
  publisher = {Elsevier},
  year      = {2026}
}
```

---

## 📄 License

Released under the **MIT License**. See [`LICENSE`](LICENSE) for details.
The SIPaKMeD dataset retains its own terms of use; no patient data is collected or distributed by this project.

---

<div align="center">

**CerviAI** — accurate enough to be clinically useful, light enough to run on entry-level phones, and architected for safe operational use.

</div>
