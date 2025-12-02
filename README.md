# Manufacturing Defect Prediction

This repository contains code, tests, CI, and deployment scaffolding for a manufacturing defect prediction app:
- Data processing and feature engineering
- Model training (scikit-learn RandomForest baseline)
- REST prediction API (FastAPI)
- Dockerfile and GitHub Actions CI

Quickstart
1. Create and activate a virtualenv:
   python -m venv .venv && source .venv/bin/activate
2. Install dependencies:
   pip install -r requirements.txt
3. Train a baseline model:
   python -m src.train --data-path data/raw/sample.csv --output-dir models/
4. Run the API:
   uvicorn app.main:app --reload --port 8080

Project layout
- src/ : python package (data processing, features, model, training)
- app/ : FastAPI app for inference
- models/ : saved model artifacts (gitignored)
- tests/ : unit tests
- .github/workflows/ci.yml : CI for tests and lint

Notes
- This is a starting point. Replace sample data and tune the model and feature pipeline for your production needs.
- Do not commit production datasets to the repo; keep them in a separate storage (S3, artifact store).

License
- MIT by default. Change LICENSE as needed.
