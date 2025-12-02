from sklearn.ensemble import RandomForestClassifier
import joblib
from typing import Any

def train_model(X, y, n_estimators=100, random_state=42) -> Any:
    model = RandomForestClassifier(n_estimators=n_estimators, random_state=random_state, n_jobs=-1)
    model.fit(X, y)
    return model

def save_model(model, path: str):
    joblib.dump(model, path)

def load_model(path: str):
    return joblib.load(path)

def predict(model, X):
    return model.predict(X)
