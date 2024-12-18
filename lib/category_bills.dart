import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';

class Bill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Bills',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BillScreen(),
    );
  }
}

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
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
              MaterialPageRoute(builder: (context) => CategoryExpenseApp()),
            );
          },
        ),
        title: Text(
          "Category - Bills",
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
            // Spendings Chart
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Spendings Overview",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: _getBarChartData(),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text("Mon");
                                  case 1:
                                    return Text("Tue");
                                  case 2:
                                    return Text("Wed");
                                  case 3:
                                    return Text("Thu");
                                  case 4:
                                    return Text("Fri");
                                  case 5:
                                    return Text("Sat");
                                  case 6:
                                    return Text("Sun");
                                  default:
                                    return Text("");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Budget Allocation Slider
            Text(
              "Budget Allocation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Slider(
              value: _budgetAllocation,
              min: 100,
              max: 1000,
              divisions: 18,
              label: _budgetAllocation.round().toString(),
              activeColor: Colors.purple,
              inactiveColor: Colors.grey[300],
              onChanged: (value) {
                _onBudgetAllocationChanged(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("100"),
                Text("1000"),
              ],
            ),
            SizedBox(height: 16),

            // Budget Insights
            Text(
              "Budget Insights",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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

            // Status Message
            Container(
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
            ),
            SizedBox(height: 24),

            // Get Finance Tips Button
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tips()),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
            ),
          ],
        ),
      ),
    );
  }

  // Bar chart data
  List<BarChartGroupData> _getBarChartData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 100 % 500, // Example dynamic data
            color: Colors.purpleAccent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
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
