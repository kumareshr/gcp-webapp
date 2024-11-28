from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import mysql.connector

app = Flask(__name__)

# Enable CORS for all routes with specific origins
CORS(app, resources={r"/api/*": {"origins": "*"}})

# Database configuration from environment variables (passed via Kubernetes secrets)
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")


def get_db_connection():
    """Establish and return a database connection."""
    return mysql.connector.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )


@app.route("/api/tasks", methods=["GET"])
def get_tasks():
    """Retrieve all tasks from the database."""
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, task FROM tasks;")
    tasks = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify([{"id": t[0], "task": t[1]} for t in tasks])


@app.route("/api/tasks", methods=["POST"])
def add_task():
    """Add a new task to the database."""
    data = request.json
    if not data or "task" not in data:
        return jsonify({"error": "Task content is required"}), 400

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO tasks (task) VALUES (%s);", (data["task"],))
    conn.commit()
    task_id = cur.lastrowid
    cur.close()
    conn.close()
    return jsonify({"id": task_id, "task": data["task"]}), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
