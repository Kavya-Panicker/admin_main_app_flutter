import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String name;
  final DateTime date;

  Event({required this.name, required this.date});
}

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List<Event>> events = {};
  TextEditingController eventNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  void _initializeEvents() {
    List<Event> initialEvents = [
      Event(name: "New Year's Celebration", date: DateTime(2025, 1, 1)),
      Event(name: "Company Annual Meetup", date: DateTime(2025, 2, 15)),
      Event(name: "Holi Festival", date: DateTime(2025, 3, 24)),
      Event(name: "Employee Appreciation Day", date: DateTime(2025, 3, 3)),
      Event(name: "Easter Celebration", date: DateTime(2025, 4, 20)),
      Event(name: "Earth Day Awareness", date: DateTime(2025, 4, 22)),
      Event(name: "International Yoga Day", date: DateTime(2025, 6, 21)),
      Event(name: "Independence Day", date: DateTime(2025, 8, 15)),
      Event(name: "Onam Festival", date: DateTime(2025, 9, 8)),
      Event(name: "Diwali Celebration", date: DateTime(2025, 10, 23)),
      Event(name: "Halloween Party", date: DateTime(2025, 10, 31)),
      Event(name: "Thanksgiving Dinner", date: DateTime(2025, 11, 28)),
      Event(name: "Christmas Celebration", date: DateTime(2025, 12, 25)),
      Event(name: "Company Hackathon", date: DateTime(2025, 7, 12)),
      Event(name: "Office Sports Day", date: DateTime(2025, 9, 20)),
    ];

    for (var event in initialEvents) {
      DateTime eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      if (events[eventDate] == null) {
        events[eventDate] = [];
      }
      events[eventDate]!.add(event);
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: "Event Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (eventNameController.text.isNotEmpty) {
                  setState(() {
                    DateTime selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
                    if (events[selectedDate] == null) {
                      events[selectedDate] = [];
                    }
                    events[selectedDate]!.add(Event(name: eventNameController.text, date: selectedDate));
                  });

                  eventNameController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            headerStyle: HeaderStyle(formatButtonVisible: false),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay)
                  .map((event) => Card(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: Icon(Icons.event, color: Colors.blue),
                          title: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${event.date.day}-${event.date.month}-${event.date.year}"),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
        tooltip: "Add Event",
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(height: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
