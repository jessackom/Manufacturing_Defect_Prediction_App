import pandas as pd
from sklearn.model_selection import train_test_split

def load_data(path: str) -> pd.DataFrame:
    """Load CSV data from path."""
    return pd.read_csv(path)

def split_data(df: pd.DataFrame, target: str, test_size=0.2, random_state=42):
    """Split dataframe into train/test."""
    X = df.drop(columns=[target])
    y = df[target]
    return train_test_split(X, y, test_size=test_size, random_state=random_state)
