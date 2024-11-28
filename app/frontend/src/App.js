import React, { useState, useEffect } from "react";

// Use the environment variable for the backend URL
const BACKEND_URL = process.env.TODO_APP_BACKEND_URL || "http://todo-app-backend.todo-webapp.svc.cluster.local:5000";
console.log("Backend URL being used:", process.env.TODO_APP_BACKEND_URL);

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");

  useEffect(() => {
    console.log("Fetching tasks from:", `${BACKEND_URL}/api/tasks`);
    fetch(`${BACKEND_URL}/api/tasks`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to fetch tasks");
        }
        return response.json();
      })
      .then((data) => setTasks(data))
      .catch((error) => console.error("Error fetching tasks:", error));
  }, []);

  const addTask = async () => {
    if (!newTask) return;

    try {
      console.log("Task adding using backend URL:", `${BACKEND_URL}/api/tasks`);
      const response = await fetch(`${BACKEND_URL}/api/tasks`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ task: newTask }),
      });

      if (!response.ok) {
        throw new Error("Failed to add task");
      }

      const task = await response.json();
      setTasks([...tasks, task]);
      setNewTask("");
    } catch (error) {
      console.error("Error adding task:", error);
    }
  };

  return (
    <div>
      <h1>To-Do List</h1>
      <ul>
        {tasks.map((task) => (
          <li key={task.id}>{task.task}</li>
        ))}
      </ul>
      <input
        type="text"
        value={newTask}
        onChange={(e) => setNewTask(e.target.value)}
        placeholder="Add a new task"
      />
      <button onClick={addTask}>Add Task</button>
    </div>
  );
}

export default App;
