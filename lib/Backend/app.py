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

app = Flask(__name__)
CORS(app)

# MySQL connection setup
def get_db_connection():
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='njn@2003'
    )
    cursor = conn.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS finance_db")
    cursor.close()
    conn.close()

    # Reconnect to the newly created database
    conn = mysql.connector.connect(
        host='localhost',
        user='root',
        password='njn@2003',
        database='finance_db'
    )
    return conn


@app.route('/')
def home():
    return "Flask Backend is running"


# Sign-Up Endpoint to handle user registration
# @app.route('/signup', methods=['POST'])
# def signup():
#     try:
#         # Extract data from request
#         username = request.json['username']
#         email = request.json['email']
#         password = request.json['password']
#         # confirm_password = request.json.get('', 'User')  # Default role is 'User'

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
#                 _password VARCHAR(255),
#             )
#         """)
#         conn.commit()

#         # Check if the email or username already exists
#         cursor.execute("SELECT * FROM user WHERE email = %s OR username = %s", (email, username))
#         existing_user = cursor.fetchone()
#         if existing_user:
#             return jsonify({'error': 'Username or Email already exists'}), 400

#         # Insert user into the database (don't include UserID, it will auto-increment)
#         cursor.execute(
#             "INSERT INTO user (user_id, username, email, _password) VALUES (%s, %s, %s, %s)",
#             (username, email, hashed_password, role)
#         )
#         conn.commit()
@app.route('/signup', methods=['POST'])
def signup():
    try:
        # Extract data from request
        username = request.json['username']
        email = request.json['email']
        password = request.json['password']

        # Validate if passwords match

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

        # Insert the new user into the database
        cursor.execute("""
            INSERT INTO user (username, email, _password) 
            VALUES (%s, %s, %s)
        """, (username, email, hashed_password))
        conn.commit()

        return jsonify({"message": "User signed up successfully!"}), 201

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

        # Fetch the generated UserID using LAST_INSERT_ID()
        cursor.execute("SELECT LAST_INSERT_ID()")
        user_id = cursor.fetchone()[0]

        # Generate the formatted UserID (e.g., U0001, U0002)
        formatted_user_id = f'U{str(user_id).zfill(4)}'

        cursor.close()
        conn.close()

        return jsonify({'message': 'User signed up successfully!', 'UserID': formatted_user_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500




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
