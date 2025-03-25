import pandas as pd
import numpy as np
import joblib
from sqlalchemy import create_engine
from sklearn.ensemble import RandomForestRegressor

# Database Connection (Using SQLAlchemy)
DB_USER = "root"
DB_PASSWORD = "Alfin%402022"
DB_HOST = "localhost"
DB_NAME = "finance_db"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}")

# Load data from MySQL
def load_data_from_db():
    query = "SELECT user_id, amount, date_time FROM transactions;"
    df = pd.read_sql(query, engine)

    if df.empty:
        print("⚠️ No data found in the transactions table!")
        return None

    df["date_time"] = pd.to_datetime(df["date_time"])
    df["year_month"] = df["date_time"].dt.to_period("M")

    # Group by user and month
    df = df.groupby(["user_id", "year_month"])['amount'].sum().reset_index()

    # ✅ Outlier Detection & Removal using IQR Method
    Q1 = df["amount"].quantile(0.25)
    Q3 = df["amount"].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR

    # Clip values to remove extreme outliers
    df["amount"] = np.clip(df["amount"], lower_bound, upper_bound)

    return df


# Create features for training
def create_features(data):
    users = data["user_id"].unique()
    all_X, all_y = [], []

    for user_id in users:   
        user_data = data[data["user_id"] == user_id].copy()
        if len(user_data) < 3:
            continue  

        user_data["prev_month_1"] = user_data["amount"].shift(1)
        user_data["prev_month_2"] = user_data["amount"].shift(2)
        user_data["prev_month_3"] = user_data["amount"].shift(3)
        user_data["avg_spending"] = user_data["amount"].rolling(3).mean()
        user_data["spending_variance"] = user_data["amount"].rolling(3).std()
        
        user_data.dropna(inplace=True)  

        X = user_data[["prev_month_1", "prev_month_2", "prev_month_3", "avg_spending", "spending_variance"]]
        y = user_data["amount"]
        
        all_X.append(X)
        all_y.append(y)

    if not all_X or not all_y:  # Check if data exists
        print("⚠️ Not enough data for training. At least 3 months of data is required per user.")
        return None, None

    return pd.concat(all_X), pd.concat(all_y)

# Train and save the model
def train_and_save_model():
    data = load_data_from_db()
    if data is None:
        return  # Stop execution if no data

    X, y = create_features(data)

    if X is None or y is None:
        return  # Stop execution if no training data

    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X, y)

    joblib.dump(model, "expense_model.pkl")
    print("✅ Model trained and saved as expense_model.pkl")

# Run training
if __name__ == "__main__":
    train_and_save_model()
