import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

void main() {
  runApp(MaterialApp(home: PayrollScreen()));
}

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  String? selectedMonth;
  String? selectedYear;

  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  final List<String> years = ["2023", "2024", "2025"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payroll Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Month & Year", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: selectedMonth,
                    hint: Text("Select Month"),
                    onChanged: (value) => setState(() => selectedMonth = value),
                    items: months.map((month) => DropdownMenuItem(value: month, child: Text(month))).toList(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: selectedYear,
                    hint: Text("Select Year"),
                    onChanged: (value) => setState(() => selectedYear = value),
                    items: years.map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (selectedMonth != null && selectedYear != null)
              Expanded(child: PayslipView(selectedMonth!, selectedYear!)),
            SizedBox(height: 20),

            // View Salary History Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SalaryHistoryScreen()));
                },
                icon: Icon(Icons.history),
                label: Text("View Salary History"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayslipView extends StatelessWidget {
  final String month;
  final String year;

  PayslipView(this.month, this.year);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Payslip", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Company Name: XYZ Pvt Ltd"),
              Text("Address: 123 Business Street"),
              SizedBox(height: 10),
              Text("Employee Name: John Doe"),
              Text("Designation: Software Engineer"),
              Text("Pay Period: $month $year"),
              Text("Worked Days: 26"),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final pdfBytes = await _generatePdf();
                    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download Payslip", style: TextStyle(color: Colors.white)), // White text
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue button
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Payslip", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text("XYZ Pvt Ltd"),
              pw.Text("123 Business Street"),
              pw.SizedBox(height: 15),
              pw.Text("Employee Name: John Doe"),
              pw.Text("Designation: Software Engineer"),
              pw.Text("Pay Period: $month $year"),
              pw.Text("Worked Days: 26"),
              pw.SizedBox(height: 15),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                data: [
                  ["Earnings", "Amount", "Deductions", "Amount"],
                  ["Basic", "12000", "Tax", "1500"],
                  ["Bonus", "2000", "Provident Fund", "800"],
                  ["Total Earnings", "14000", "Total Deductions", "2300"],
                  ["Net Pay", "11700", "", ""],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text("Net Pay: 11700"),
              pw.Text("In Words: Eleven Thousand Seven Hundred"),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Employer Signature: __________"),
                  pw.Text("Employee Signature: __________"),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}

class SalaryHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> salaryHistory = [
    {"Month": "January 2024", "Amount": "\$9500", "Date": "5th Feb 2024"},
    {"Month": "December 2023", "Amount": "\$9700", "Date": "5th Jan 2024"},
    {"Month": "November 2023", "Amount": "\$9300", "Date": "5th Dec 2023"},
    {"Month": "October 2023", "Amount": "\$9200", "Date": "5th Nov 2023"},
    {"Month": "September 2023", "Amount": "\$9100", "Date": "5th Oct 2023"},
    {"Month": "August 2023", "Amount": "\$9000", "Date": "5th Sep 2023"},
    {"Month": "July 2023", "Amount": "\$8900", "Date": "5th Aug 2023"},
    {"Month": "June 2023", "Amount": "\$8800", "Date": "5th July 2023"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salary History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(),
          columnWidths: {0: FractionColumnWidth(0.4), 1: FractionColumnWidth(0.3), 2: FractionColumnWidth(0.3)},
          children: [
            _buildTableRow(["Month", "Amount", "Date"], isHeader: true),
            for (var data in salaryHistory) _buildTableRow([data["Month"]!, data["Amount"]!, data["Date"]!]),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? BoxDecoration(color: Colors.grey[300]) : null,
      children: cells.map((text) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(text, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal))),
        );
      }).toList(),
    );
  }
}
