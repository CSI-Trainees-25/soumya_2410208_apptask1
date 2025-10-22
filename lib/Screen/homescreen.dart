import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class Task {
  String title;
  String category;
  bool isDone;
  String description;

  Task({
    required this.title,
    this.category = 'General',
    this.isDone = false,
    required this.description,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final List<String> _categories = ['General', 'Work', 'Personal', 'Shopping'];
  List<Task> tasks = [];
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;
  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.calendar_month,
    Icons.person,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: Text(
          "INDEX",
          style: TextStyle(
            color: const Color.fromARGB(255, 252, 252, 252),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: buildbody()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: _showAddTaskSheet,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.grey[900],
        activeColor: Colors.deepPurpleAccent,
        inactiveColor: Colors.grey,
        iconSize: 28,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget buildbody() {
    if (tasks.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Checklist-rafiki 1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap + to add your tasks",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 0.75,
              ),
            ),
          ],
        ),
      );
    }

    // Group tasks by category
    Map<String, List<Task>> groupedTasks = {};
    for (var category in _categories) {
      groupedTasks[category] = tasks
          .where((task) => task.category == category)
          .toList();
    }

    // Display each category as a card
    return ListView(
      children: groupedTasks.entries.map((entry) {
        final category = entry.key;
        final categoryTasks = entry.value;

        // Skip empty categories to keep it clean
        if (categoryTasks.isEmpty) return SizedBox.shrink();

        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Icon(
                      Icons.category_rounded,
                      color: Colors.deepPurpleAccent.withOpacity(0.8),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, thickness: 0.8),
                const SizedBox(height: 4),

                // Tasks under this category
                ...categoryTasks.map((task) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.white70,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged: (val) {
                            setState(() {
                              task.isDone = val!;
                            });
                          },
                          activeColor: Colors.deepPurpleAccent,
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                        if (task.isDone)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                tasks.remove(task);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task deleted'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddTaskSheet() {
    _titleController.clear();
    _descriptionController.clear();

    String _selectedCategory = _categories.first;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.grey[900],
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      dropdownColor: Colors.grey[800],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        final String title = _titleController.text;
                        final String description = _descriptionController.text;
                        if (title.isNotEmpty) {
                          final newTask = Task(
                            title: title,
                            description: description,
                            category: _selectedCategory,
                          );
                          setState(() {
                            tasks.add(newTask);
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
