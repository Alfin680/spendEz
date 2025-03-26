import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisPage extends StatefulWidget {
  final int userId;

  AnalysisPage({required this.userId});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  double predictedAmount = 0.0;
  Map<String, double> budgetAllocation = {};

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPredictedAmount();
    fetchBudgetAllocation();
  }

  Future<void> fetchPredictedAmount() async {
    final url =
        Uri.parse('http://10.0.2.2:5000/predict?user_id=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          predictedAmount = data['predicted_next_month_expense'].toDouble();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch predicted amount';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchBudgetAllocation() async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/budget-allocation?user_id=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          predictedAmount = data['predicted_amount'].toDouble();
          budgetAllocation = Map<String, double>.from(data['budget_allocation']
              .map((key, value) => MapEntry(key, value.toDouble())));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch budget allocation';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Predicted Expense",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgressIndicator()
                  : errorMessage.isNotEmpty
                      ? Text(errorMessage, style: TextStyle(color: Colors.red))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹${predictedAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
              SizedBox(height: 10),
              Text(
                "The predicted amount does not account for unexpected or additional expenses. It may vary based on your spending habits.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                "Budget Recommendation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              _buildExpenseItem(
                  1, "Food", budgetAllocation["Food"] ?? 0.0, Icons.fastfood),
              _buildExpenseItem(2, "Shopping",
                  budgetAllocation["Shopping"] ?? 0.0, Icons.shopping_bag),
              _buildExpenseItem(
                  3, "Fun", budgetAllocation["Fun"] ?? 0.0, Icons.celebration),
              _buildExpenseItem(4, "Travel", budgetAllocation["Travel"] ?? 0,
                  Icons.directions_car),
              _buildExpenseItem(5, "Other", budgetAllocation["Other"] ?? 0.0,
                  Icons.more_horiz),
              _buildExpenseItem(
                  6, "Bills", budgetAllocation["Bills"] ?? 0.0, Icons.receipt),
              _buildExpenseItem(
                  7, "Rent", budgetAllocation["Rent"] ?? 0.0, Icons.home),
              _buildExpenseItem(8, "REMAINING",
                  budgetAllocation["Savings"] ?? 0.0, Icons.savings),

              SizedBox(height: 20),

              Text(
                "WOW! The recommended budget helps you save ₹${budgetAllocation["Savings"]?.toInt() ?? 0} next month... Let's go!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      const Color.fromARGB(255, 99, 50, 213), // Stylish color
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseItem(
      int number, String category, double amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16, // Reduced size
                backgroundColor: const Color.fromARGB(255, 99, 50, 213),
                child: Text(
                  number.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16, // Reduced size
                backgroundColor: const Color.fromARGB(255, 99, 50, 213),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        "₹${amount.toInt()}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
