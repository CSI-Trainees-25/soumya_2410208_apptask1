import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'homescreen.dart';

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  const CalendarScreen({super.key, required this.tasks});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Task>> _tasksByDay;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late List<Task> _selectedTasks;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _tasksByDay = _groupTasksByDay(widget.tasks);
    _selectedTasks = _getTasksForDay(_selectedDay!);
  }

  Map<DateTime, List<Task>> _groupTasksByDay(List<Task> tasks) {
    Map<DateTime, List<Task>> map = {};
    for (var task in tasks) {
      DateTime date = DateTime(task.date.year, task.date.month, task.date.day);
      if (map[date] == null) {
        map[date] = [];
      }
      map[date]!.add(task);
    }
    return map;
  }

  List<Task> _getTasksForDay(DateTime day) {
    DateTime date = DateTime(day.year, day.month, day.day);
    return _tasksByDay[date] ?? [];
  }

  Widget build(BuildContext context) {
    _tasksByDay = _groupTasksByDay(widget.tasks);
    _selectedTasks = _getTasksForDay(_selectedDay!);
    return Column(
      children: [
        TableCalendar<Task>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          // This is where the highlighting happens!
          eventLoader: _getTasksForDay,
          // Styling the calendar
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.white70),
            outsideTextStyle: TextStyle(color: Colors.white30),
            todayDecoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              shape: BoxShape.circle,
            ),
            // Style for the event markers (the dots)
            markerDecoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.white70),
            weekdayStyle: TextStyle(color: Colors.white),
          ),
          // --- Logic ---
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedTasks = _getTasksForDay(selectedDay);
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Divider(color: Colors.white24),
        ),
        // --- List of tasks for the selected day ---
        Expanded(
          child: _selectedTasks.isEmpty
              ? Center(
                  child: Text(
                    "No tasks for this day",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _selectedTasks.length,
                  itemBuilder: (context, index) {
                    final task = _selectedTasks[index];
                    return ListTile(
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
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Checkbox(
                        value: task.isDone,
                        onChanged: (val) {
                          // This will NOT work directly.
                          // You need to pass a function from home_screen
                          // to handle state updates.
                          // For now, we'll just show the UI.
                          print("Checkbox tapped (state not updated here)");
                        },
                        activeColor: Colors.deepPurpleAccent,
                        checkColor: Colors.white,
                        side: BorderSide(color: Colors.white54),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
