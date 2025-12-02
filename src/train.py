import argparse
from pathlib import Path
import pandas as pd
from src.data_processing import load_data, split_data
from src.features import basic_feature_engineering, scale_features
from src.model import train_model, save_model

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data-path", required=True)
    parser.add_argument("--target", default="defect")
    parser.add_argument("--output-dir", default="models")
    args = parser.parse_args()

    df = load_data(args.data_path)
    df = basic_feature_engineering(df)
    X_train, X_test, y_train, y_test = split_data(df, args.target)

    X_train_s, X_test_s, scaler = scale_features(X_train, X_test)
    model = train_model(X_train_s, y_train)

    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    save_model(model, out_dir / "rf_baseline.joblib")
    save_model(scaler, out_dir / "scaler.joblib")
    print("Training complete. Models saved to", out_dir)

if __name__ == "__main__":
    main()
