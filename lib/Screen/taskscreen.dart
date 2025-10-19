import 'package:flutter/material.dart';

class Task {
  String title;
  String category;
  bool isDone;

  Task({required this.title, this.category = 'General', this.isDone = false});
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskcontroller = TextEditingController();
  List<Task> tasks = [];

  void addTask(String title, String category) {
    setState(() {
      tasks.add(Task(title: title, category: category, isDone: false));
    });
    _taskcontroller.clear();
    Navigator.pop(context);
  }

  void editTask(int index, String newTitle, String newCategory) {
    setState(() {
      tasks[index].title = newTitle;
      tasks[index].category = newCategory;
    });
    Navigator.pop(context);
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void showTaskDialog({int? index}) {
    bool isEditing = index != null;
    String selectedCategory = isEditing ? tasks[index!].category : 'General';
    if (isEditing) {
      _taskcontroller.text = tasks[index].title;
    } else {
      _taskcontroller.clear();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            isEditing ? "Edit Task" : "Add Task",
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskcontroller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter Task Title",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: Colors.grey[850],
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                items: ['General', 'Work', 'Home', 'Other']
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setStateDialog(() => selectedCategory = v);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (isEditing) {
                  editTask(index!, _taskcontroller.text, selectedCategory);
                } else {
                  addTask(_taskcontroller.text, selectedCategory);
                }
              },
              child: Text(isEditing ? "Save" : "Add"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.deepPurple,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => toggleTask(index),
                      activeColor: Colors.deepPurple,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      task.category,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.lightBlue),
                          onPressed: () => showTaskDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
