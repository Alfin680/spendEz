from flask import Flask, request, jsonify
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

        # Debug: Print email credentials
        print(f"Email Sender: {sender_email}")
        print(f"Email Password: {sender_password}")

        if not sender_email or not sender_password:
            return jsonify({"error": "Email credentials are not configured!"}), 500

        # Create the email message
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = email
        message["Subject"] = "Reset your SPENDEZ password"

        reset_link = "http://10.0.2.2:5000/reset-password"
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
    duration = request.args.get('duration', 'Month')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    today = datetime.today()

    if duration == "Week":
        start_date = today - timedelta(days=today.weekday())  # Get last Sunday
    elif duration == "Month":
        start_date = today.replace(day=1)  # Get 1st of the month
    elif duration == "Year":
        start_date = today.replace(month=1, day=1)  # Get January 1st
    else:
        return jsonify({"error": "Invalid duration"}), 400

    # ✅ Convert to SQL-compatible datetime format
    start_date = start_date.strftime('%Y-%m-%d %H:%M:%S')

    # ✅ Fetch transactions only from the selected duration
    query = """
    SELECT e.category, SUM(e.amount) as total_amount
    FROM transactions e
    WHERE e.user_id = %s AND e.date_time >= %s
    GROUP BY e.category
    """

    cursor.execute(query, (user_id, start_date))
    results = cursor.fetchall()

    cursor.close()
    conn.close()

    # ✅ Define Default Categories & Colors
    category_colors = {
        "Food": "#FFA500",
        "Travel": "#008000",
        "Bills": "#FF0000",
        "Fun": "#0000FF",
        "Other": "#800080",
        "Shopping": "#FF69B4"  # Add any other fixed categories
    }

    # ✅ Convert results to a dictionary for easy lookup
    result_dict = {item['category']: item['total_amount'] for item in results}

    # ✅ Calculate Total Spent
    total_spent = sum(result_dict.values())

    # ✅ Ensure all categories are included, even if 0
    categories = [
        {
            "name": category,
            "color": category_colors.get(category, "#808080"),  # Default Gray
            "amount": f"₹{result_dict.get(category, 0):.2f}",
            "percentage": f"{(result_dict.get(category, 0) / total_spent * 100):.1f}%" if total_spent > 0 else "0%"
        }
        for category in category_colors.keys()
    ]

    return jsonify({
        "total_spent": total_spent,
        "categories": categories
    })

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
    
@app.route('/food-spendings/<int:user_id>', methods=['GET'])
def get_food_spendings(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Fetch food expenses for the last 7 days
        query = """
        SELECT DATE(date_time) as date, SUM(amount) as total_amount
        FROM transactions
        WHERE user_id = %s AND category = 'Food' AND date_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY DATE(date_time)
        ORDER BY DATE(date_time)
        """
        cursor.execute(query, (user_id,))
        results = cursor.fetchall()

        cursor.close()
        conn.close()

        # Format results for the frontend
        spendings = {result['date']: result['total_amount'] for result in results}
        return jsonify(spendings), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@app.route('/budget-insights/<int:user_id>', methods=['GET'])
def get_budget_insights(user_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Fetch total budget (assuming it's stored in a budget table)
        cursor.execute("SELECT total_budget FROM budget WHERE user_id = %s", (user_id,))
        budget_result = cursor.fetchone()
        total_budget = budget_result['total_budget'] if budget_result else 0

        # Fetch total spent on food for the last 30 days
        query = """
        SELECT SUM(amount) as total_spent
        FROM transactions
        WHERE user_id = %s AND category = 'Food' AND date_time >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        """
        cursor.execute(query, (user_id,))
        spent_result = cursor.fetchone()
        total_spent = spent_result['total_spent'] if spent_result['total_spent'] else 0

        # Calculate budget left
        budget_left = total_budget - total_spent

        cursor.close()
        conn.close()

        return jsonify({
            "total_budget": total_budget,
            "total_spent": total_spent,
            "budget_left": budget_left
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route("/food-expense-history", methods=["GET"])
def get_food_expenses():
    user_id = request.args.get("user_id")

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    try:
        # Get the first day of last month
        today = datetime.date.today()
        first_day_last_month = (today.replace(day=1) - datetime.timedelta(days=1)).replace(day=1)
        last_day_last_month = today.replace(day=1) - datetime.timedelta(days=1)

        cur = mysql.connection.cursor()
        
        # Fetch total amount spent on Food category in last month
        query = """
            SELECT COALESCE(SUM(amount), 0) 
            FROM transactions 
            WHERE user_id = %s 
            AND category = 'Food' 
            AND date BETWEEN %s AND %s
        """
        
        cur.execute(query, (user_id, first_day_last_month, last_day_last_month))
        total_spent = cur.fetchone()[0]

        # Fetch daily food expenses for the last month
        query = """
            SELECT DATE(date) AS expense_date, SUM(amount) 
            FROM transactions 
            WHERE user_id = %s 
            AND category = 'Food' 
            AND date BETWEEN %s AND %s 
            GROUP BY DATE(date) 
            ORDER BY expense_date
        """
        cur.execute(query, (user_id, first_day_last_month, last_day_last_month))
        expense_data = cur.fetchall()
        
        cur.close()

        # Format response
        dates = [str(row[0]) for row in expense_data]
        expenses = [float(row[1]) for row in expense_data]

        return jsonify({
            "total_spent": float(total_spent),
            "dates": dates,
            "expenses": expenses
        })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/predict_expense', methods=['GET'])
def get_expense_prediction():
    user_id = request.args.get('user_id', type=int)  # Get the user_id from the query parameter

    if not user_id:
        return jsonify({'error': 'user_id is required'}), 400

    # Call the predict_expense function from predictor.py
    predicted_amount = predict_expense(user_id)

    if predicted_amount is None:
        return jsonify({'error': 'Not enough data to predict'}), 400

    return jsonify({'user_id': user_id, 'predicted_next_month_expense': predicted_amount})

        
if __name__ == '__main__':
    app.run(debug=True)