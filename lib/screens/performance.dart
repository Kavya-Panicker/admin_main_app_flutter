 import 'package:flutter/material.dart';
 import 'package:fl_chart/fl_chart.dart';
 

 class PerformanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text(
      "Attendance Performance",
      style: TextStyle(fontWeight: FontWeight.bold),
     ),
     centerTitle: true,
     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
     elevation: 0,
    ),
    backgroundColor: Colors.grey[100],
    body: Padding(
     padding: const EdgeInsets.all(16.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
       // Dashboard Sections
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         _buildDashboardSection(
          "Total Present",
          "120",
          Icons.check_circle,
          Colors.green,
          context,
         ),
         _buildDashboardSection(
          "Total Absent",
          "15",
          Icons.cancel,
          Colors.red,
          context,
         ),
        ],
       ),
       SizedBox(height: 20),
 

       // Attendance Trends Chart
       Container(
        decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(12),
         boxShadow: [
          BoxShadow(
           color: Colors.grey.withOpacity(0.3),
           spreadRadius: 1,
           blurRadius: 5,
           offset: Offset(0, 3),
          ),
         ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(
           "Attendance Trends",
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildAttendanceChart(),
         ],
        ),
       ),
      ],
     ),
    ),
   );
  }
 

  Widget _buildDashboardSection(
    String title, String value, IconData icon, Color color, BuildContext context) {
   return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
     padding: EdgeInsets.all(12),
     width: MediaQuery.of(context).size.width * 0.4,
     child: Column(
      children: [
       Icon(icon, size: 32, color: color),
       SizedBox(height: 8),
       Text(title,
         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
       Text(value, style: TextStyle(fontSize: 18, color: color)),
      ],
     ),
    ),
   );
  }
 

  Widget _buildAttendanceChart() {
   return AspectRatio(
    aspectRatio: 1.5,
    child: LineChart(
     LineChartData(
      gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
       leftTitles: AxisTitles(
        sideTitles: SideTitles(
         showTitles: true,
         reservedSize: 30,
         getTitlesWidget: (value, meta) {
          return Text(value.toInt().toString());
         },
        ),
       ),
       bottomTitles: AxisTitles(
        sideTitles: SideTitles(
         showTitles: true,
         getTitlesWidget: (value, meta) {
          return Text(value.toInt().toString());
         },
        ),
       ),
       topTitles: AxisTitles(
         sideTitles: SideTitles(showTitles: false),
       ),
       rightTitles: AxisTitles(
         sideTitles: SideTitles(showTitles: false),
       ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
       LineChartBarData(
        spots: [
         FlSpot(1, 95),
         FlSpot(2, 92),
         FlSpot(3, 88),
         FlSpot(4, 91),
         FlSpot(5, 90),
        ],
        isCurved: true,
        color: Colors.blueAccent,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
         show: true,
         color: Colors.blue.withOpacity(0.2),
        ),
       ),
      ],
     ),
    ),
   );
  }
 }
