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

app = Flask(__name__)  # Corrected to use __name__

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

if __name__ == '__main__':  #Corrected to use __name__
    app.run(debug=True)
