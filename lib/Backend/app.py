from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

app = Flask(__name__)
CORS(app)

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

# ✅ User Signup
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
        formatted_user_id = f'U{str(user_id).zfill(4)}'

        cursor.close()
        conn.close()

        return jsonify({"message": "User signed up successfully!", "user_id": formatted_user_id, "username": username}), 201

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
        email = request.json['email']
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({"error": "Email not found!"}), 404

        sender_email = os.getenv("EMAIL_SENDER")
        sender_password = os.getenv("EMAIL_PASSWORD")  # Use environment variable for security

        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = email
        message["Subject"] = "Reset your SPENDEZ password"

        reset_link = "http://10.0.2.2:5000/reset-password"
        message.attach(MIMEText(f"Click here to reset your password: {reset_link}", "plain"))

        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, email, message.as_string())
        server.quit()

        return jsonify({"message": "Password reset email sent!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
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
            LIMIT 10
        """, (user_id,))
        
        transactions = cursor.fetchall()
        return jsonify(transactions), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.route('/tips', methods=['GET'])
def get_finance_tips():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, tip FROM finance_tips ORDER BY RAND() LIMIT 20;")
    tips = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify([{"id": tip[0], "tip": tip[1]} for tip in tips])
        
if __name__ == '__main__':
    app.run(debug=True)