// import 'package:flutter/material.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/tips.dart';

// class Travel extends StatelessWidget {
//   final int userId;
//   const Travel({required this.userId}); // Accept userId

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Category - Travels',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: TravelScreen(userId: userId), // Pass userId
//     );
//   }
// }

// class TravelScreen extends StatefulWidget {
//   final int userId;
//   const TravelScreen({required this.userId}); // Accept userId

//   @override
//   _TravelScreenState createState() => _TravelScreenState();
// }

// class _TravelScreenState extends State<TravelScreen> {
//   double _budgetAllocation = 1000;
//   double _totalBudget = 1000;
//   double _budgetSpent = 650;
//   double _budgetLeft = 350;

//   String _statusMessage = "Nice!";
//   bool _isBudgetExceeded = false;

//   @override
//   void initState() {
//     super.initState();
//     _updateBudgetStatus();
//   }

//   void _updateBudgetStatus() {
//     setState(() {
//       _budgetLeft = _totalBudget - _budgetSpent;
//       _isBudgetExceeded = _budgetLeft < 0;

//       if (_isBudgetExceeded) {
//         _statusMessage = "Alert! You're over budget!";
//       } else {
//         _statusMessage = "Nice! Great job! You're staying within your budget";
//       }
//     });
//   }

//   void _onBudgetAllocationChanged(double value) {
//     setState(() {
//       _budgetAllocation = value;
//       _totalBudget = value;
//       _updateBudgetStatus();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     CategoryExpenseScreen(userId: widget.userId),
//               ),
//             );
//           },
//         ),
//         title: Text(
//           "Category - Travels",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildBudgetInsights(),
//             _buildBudgetStatus(),
//             _buildFinanceTipsButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBudgetInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Budget Insights",
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildBudgetCircle("₹ ${_totalBudget.round()}", "Total Budget"),
//             _buildBudgetCircle("₹ ${_budgetSpent.round()}", "Budget Spent"),
//             _buildBudgetCircle("₹ ${_budgetLeft.round()}", "Budget Left"),
//           ],
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget _buildBudgetStatus() {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: _isBudgetExceeded
//             ? Colors.redAccent.withOpacity(0.2)
//             : Colors.limeAccent.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             _isBudgetExceeded ? Icons.warning : Icons.check_circle,
//             color: _isBudgetExceeded ? Colors.red : Colors.green,
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               _statusMessage,
//               style: TextStyle(
//                 color: _isBudgetExceeded ? Colors.red : Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFinanceTipsButton() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => TipsScreen(userId: widget.userId)),
//           );
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Text(
//             "Get Finance Tips",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBudgetCircle(String value, String label) {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
//             ),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(fontSize: 12, color: Colors.black54),
//         ),
//       ],
//     );
//   }
// }
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendez_main/tips.dart';



class Travel extends StatelessWidget {
  final int userId;
  const Travel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Travel',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TravelScreen(userId: userId),
    );
  }
}

class TravelScreen extends StatefulWidget {
  final int userId;
  const TravelScreen({required this.userId});

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  double _totalBudget = 0;
  double _budgetSpent = 0;
  double _budgetLeft = 0;
  String _statusMessage = "Nice!";
  bool _isBudgetExceeded = false;
  TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBudgetDetails();
  }

  void _fetchBudgetDetails() async {
    final String apiUrl =
        "http://your-api-url/budget-insights?user_id=${widget.userId}&category=Travel";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _totalBudget = data["total_budget"].toDouble();
          _budgetSpent = data["total_spent"].toDouble();
          _budgetLeft = _totalBudget - _budgetSpent;
          _isBudgetExceeded = _budgetLeft < 0;
          _budgetController.text = _totalBudget.toString();

          _statusMessage = _isBudgetExceeded
              ? "Alert! You're over budget!"
              : "Nice! Great job! You're staying within your budget";
        });
      } else {
        throw Exception("Failed to load travel budget details");
      }
    } catch (error) {
      print("Error fetching travel budget details: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Category - Travel",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetAllocation(),
            SizedBox(height: 20),
            _buildBudgetInsights(),
            SizedBox(height: 16),
            _buildBudgetStatus(),
            SizedBox(height: 16),
            _buildFinanceTipsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetAllocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Budget Allocation",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          onSubmitted: (value) {
            setState(() {
              _totalBudget = double.tryParse(value) ?? _totalBudget;
              _budgetLeft = _totalBudget - _budgetSpent;
              _isBudgetExceeded = _budgetLeft < 0;
            });
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8)),
        ),
      ],
    );
  }

  Widget _buildBudgetInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Budget Insights",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBudgetCircle("₹ ${_totalBudget.round()}", "Total Budget"),
            _buildBudgetCircle("₹ ${_budgetSpent.round()}", "Budget Spent"),
            _buildBudgetCircle("₹ ${_budgetLeft.round()}", "Budget Left"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBudgetStatus() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isBudgetExceeded
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.limeAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _isBudgetExceeded ? Icons.warning : Icons.check_circle,
            color: _isBudgetExceeded ? Colors.red : Colors.green,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _isBudgetExceeded ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTipsButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TipsScreen(userId: widget.userId)),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Get Finance Tips",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}    

import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';
import 'package:fl_chart/fl_chart.dart'; // For Chart

class Travel extends StatelessWidget {
  final int userId;
  const Travel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Travel',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: TravelScreen(userId: userId),
    );
  }
}

class TravelScreen extends StatefulWidget {
  final int userId;
  const TravelScreen({required this.userId});

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  double _budgetAllocation = 0;
  double _totalBudget = 0;
  double _budgetSpent = 0;
  double _budgetLeft = 0;
  bool _isBudgetExceeded = false;
  String _statusMessage = "Nice!";

  @override
  void initState() {
    super.initState();
    _updateBudgetStatus();
  }

  void _updateBudgetStatus() {
    setState(() {
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
      _statusMessage = _isBudgetExceeded
          ? "Alert! You're over budget!"
          : "Nice! You're staying within budget!";
    });
  }

  void _onBudgetChanged(String value) {
    setState(() {
      _budgetAllocation = double.tryParse(value) ?? 0;
      _totalBudget = _budgetAllocation;
      _updateBudgetStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryExpenseScreen(userId: widget.userId),
              ),
            );
          },
        ),
        title: Text(
          "Category - Travel",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpendingBox(),
            _buildBudgetInput(),
            _buildBudgetInsights(),
            _buildBudgetChart(),
            _buildBudgetStatus(),
            _buildFinanceTipsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingBox() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spendings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("₹ $_budgetSpent",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text("Budget Allocation", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: _onBudgetChanged,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBudgetInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Budget Insights", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBudgetCircle("₹ ${_totalBudget.round()}", "Total Budget"),
            _buildBudgetCircle("₹ ${_budgetSpent.round()}", "Budget Spent"),
            _buildBudgetCircle("₹ ${_budgetLeft.round()}", "Budget Left"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBudgetChart() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: _totalBudget, color: Colors.blue)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: _budgetSpent, color: Colors.red)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: _budgetLeft, color: Colors.green)]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text("Total");
                    case 2:
                      return Text("Spent");
                    case 3:
                      return Text("Left");
                    default:
                      return Text("");
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetStatus() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isBudgetExceeded ? Colors.redAccent.withOpacity(0.2) : Colors.limeAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_isBudgetExceeded ? Icons.warning : Icons.check_circle,
              color: _isBudgetExceeded ? Colors.red : Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _isBudgetExceeded ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTipsButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TipsScreen(userId: widget.userId)),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text("Get Finance Tips", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildBudgetCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple])),
          child: Center(child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';
import 'package:fl_chart/fl_chart.dart'; // For Line Chart

class Travel extends StatelessWidget {
  final int userId;
  const Travel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Travel',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: TravelScreen(userId: userId),
    );
  }
}

class TravelScreen extends StatefulWidget {
  final int userId;
  const TravelScreen({required this.userId});

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  double _budgetAllocation = 0;
  double _totalBudget = 0;
  double _budgetSpent = 0;
  double _budgetLeft = 0;
  bool _isBudgetExceeded = false;
  String _statusMessage = "Nice!";

  List<FlSpot> _spendingData = [FlSpot(0, 0)];

  @override
  void initState() {
    super.initState();
    _updateBudgetStatus();
    _generateFakeData(); // Mock data for chart
  }

  void _updateBudgetStatus() {
    setState(() {
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
      _statusMessage = _isBudgetExceeded
          ? "Alert! You're over budget!"
          : "Nice! You're staying within budget!";
    });
  }

  void _onBudgetChanged(String value) {
    setState(() {
      _budgetAllocation = double.tryParse(value) ?? 0;
      _totalBudget = _budgetAllocation;
      _updateBudgetStatus();
    });
  }

  void _generateFakeData() {
    // Mock spending trend data over time (e.g., days or weeks)
    _spendingData = [
      FlSpot(1, 10),
      FlSpot(2, 20),
      FlSpot(3, 15),
      FlSpot(4, 30),
      FlSpot(5, 40),
      FlSpot(6, 25),
      FlSpot(7, 35),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryExpenseScreen(userId: widget.userId),
              ),
            );
          },
        ),
        title: Text(
          "Category - Travel",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLineChart(),
            SizedBox(height: 16),
            _buildSpendingBox(),
            _buildBudgetInput(),
            _buildBudgetInsights(),
            _buildBudgetStatus(),
            _buildFinanceTipsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.white,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}"); // X-axis labels (days)
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _spendingData,
              isCurved: true,
              color: Colors.deepPurple,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 119, 13, 189).withOpacity(0.4),
                    Colors.deepPurple.withOpacity(0.1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingBox() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spendings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("₹ $_budgetSpent",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text("Budget Allocation",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: _onBudgetChanged,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBudgetInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Budget Insights",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBudgetCircle("₹ ${_totalBudget.round()}", "Total Budget"),
            _buildBudgetCircle("₹ ${_budgetSpent.round()}", "Budget Spent"),
            _buildBudgetCircle("₹ ${_budgetLeft.round()}", "Budget Left"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBudgetStatus() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isBudgetExceeded
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.limeAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_isBudgetExceeded ? Icons.warning : Icons.check_circle,
              color: _isBudgetExceeded ? Colors.red : Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _isBudgetExceeded ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTipsButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 67, 15, 158),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TipsScreen(userId: widget.userId)));
        },
        child: Text("Get Finance Tips",
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildBudgetCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
          child: Center(
              child: Text(value,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';
import 'package:fl_chart/fl_chart.dart'; // For Line Chart

class Travel extends StatelessWidget {
  final int userId;
  const Travel({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Travel',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: TravelScreen(userId: userId),
    );
  }
}

class TravelScreen extends StatefulWidget {
  final int userId;
  const TravelScreen({required this.userId});

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  double _budgetAllocation = 0;
  double _totalBudget = 0;
  double _budgetSpent = 0;
  double _budgetLeft = 0;
  bool _isBudgetExceeded = false;
  String _statusMessage = "Nice!";

  List<FlSpot> _spendingData = [FlSpot(0, 0)];

  @override
  void initState() {
    super.initState();
    _updateBudgetStatus();
    _generateFakeData(); // Mock data for chart
  }

  void _updateBudgetStatus() {
    setState(() {
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
      _statusMessage = _isBudgetExceeded
          ? "Alert! You're over budget!"
          : "Nice! You're staying within budget!";
    });
  }

  void _onBudgetChanged(String value) {
    setState(() {
      _budgetAllocation = double.tryParse(value) ?? 0;
      _totalBudget = _budgetAllocation;
      _updateBudgetStatus();
    });
  }

  void _generateFakeData() {
    _spendingData = [
      FlSpot(1, 10),
      FlSpot(2, 20),
      FlSpot(3, 15),
      FlSpot(4, 30),
      FlSpot(5, 40),
      FlSpot(6, 25),
      FlSpot(7, 35),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryExpenseScreen(userId: widget.userId),
              ),
            );
          },
        ),
        title: Text(
          "Category - Travel",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBarChart(),
            SizedBox(height: 16),
            _buildBudgetInput(),
            SizedBox(height: 20),
            _buildBudgetInsights(),
            SizedBox(height: 16),
            _buildBudgetStatus(),
            SizedBox(height: 16),
            _buildFinanceTipsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  List<String> labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(labels[value.toInt()],
                        style: TextStyle(fontSize: 12)),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 200, color: Color(0xFF7F07FF), width: 16)
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 300, color: Color(0xFF7F07FF), width: 16)
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 150, color: Color(0xFF7F07FF), width: 16)
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: 280, color: Color(0xFF7F07FF), width: 16)
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(toY: 180, color: Color(0xFF7F07FF), width: 16)
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text("Budget Allocation",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: _onBudgetChanged,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBudgetStatus() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isBudgetExceeded
            ? Colors.redAccent.withOpacity(0.2)
            : Colors.limeAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_isBudgetExceeded ? Icons.warning : Icons.check_circle,
              color: _isBudgetExceeded ? Colors.red : Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _isBudgetExceeded ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Budget Insights",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBudgetCircle("₹ ${_totalBudget.round()}", "Total Budget"),
            _buildBudgetCircle("₹ ${_budgetSpent.round()}", "Budget Spent"),
            _buildBudgetCircle("₹ ${_budgetLeft.round()}", "Budget Left"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFinanceTipsButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 67, 15, 158),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TipsScreen(userId: widget.userId)));
        },
        child: Text("Get Finance Tips",
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildBudgetCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
          child: Center(
              child: Text(value,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
