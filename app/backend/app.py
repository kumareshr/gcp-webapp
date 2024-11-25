from flask import Flask, request, jsonify
import os
import psycopg2

app = Flask(__name__)

# Database configuration from environment variables
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "todo_db")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")

# Connect to the database


def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )


@app.route("/api/tasks", methods=["GET"])
def get_tasks():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, task FROM tasks;")
    tasks = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify([{"id": t[0], "task": t[1]} for t in tasks])


@app.route("/api/tasks", methods=["POST"])
def add_task():
    data = request.json
    if not data or "task" not in data:
        return jsonify({"error": "Task content is required"}), 400

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO tasks (task) VALUES (%s) RETURNING id;", (data["task"],))
    task_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"id": task_id, "task": data["task"]}), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)