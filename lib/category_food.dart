import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';

class Food extends StatelessWidget {
  final int userId;
  const Food({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Food',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FoodScreen(userId: userId),
    );
  }
}

class FoodScreen extends StatefulWidget {
  final int userId;
  const FoodScreen({required this.userId});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  double _totalBudget = 5000;
  double _budgetSpent = 0; // Will be fetched from the backend
  double _budgetLeft = 0;
  String _statusMessage = "Nice!";
  bool _isBudgetExceeded = false;
  List<double> _spendings = []; // Will be fetched from the backend
  List<String> _labels = []; // Will be fetched from the backend
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSpendingData();
    _fetchBudgetSpent();
  }

  Future<void> _fetchSpendingData() async {
    final url = Uri.parse(
        "http://127.0.0.1:5000/category-spending-week?user_id=${widget.userId}&category=Food"); // Replace "Food" with the desired category
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched spending data: $data"); // Debugging
        setState(() {
          _spendings = List<double>.from(data['spendings'].map((value) =>
              double.tryParse(value.toString()) ??
              0.0)); // Parse strings to doubles
          _labels = List<String>.from(data['labels']);
        });
      } else {
        throw Exception("Failed to load spending data");
      }
    } catch (e) {
      print("Error fetching spending data: $e"); // Debugging
    }
  }

  Future<void> _fetchBudgetSpent() async {
    final url = Uri.parse(
        "http://127.0.0.1:5000/category-budget-spent?user_id=${widget.userId}&category=Food"); // Replace "Food" with the desired category
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched budget spent data: $data"); // Debugging
        setState(() {
          _budgetSpent = double.tryParse(data['budget_spent'].toString()) ??
              0.0; // Parse as double
          _budgetLeft = _totalBudget - _budgetSpent;
          _isBudgetExceeded = _budgetLeft < 0;
          _statusMessage = _isBudgetExceeded
              ? "Alert! You're over budget!"
              : "Nice! Great job! You're staying within your budget";
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load budget spent data");
      }
    } catch (e) {
      print("Error fetching budget spent data: $e"); // Debugging
      setState(() {
        _isLoading = false;
      });
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryExpenseScreen(userId: widget.userId)),
            );
          },
        ),
        title: Text(
          "Category - Food",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBarChart(),
                  SizedBox(height: 30),
                  _buildBudgetAllocation(),
                  SizedBox(height: 30),
                  _buildBudgetInsights(),
                  SizedBox(height: 30),
                  _buildBudgetStatus(),
                  SizedBox(height: 30),
                  _buildFinanceTipsButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildBarChart() {
    print("Spendings: $_spendings"); // Debugging
    print("Labels: $_labels"); // Debugging

    // Check if all spendings are zero
    bool allZeros = _spendings.every((value) => value == 0);

    return Container(
      height: 300, // Increased height of the container
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
      child: allZeros
          ? Center(
              child: Text(
                "No spending data available for this week.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            )
          : BarChart(
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
                        // Split the label into date and month
                        final parts = _labels[value.toInt()].split(' ');
                        final date = parts[0]; // Date (e.g., "15")
                        final month = parts[1]; // Month (e.g., "Mar")

                        return SideTitleWidget(
                          space: 4,
                          angle: 0,
                          meta: meta,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                date, // Display the date
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                month, // Display the month below the date
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                      reservedSize:
                          40, // Increased reserved size for the labels
                    ),
                  ),
                ),
                barGroups: _spendings.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                          toY: entry.value, color: Color(0xFF7F07FF), width: 16)
                    ],
                  );
                }).toList(),
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
        Slider(
          value: _totalBudget,
          min: 100,
          max: 10000,
          divisions: 100,
          label: _totalBudget.round().toString(),
          onChanged: (value) {
            setState(() {
              _totalBudget = value;
              _budgetLeft = _totalBudget - _budgetSpent;
              _isBudgetExceeded = _budgetLeft < 0;
            });
          },
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
}