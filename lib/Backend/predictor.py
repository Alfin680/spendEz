import pandas as pd
import numpy as np
import joblib
from sqlalchemy import create_engine
from flask import Flask, request, jsonify

# Database Connection (Using SQLAlchemy)
DB_USER = "root"
DB_PASSWORD = "njn%402003"
DB_HOST = "localhost"
DB_NAME = "finance_db"

engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}")

# Load trained model
model = joblib.load("expense_model.pkl")

# Load data from MySQL for a specific user
def load_user_data(user_id):
    query = f"SELECT user_id, amount, date_time FROM transactions WHERE user_id = {user_id};"
    df = pd.read_sql(query, engine)

    if df.empty:
        return None  

    df["date_time"] = pd.to_datetime(df["date_time"])
    df["year_month"] = df["date_time"].dt.to_period("M")

    # Group by month
    df = df.groupby("year_month")['amount'].sum().reset_index()

    return df

# Create features for a user
def create_features(user_data):
    if len(user_data) < 3:
        return None  

    user_data["prev_month_1"] = user_data["amount"].shift(1)
    user_data["prev_month_2"] = user_data["amount"].shift(2)
    user_data["prev_month_3"] = user_data["amount"].shift(3)
    user_data["avg_spending"] = user_data["amount"].rolling(3).mean()
    user_data["spending_variance"] = user_data["amount"].rolling(3).std()

    user_data.dropna(inplace=True)

    return user_data[["prev_month_1", "prev_month_2", "prev_month_3", "avg_spending", "spending_variance"]].iloc[-1:].values

# Predict Expense for a User
def predict_expense(user_id):
    data = load_user_data(user_id)
    if data is None:
        return None  

    features = create_features(data)

    # Fallback if not enough data
    if features is None:
        user_data = data["amount"]
        if len(user_data) == 1:
            return user_data.iloc[0]  
        elif len(user_data) == 2:
            return np.average(user_data, weights=[1, 2])  

    prediction = max(0, model.predict(features)[0])  
    return prediction

# Flask API for Predictions
app = Flask(__name__)

# @app.route("/predict", methods=["GET"])
# def get_prediction():
#     user_id = request.args.get("user_id", type=int)
    
#     if not user_id:
#         return jsonify({"error": "User ID is required"}), 400

#     predicted_amount = predict_expense(user_id)

#     if predicted_amount is None:
#         return jsonify({"error": "Not enough data to predict"}), 400

#     return jsonify({"user_id": user_id, "predicted_next_month_expense": predicted_amount})
@app.route("/predict", methods=["GET"])
def get_prediction():
    user_id = request.args.get("user_id", type=int)
    
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    predicted_amount = predict_expense(user_id)

    if predicted_amount is None:
        return jsonify({"error": "Not enough data to predict"}), 400

    return jsonify({"user_id": user_id, "predicted_next_month_expense": predicted_amount})


if __name__ == "__main__":
    app.run(debug=True)
