const API_URL = process.env.REACT_APP_API_URL;

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");

  useEffect(() => {
    fetch(`${API_URL}/api/tasks`)
      .then((response) => response.json())
      .then((data) => setTasks(data));
  }, []);

  const addTask = async () => {
    if (!newTask) return;
    const response = await fetch(`${API_URL}/api/tasks`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ task: newTask }),
    });
    const task = await response.json();
    setTasks([...tasks, task]);
    setNewTask("");
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
