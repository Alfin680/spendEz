import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';

class Fun extends StatelessWidget {
  final int userId;
  const Fun({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Fun',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FunScreen(userId: userId),
    );
  }
}

class FunScreen extends StatefulWidget {
  final int userId;
  const FunScreen({required this.userId});

  @override
  _FunScreenState createState() => _FunScreenState();
}

class _FunScreenState extends State<FunScreen> {
  double _budgetAllocation = 1000;
  double _totalBudget = 1000;
  double _budgetSpent = 650;
  double _budgetLeft = 350;

  String _statusMessage = "Nice!";
  bool _isBudgetExceeded = false;

  @override
  void initState() {
    super.initState();
    _updateBudgetStatus();
  }

  void _updateBudgetStatus() {
    setState(() {
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;

      if (_isBudgetExceeded) {
        _statusMessage = "Alert! You're over budget!";
      } else {
        _statusMessage = "Nice! Great job! You're staying within your budget";
      }
    });
  }

  void _onBudgetAllocationChanged(double value) {
    setState(() {
      _budgetAllocation = value;
      _totalBudget = value;
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
                      CategoryExpenseScreen(userId: widget.userId)),
            );
          },
        ),
        title: Text(
          "Category - Fun",
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
            //_buildBudgetAllocation(),
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
                    space: 4, // Adjust space between title and axis
                    angle: 0, // Set rotation if needed
                    meta: meta,
                    child: Text(
                      labels[value.toInt()],
                      style: TextStyle(fontSize: 12),
                    ),
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
            MaterialPageRoute(
                builder: (context) => TipsScreen(userId: widget.userId)),
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
