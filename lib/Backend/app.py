from datetime import datetime, timedelta
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from flask import Flask, jsonify, request
from predictor import predict_expense
from dotenv import load_dotenv
from flask import Flask, request, jsonify
import pandas as pd
import numpy as np




app = Flask(__name__)
CORS(app)
load_dotenv()



# MySQL connection setup
def get_db_connection():
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Alfin@2022',  
        database='finance_db'  
    )
    return conn

# Initialize database schema
def initialize_db():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Create user table if it doesn't exist
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS user (
            user_id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(255) NOT NULL,
            email VARCHAR(255) UNIQUE NOT NULL,
            _password VARCHAR(255) NOT NULL
        )
    """)

    # Create transactions table if it doesn't exist
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS transactions (
            transaction_id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            amount DECIMAL(10, 2) NOT NULL,
            expense_name VARCHAR(255) NOT NULL,
            category VARCHAR(255) NOT NULL,
            description TEXT,
            is_recurring BOOLEAN DEFAULT FALSE,
            date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
        )
    """)

    conn.commit()
    cursor.close()
    conn.close()

# Initialize the database schema when the app starts
initialize_db()

@app.route('/')
def home():
    return "Flask Backend is running"

@app.route('/signup', methods=['POST'])
def signup():
    try:
        username = request.json['username']
        email = request.json['email']
        password = request.json['password']

        hashed_password = generate_password_hash(password)
        conn = get_db_connection()
        cursor = conn.cursor()

        # Check if the email already exists
        cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
        if cursor.fetchone():
            return jsonify({"error": "Email already exists!"}), 400

        # Insert the new user
        cursor.execute("INSERT INTO user (username, email, _password) VALUES (%s, %s, %s)", 
                       (username, email, hashed_password))
        conn.commit()

        user_id = cursor.lastrowid  # Get the last inserted user ID

        cursor.close()
        conn.close()

        return jsonify({"message": "User signed up successfully!", "user_id": user_id, "username": username}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/login', methods=['POST'])
def login():
    try:
        email = request.json['email']
        password = request.json['password']

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT user_id, username, _password FROM user WHERE email = %s", (email,))
        user = cursor.fetchone()

        if not user:
            print("❌ User not found!")
            return jsonify({'error': 'Invalid email or password'}), 401

        user_id, username, stored_hashed_password = user
        print(f"🔍 Stored Hash: {stored_hashed_password}")
        print(f"🔍 Received Password: {password}")

        if not check_password_hash(stored_hashed_password, password):
            print("❌ Password does not match!")
            return jsonify({'error': 'Invalid email or password'}), 401

        print("✅ Login Successful!")
        return jsonify({'message': 'Login successful', 'user_id': user_id, 'username': username}), 200

    except Exception as e:
        print(f"⚠️ Error: {e}")
        return jsonify({'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# ✅ Forgot Password (Email Reset)
@app.route('/forgot-password', methods=['POST'])
def forgot_password():
    try:
        email = request.json.get('email')
        if not email:
            return jsonify({"error": "Email is required!"}), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({"error": "Email not found!"}), 404

        sender_email = os.getenv("EMAIL_SENDER")
        sender_password = os.getenv("EMAIL_PASSWORD")

        if not sender_email or not sender_password:
            return jsonify({"error": "Email credentials are not configured!"}), 500

        # Create the email message
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = email
        message["Subject"] = "Reset your SPENDEZ password"

        reset_link = "http://127.0.0.1:5000/reset-password"
        body = f"Click here to reset your password: {reset_link}"
        message.attach(MIMEText(body, "plain"))

        # Send the email
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, email, message.as_string())
        server.quit()

        return jsonify({"message": "Password reset email sent!"}), 200

    except smtplib.SMTPAuthenticationError:
        return jsonify({"error": "Invalid email credentials!"}), 500
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "An error occurred. Please try again later."}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# ✅ Save Transaction
@app.route('/transactions', methods=['POST'])
def save_transaction():
    try:
        user_id = request.json['user_id']
        amount = request.json['amount']
        expense_name = request.json['expense_name']
        category = request.json['category']
        description = request.json.get('description', '')
        is_recurring = request.json.get('is_recurring', False)

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO transactions (user_id, amount, expense_name, category, description, is_recurring)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (user_id, amount, expense_name, category, description, is_recurring))
        conn.commit()

        return jsonify({"message": "Transaction saved successfully!"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

# ✅ Get Transactions for a User
@app.route('/transactions/<int:user_id>', methods=['GET'])
def get_transactions(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT transaction_id, user_id, amount, expense_name, category, description, is_recurring, date_time 
            FROM transactions 
            WHERE user_id = %s 
            ORDER BY date_time DESC 

        """, (user_id,))
        
        transactions = cursor.fetchall()
        return jsonify(transactions), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.route('/insights/<int:user_id>', methods=['GET'])
def get_insights(user_id):
    """Fetch spending insights for a user based on the selected duration."""
    duration = request.args.get('duration', 'Month')

    # Validate duration parameter
    if duration not in ["Week", "Month", "Year"]:
        return jsonify({"error": "Invalid duration. Use 'Week', 'Month', or 'Year'."}), 400

    try:
        # Establish database connection
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Calculate start date based on duration
        today = datetime.today()
        if duration == "Week":
            # Correct week calculation (Monday as start of week)
            start_date = today - timedelta(days=today.weekday())
        elif duration == "Month":
            start_date = today.replace(day=1)  # Start of the month
        elif duration == "Year":
            start_date = today.replace(month=1, day=1)  # Start of the year

        # Convert to SQL-compatible date format (without time)
        start_date_str = start_date.strftime('%Y-%m-%d')

        # Debug print
        print(f"Calculated {duration} start date: {start_date_str}")

        # Fetch transactions for the selected duration
        query = """
        SELECT e.category, SUM(e.amount) as total_amount
        FROM transactions e
        WHERE e.user_id = %s AND DATE(e.date_time) >= %s
        GROUP BY e.category
        """
        cursor.execute(query, (user_id, start_date_str))
        results = cursor.fetchall()

        # Debug print
        print(f"Found {len(results)} transactions for {duration}")

        # Define default categories and colors
        category_colors = {
            "Food": "#FFA500",
            "Travel": "#008000",
            "Bills": "#FF0000",
            "Fun": "#0000FF",
            "Other": "#800080",
            "Shopping": "#FF69B4"
        }

        # Convert results to a dictionary for easy lookup
        result_dict = {item['category']: item['total_amount'] for item in results}

        # Calculate total spent
        total_spent = sum(result_dict.values())

        # Ensure all categories are included, even if 0
        categories = [
            {
                "name": category,
                "color": category_colors.get(category, "#808080"),  # Default gray for unknown categories
                "amount": f"₹{result_dict.get(category, 0):.2f}",
                "percentage": f"{(result_dict.get(category, 0) / total_spent * 100):.1f}%" if total_spent > 0 else "0%"
            }
            for category in category_colors.keys()
        ]

        # Close database connection
        cursor.close()
        conn.close()

        # Return response
        return jsonify({
            "total_spent": total_spent,
            "categories": categories
        })

    except mysql.connector.Error as err:
        # Handle database errors
        return jsonify({"error": f"Database error: {err}"}), 500
    except Exception as e:
        # Handle other unexpected errors
        return jsonify({"error": f"An unexpected error occurred: {e}"}), 500
    
@app.route('/tips', methods=['GET'])
def get_finance_tips():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, tip FROM finance_tips ORDER BY RAND() LIMIT 20;")
    tips = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify([{"id": tip[0], "tip": tip[1]} for tip in tips])

@app.route('/category-total', methods=['GET'])
def get_category_total():
    try:
        user_id = request.args.get('user_id', type=int)
        category = request.args.get('category', type=str)

        if not user_id or not category:
            return jsonify({"error": "Missing user_id or category"}), 400

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        query = """
        SELECT SUM(amount) AS total_spent
        FROM transactions
        WHERE user_id = %s AND category = %s
        """
        cursor.execute(query, (user_id, category))
        result = cursor.fetchone()

        total_spent = result['total_spent'] if result['total_spent'] else 0

        cursor.close()
        conn.close()

        return jsonify({"total_spent": total_spent})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/category-spending-week', methods=['GET'])
def category_spending_week():
    user_id = request.args.get('user_id')
    category = request.args.get('category')
    
    if not user_id or not category:
        return jsonify({"error": "user_id and category are required"}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Calculate the start date (7 days ago)
    end_date = datetime.today()
    start_date = end_date - timedelta(days=7)

    # Fetch spending data for the last 7 days for the specified category
    query = """
    SELECT DATE(date_time) as date, SUM(amount) as total_amount
    FROM transactions
    WHERE user_id = %s AND category = %s AND date_time >= %s
    GROUP BY DATE(date_time)
    ORDER BY DATE(date_time)
    """
    cursor.execute(query, (user_id, category, start_date))
    results = cursor.fetchall()

    cursor.close()
    conn.close()

    # Prepare data for the response
    spendings = []
    labels = []
    current_date = start_date
    while current_date <= end_date:
        date_str = current_date.strftime('%b %d')  # Format: "Aug 12"
        amount = next((item['total_amount'] for item in results if item['date'] == current_date.date()), 0)
        spendings.append(amount)
        labels.append(date_str)
        current_date += timedelta(days=1)

    return jsonify({
        "spendings": spendings,
        "labels": labels
    })


@app.route('/category-budget-spent', methods=['GET'])
def category_budget_spent():
    user_id = request.args.get('user_id')
    category = request.args.get('category')
    
    if not user_id or not category:
        return jsonify({"error": "user_id and category are required"}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Calculate the start date (1st of the current month)
    today = datetime.today()
    start_date = today.replace(day=1)

    # Fetch total budget spent for the specified category for the current month
    query = """
    SELECT SUM(amount) as total_spent
    FROM transactions
    WHERE user_id = %s AND category = %s AND date_time >= %s
    """
    cursor.execute(query, (user_id, category, start_date))
    result = cursor.fetchone()

    cursor.close()
    conn.close()

    total_spent = result['total_spent'] if result['total_spent'] else 0

    return jsonify({
        "budget_spent": total_spent
    })


@app.route('/transactions/delete', methods=['DELETE'])
def delete_transactions():
    try:
        transaction_ids = request.json.get('transaction_ids', [])
        if not transaction_ids:
            return jsonify({"error": "No transaction IDs provided"}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        placeholders = ', '.join(['%s'] * len(transaction_ids))
        query = f"DELETE FROM transactions WHERE transaction_id IN ({placeholders})"

        cursor.execute(query, tuple(transaction_ids))  # Pass values as a tuple
        conn.commit()

        return jsonify({"message": f"Deleted {cursor.rowcount} transactions successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.route("/predict", methods=["GET"])
def get_prediction():
    user_id = request.args.get("user_id", type=int)
    
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    predicted_amount = predict_expense(user_id)

    if predicted_amount is None:
        return jsonify({"error": "Not enough data to predict"}), 400

    return jsonify({"user_id": user_id, "predicted_next_month_expense": predicted_amount})



def fetch_user_transactions(user_id):
    connection = get_db_connection()
    if not connection:
       return None
    
    query = f"SELECT category, amount, date_time FROM transactions WHERE user_id = {user_id}"
    cursor = connection.cursor(dictionary=True)
    cursor.execute(query)
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    
    if not rows:
        return None
    
    df = pd.DataFrame(rows)
    df["date_time"] = pd.to_datetime(df["date_time"])
    df["amount"] = df["amount"].astype(float)

    return df


def calculate_budget_allocation(data, predicted_amount):
    categories = {
        "Needs": ["Food", "Bills", "Rent"],
        "Wants": ["Fun", "Shopping", "Travel"],
        "Savings": ["Other"]
    }

    other_percentage = np.random.uniform(0.05, 0.10)
    other_amount = predicted_amount * other_percentage
    remaining_budget = predicted_amount - other_amount

    savings_percentage = np.random.uniform(0.10, 0.15)
    savings_amount = remaining_budget * savings_percentage
    remaining_budget -= savings_amount  

    budget_allocation = {
        "Needs": remaining_budget * 0.50,
        "Wants": remaining_budget * 0.30,
        "Savings": remaining_budget * 0.20  
    }

    allocation_result = {}
    needs_total = budget_allocation["Needs"]
    variations = np.random.uniform(0.90, 1.10, len(categories["Needs"]))
    needs_allocations = (needs_total * variations) / variations.sum()

    for i, category in enumerate(categories["Needs"]):
        allocation_result[category] = needs_allocations[i]

    wants_total = budget_allocation["Wants"]
    past_spending = data.groupby("category")["amount"].sum()

    for category in categories["Wants"]:
        past_ratio = past_spending.get(category, 1) / past_spending.sum() if past_spending.sum() > 0 else 1 / len(categories["Wants"])
        allocation_result[category] = wants_total * past_ratio

    allocation_result["Other"] = other_amount
    allocation_result["Savings"] = savings_amount  

    total_allocated = sum(allocation_result.values())
    scale_factor = predicted_amount / total_allocated
    for category in allocation_result:
        allocation_result[category] *= scale_factor
    
    return allocation_result

@app.route("/budget-allocation", methods=["GET"])
def budget_allocation():
    #user_id = session.get("user_id")  
    user_id = request.args.get("user_id", type=int)
    if not user_id:
        return jsonify({"error": "User not logged in"}), 401

    predicted_amount = predict_expense(user_id)  # Get predicted expense
    if predicted_amount is None:
        return jsonify({"error": "Not enough data to predict"}), 400
    
    data = fetch_user_transactions(user_id)
    if data is None or data.empty:
        return jsonify({"error": "No transaction data found"}), 404

    allocation = calculate_budget_allocation(data, predicted_amount)

    return jsonify({
        "user_id": user_id,
        "predicted_amount": predicted_amount,
        "budget_allocation": allocation
    })




if __name__ == '__main__':
    app.run(debug=True)