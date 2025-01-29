# from flask import Flask, request, jsonify
# import mysql.connector

# app = Flask(_name_)

# # MySQL connection setup
# def get_db_connection():
#     conn = mysql.connector.connect(
#         host='localhost',
#         user='root',
#         password='njn@2003'
#     )
#     cursor = conn.cursor()
#     cursor.execute("CREATE DATABASE IF NOT EXISTS finance_db")
#     cursor.close()
#     conn.close()

#     # Reconnect to the newly created database
#     conn = mysql.connector.connect(
#         host='localhost',
#         user='root',
#         password='njn@2003',
#         database='finance_db'
#     )
#     return conn


# @app.route('/')
# def home():
#     return "Flask Backend is running"

# # Example API endpoint to fetch data from the database
# # @app.route('/transactions', methods=['GET'])
# # def get_transactions():
# #     conn = get_db_connection()
# #     cursor = conn.cursor(dictionary=True)
# #     cursor.execute("SELECT * FROM transactions")
# #     transactions = cursor.fetchall()
# #     cursor.close()
# #     conn.close()
# #     return jsonify(transactions)

# if _name_ == '_main_':
#     app.run(debug=True)from flask import Flask, jsonify
import mysql.connector
from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash
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
        password='Alfin@2022'
    )
    cursor = conn.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS finance_db")
    cursor.close()
    conn.close()

    # Reconnect to the newly created database
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Alfin@2022',
        database='finance_db'
    )
    return conn


@app.route('/')
def home():
    return "Flask Backend is running"


# @app.route('/signup', methods=['POST'])
# def signup():
#     try:
#         # Extract data from request
#         username = request.json['username']
#         email = request.json['email']
#         password = request.json['password']

#         # Validate if passwords match

#         # Hash the password
#         hashed_password = generate_password_hash(password)

#         conn = get_db_connection()
#         cursor = conn.cursor()

#         # Ensure the users table exists with the required columns
#         cursor.execute("""
#             CREATE TABLE IF NOT EXISTS user (
#                 user_id INT AUTO_INCREMENT PRIMARY KEY,
#                 username VARCHAR(255) NOT NULL,
#                 email VARCHAR(255) UNIQUE,
#                 _password VARCHAR(255)
#             )
#         """)
#         conn.commit()

#         # Insert the new user into the database
#         cursor.execute("""
#             INSERT INTO user (username, email, _password) 
#             VALUES (%s, %s, %s)
#         """, (username, email, hashed_password))
#         conn.commit()

#         return jsonify({"message": "User signed up successfully!"}), 201

#     except Exception as e:
#         print(f"Error: {e}")
#         return jsonify({"error": str(e)}), 500

#         # Fetch the generated UserID using LAST_INSERT_ID()
#         cursor.execute("SELECT LAST_INSERT_ID()")
#         user_id = cursor.fetchone()[0]

#         # Generate the formatted UserID (e.g., U0001, U0002)
#         formatted_user_id = f'U{str(user_id).zfill(4)}'

#         cursor.close()
#         conn.close()

#         return jsonify({'message': 'User signed up successfully!', 'UserID': formatted_user_id}), 201
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

@app.route('/signup', methods=['POST'])
def signup():
    try:
        # Extract data from request
        username = request.json['username']
        email = request.json['email']
        password = request.json['password']

        # Validate if passwords match (if needed)
        # If you need a confirm password field, validate it here.

        # Hash the password
        hashed_password = generate_password_hash(password)

        conn = get_db_connection()
        cursor = conn.cursor()

        # Ensure the users table exists with the required columns
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS user (
                user_id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE,
                _password VARCHAR(255)
            )
        """)
        conn.commit()

        # Check if the email already exists
        cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
        existing_user = cursor.fetchone()
        if existing_user:
            return jsonify({"error": "Email already exists!"}), 400

        # Insert the new user into the database
        cursor.execute("""
            INSERT INTO user (username, email, _password) 
            VALUES (%s, %s, %s)
        """, (username, email, hashed_password))
        conn.commit()

        # Fetch the generated UserID using LAST_INSERT_ID()
        cursor.execute("SELECT LAST_INSERT_ID()")
        user_id = cursor.fetchone()[0]

        # Generate the formatted UserID (e.g., U0001, U0002)
        formatted_user_id = f'U{str(user_id).zfill(4)}'

        cursor.close()
        conn.close()

        return jsonify({'message': 'User signed up successfully!', 'UserID': formatted_user_id}), 201

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/login', methods=['POST'])
def login():
    try:
        # Extract data from request
        email = request.json['email']
        password = request.json['password']
        
        # Establish database connection
        conn = get_db_connection()
        cursor = conn.cursor()

        # Query to find user by username
        cursor.execute("SELECT user_id, email, _password FROM user WHERE email = %s", (email,))
        user = cursor.fetchone()

        # If user not found
        if user is None:
            return jsonify({'error': 'Invalid username or password'}), 401

        # Compare the entered password with the stored hashed password
        stored_hashed_password = user[2]
        if not check_password_hash(stored_hashed_password, password):
            return jsonify({'error': 'Invalid username or password'}), 401

        # Return success message with user details (you can also generate a token for auth)
        return jsonify({'message': 'Login successful', 'user_id': user[0], 'username': user[1]}), 200

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@app.route('/forgot-password', methods=['POST'])
def forgot_password():
    try:
        # Get the email from the request
        email = request.json['email']

        # Check if the email exists in your database
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user:
            # If user exists, send a reset email
            sender_email = "spendezzzz@gmail.com"
            receiver_email = email
            password = "spendEz@24"  # Use an app-specific password or environment variable for security

            # Set up the MIME
            message = MIMEMultipart()
            message["From"] = sender_email
            message["To"] = receiver_email
            message["Subject"] = "Reset your SPENDEZ password"

            body = "Click here to reset your password: http://10.0.2.2:5000/reset-password"
            message.attach(MIMEText(body, "plain"))

            # Send email
            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.starttls()
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, message.as_string())
            server.quit()

            return jsonify({"message": "Password reset email sent!"}), 200
        else:
            return jsonify({"error": "Email not found!"}), 404

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500      

# Example API endpoint to fetch data from the database
@app.route('/transactions', methods=['GET'])
def get_transactions():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Ensure the table exists before querying
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS transactions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            description VARCHAR(255),
            amount DECIMAL(10, 2),
            date DATE
        )
    """)
    conn.commit()

    cursor.execute("SELECT * FROM transactions")
    transactions = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(transactions)


if __name__ == '__main__':
    app.run(debug=True)
