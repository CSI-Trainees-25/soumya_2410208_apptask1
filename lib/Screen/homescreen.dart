import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'CalendarScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;
  String category;
  bool isDone;
  String description;
  DateTime date;

  Task({
    required this.title,
    this.category = 'General',
    this.isDone = false,
    required this.description,
    required this.date,
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
    final pages = <Widget>[
      buildTaskListBody(),
      CalendarScreen(tasks: tasks),
      const Center(
        child: Text("Profile Page", style: TextStyle(color: Colors.white)),
      ),
      const Center(
        child: Text("Settings Page", style: TextStyle(color: Colors.white)),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Tasks",
          style: TextStyle(
            color: const Color.fromARGB(255, 252, 252, 252),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: pages[_currentIndex]),
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

  Widget buildTaskListBody() {
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

    Map<String, List<Task>> groupedTasks = {};
    for (var category in _categories) {
      groupedTasks[category] = tasks
          .where((task) => task.category == category)
          .toList();
    }

    final populatedEntries = groupedTasks.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: populatedEntries.map((entry) {
          final category = entry.key;
          final categoryTasks = entry.value;

          final double cardWidth =
              (MediaQuery.of(context).size.width - 24 - 12) / 2;

          return SizedBox(
            width: cardWidth,
            child: Card(
              color: Colors.grey[900],
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                title: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 207, 195, 239),
                    letterSpacing: 1.1,
                  ),
                ),

                backgroundColor: Colors.grey[850],
                collapsedBackgroundColor: Colors.grey[900],
                iconColor: Colors.deepPurpleAccent,
                collapsedIconColor: Colors.deepPurpleAccent,
                textColor: Colors.white10,
                collapsedTextColor: Colors.deepPurpleAccent,

                children: [
                  Column(
                    children: [
                      const Divider(
                        color: Colors.white24,
                        thickness: 0.8,
                        height: 1,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: categoryTasks.map((task) {
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (task.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4.0,
                                      ),
                                      child: Text(
                                        task.description,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          decoration: task.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    DateFormat.yMMMd().format(task.date),
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent[100],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
                                    side: const BorderSide(
                                      color: Colors.white54,
                                    ),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Task deleted'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        _showAddTaskSheet(taskToEdit: task);
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAddTaskSheet({Task? taskToEdit}) {
    final bool isEditing = taskToEdit != null;
    if (isEditing) {
      _titleController.text = taskToEdit.title;
      _descriptionController.text = taskToEdit.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    String _selectedCategory = _categories.first;
    DateTime? _selectedDate;
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
                      value: _selectedCategory,
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
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            Duration(days: 365),
                          ),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setModalState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white70),
                          SizedBox(width: 10),
                          Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final String title = _titleController.text;
                        final String description = _descriptionController.text;

                        if (title.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a task title.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a date.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final newTask = Task(
                          title: title,
                          description: description,
                          category: _selectedCategory,
                          date: _selectedDate!,
                        );
                        setState(() {
                          tasks.add(newTask);
                        });
                        Navigator.pop(context);
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

  void _savedata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  }
}
