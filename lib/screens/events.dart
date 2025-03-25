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
 

 class _EventsScreenState extends State<EventsScreen> with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _showCalendar = false;
 

  Map<DateTime, List<Event>> events = {};
  TextEditingController eventNameController = TextEditingController();
 

  late TabController _tabController; // Declare TabController
 

  @override
  void initState() {
  super.initState();
  _initializeEvents();
  _tabController = TabController(length: 2, vsync: this); // Initialize TabController
  }
 

  @override
  void dispose() {
  _tabController.dispose(); // Dispose of the controller
  super.dispose();
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
  Event(name: "Project Deadline", date: DateTime.now()),
  Event(name: "Team Lunch", date: DateTime.now()),
  Event(name: "Client Meeting", date: DateTime.now()),
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
  DateTime selectedDate = DateTime(
  _selectedDay.year, _selectedDay.month, _selectedDay.day);
  if (events[selectedDate] == null) {
  events[selectedDate] = [];
  }
  events[selectedDate]!
  .add(Event(name: eventNameController.text, date: selectedDate));
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
  return DefaultTabController(
  length: 2,
  child: Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.blue,
  leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.white),
  onPressed: () => Navigator.pop(context),
  ),
  title: Text("Events", style: TextStyle(color: Colors.white)),
  actions: [
  TextButton(
  onPressed: () {
  // Handle upcoming events
  },
  child: Text(
  "View Upcoming Events",
  style: TextStyle(color: Colors.white),
  ),
  ),
  ],
  bottom: PreferredSize(
  preferredSize: Size.fromHeight(100),
  child: Column(
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  InkWell(
  onTap: () {
  setState(() {
  _showCalendar = !_showCalendar;
  });
  },
  child: Row(
  children: [
  Text(
  "${_selectedDay.day} ",
  style: TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  ),
  ),
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  "${_selectedDay.month} Mar ${_selectedDay.year}",
  style: TextStyle(color: Colors.white70),
  ),
  Text(
  "${_selectedDay.weekday}",
  style: TextStyle(color: Colors.white70),
  ),
  ],
  ),
  Icon(Icons.arrow_drop_down, color: Colors.white),
  ],
  ),
  ),
  Row(
  children: [
  Text(
  "Today's Joinees: 00 ",
  style: TextStyle(color: Colors.white),
  ),
  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
  ],
  ),
  ],
  ),
  ),
  TabBar(
  controller: _tabController, // Use the explicit TabController
  tabs: [
  Tab(text: "My Team"),
  Tab(text: "My Org"),
  ],
  labelColor: Colors.white,
  unselectedLabelColor: Colors.grey[300],
  indicatorColor: Colors.white,
  ),
  ],
  ),
  ),
  ),
  body: Column(
  children: [
  if (_showCalendar)
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
  _showCalendar = false;
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
  Expanded(
  child: TabBarView(
  controller: _tabController, // Use the same explicit TabController
  children: [
  // Tab "My Team"
  _getEventsForDay(_selectedDay).isEmpty
  ? Center(
  child: Text(
  "Seems like there are no Occasions.",
  style: TextStyle(color: Colors.grey),
  ),
  )
  : ListView(
  children: _getEventsForDay(_selectedDay)
  .map((event) => Card(
  child: ListTile(
  title: Text(event.name),
  subtitle: Text(
  "${event.date.day}-${event.date.month}-${event.date.year}"),
  ),
  ))
  .toList(),
  ),
  // Tab "My Org"
  Center(
  child: Text("No data for 'My Org' tab."),
  ),
  ],
  ),
  ),
  ],
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: _addEvent,
  child: Icon(Icons.add),
  tooltip: "Add Event",
  ),
  ),
  );
  }
 }
 
