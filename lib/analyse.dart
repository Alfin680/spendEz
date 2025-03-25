// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart'; // Import this at the top

// List<String> _generateLastFiveMonths() {
//   DateTime now = DateTime.now();
//   List<String> months = [];
//   for (int i = 4; i >= 0; i--) {
//     DateTime month = DateTime(now.year, now.month - i, 1);
//     months.add(
//         DateFormat('MMM').format(month).toUpperCase()); // "JAN", "FEB" etc.
//   }
//   return months;
// }
// class MonthlyExpenseChart extends StatelessWidget {
//   final Map<String, double> monthlyExpenses;

//   MonthlyExpenseChart({required this.monthlyExpenses});

//   @override
//   Widget build(BuildContext context) {
//     List<String> months = monthlyExpenses.keys.toList(); // Get month names
//     List<BarChartGroupData> barGroups = [];

//     for (int i = 0; i < months.length; i++) {
//       barGroups.add(
//         BarChartGroupData(
//           x: i,
//           barRods: [
//             BarChartRodData(
//               toY: monthlyExpenses[months[i]]!,
//               color: Colors.purple,
//               width: 20,
//             ),
//           ],
//         ),
//       );
//     }

//     return monthlyExpenses.isEmpty
//         ? Center(child: Text("No data available"))
//         : BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               maxY: monthlyExpenses.values.reduce((a, b) => a > b ? a : b) + 500,
//               barGroups: barGroups,
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         months[value.toInt()].split('-')[1], // Show only month
//                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }

// class AnalysisPage extends StatefulWidget {
//   final int userId; // Pass the logged-in user's ID

//   AnalysisPage({required this.userId});

//   @override
//   _AnalysisPageState createState() => _AnalysisPageState();
// }

// class _AnalysisPageState extends State<AnalysisPage> {
//   double predictedAmount = 0.0;
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchPredictedAmount();
//     loadExpenseData();
//   }

//   // Fetch predicted amount from Flask API
//   Future<void> fetchPredictedAmount() async {
//     final url =
//         Uri.parse('http://127.0.0.1:5000/predict?user_id=${widget.userId}');
//     print('Fetching data from: $url'); // Debug print
//     try {
//       final response = await http.get(url);
//       print('Response status: ${response.statusCode}'); // Debug print
//       print('Response body: ${response.body}'); // Debug print
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           predictedAmount = data['predicted_next_month_expense'].toDouble();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to fetch predicted amount';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchMonthlyExpenses(int userId,monthlyExpenses) async {
//   final url = Uri.parse('http://127.0.0.1:5000/monthly-expense/$userId');

//   try {
//     final response = await http.get(url);
//     print('Response: ${response.body}'); // Debugging

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         monthlyExpenses = data.map<String, double>((key, value) => MapEntry(key, value.toDouble()));
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     print("Error fetching data: $e");
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text("PREDICTED EXPENSE"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Predicted Amount
//               isLoading
//                   ? CircularProgressIndicator()
//                   : errorMessage.isNotEmpty
//                       ? Text(errorMessage, style: TextStyle(color: Colors.red))
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "₹${predictedAmount.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                   fontSize: 36, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 10),
//                           ],
//                         ),
//               SizedBox(height: 10),
//               Text(
//                 "The predicted amount does not account for unexpected or additional expenses. It may vary based on your spending habits.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey),
//               ),
//               SizedBox(height: 20),

//               // Spending Chart
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Spendings",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       height: 200,
//                       child: expenses.isEmpty
//                           ? Center(child: Text("No data available"))
//                           : BarChart(
//                               BarChartData(
//                                 barGroups: _getBarChartData(),
//                                 borderData: FlBorderData(show: false),
//                                 gridData: FlGridData(show: false),
//                                 titlesData: FlTitlesData(
//                                   leftTitles: AxisTitles(
//                                       sideTitles: SideTitles(showTitles: true)),
//                                   bottomTitles: AxisTitles(
//                                     sideTitles: SideTitles(
//                                       showTitles: true,
//                                       getTitlesWidget:
//                                           (double value, TitleMeta meta) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(top: 8.0),
//                                           child: Text(
//                                             months[value.toInt()],
//                                             style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         );
//                                       },
//                                       reservedSize: 30,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     )
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20),

//               // Expense List
//               _buildExpenseItem(1, "Food", "₹2500", Icons.fastfood),
//               _buildExpenseItem(2, "Shopping", "₹3000", Icons.shopping_bag),
//               _buildExpenseItem(3, "Fun", "₹1000", Icons.celebration),
//               _buildExpenseItem(4, "Travel", "₹1000", Icons.directions_car),
//               _buildExpenseItem(5, "Other", "₹500", Icons.more_horiz),
//               _buildExpenseItem(6, "Bills", "₹500", Icons.receipt),
//             ],
//           ),
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: const Color.fromARGB(255, 127, 7, 255),
//         unselectedItemColor: Colors.white,
//         showUnselectedLabels: true,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.attach_money), label: "Expense"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.bar_chart), label: "Insights"),
//           BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Tips"),
//         ],
//       ),
//     );
//   }

//   // Bar Chart Data
//   List<String> months = [];
//   List<double> expenses = [];

//   void loadExpenseData() async {
//     try {
//       var data = await fetchMonthlyExpenses(widget.userId);

//       setState(() {
//         months = List<String>.from(data['months']
//             .map((m) => DateFormat('MMM').format(DateTime.parse(m))));
//         expenses = List<double>.from(data['expenses']);

//         print("Months: $months"); // Debugging
//         print("Expenses: $expenses"); // Debugging
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }

//   List<BarChartGroupData> _getBarChartData() {
//     if (expenses.isEmpty) return [];

//     return List.generate(expenses.length, (index) {
//       return BarChartGroupData(
//         x: index, // Ensure correct index mapping
//         barRods: [
//           BarChartRodData(
//             toY: expenses[index],
//             color: Colors.purple,
//             width: 20,
//           ),
//         ],
//       );
//     });
//   }

//   // Expense List Item
//   Widget _buildExpenseItem(
//       int number, String category, String amount, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.purple,
//             child:
//                 Text(number.toString(), style: TextStyle(color: Colors.white)),
//           ),
//           SizedBox(width: 10),
//           CircleAvatar(
//             backgroundColor: Colors.purple,
//             child: Icon(icon, color: Colors.white),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[800],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(category,
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                   Text(amount,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
        Uri.parse('http://127.0.0.1:5000/predict?user_id=${widget.userId}');
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
        'http://127.0.0.1:5000/budget-allocation?user_id=${widget.userId}');
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
        title: Text("PREDICTED EXPENSE"),
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
              // Budget Recommendation Heading
              Text(
                "Budget Recommendation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text for visibility
                ),
              ),

              // Expense List
              // _buildExpenseItem(1, "Food", "₹2500", Icons.fastfood),
              // _buildExpenseItem(2, "Shopping", "₹3000", Icons.shopping_bag),
              // _buildExpenseItem(3, "Fun", "₹1000", Icons.celebration),
              // _buildExpenseItem(4, "Travel", "₹1000", Icons.directions_car),
              // _buildExpenseItem(5, "Other", "₹500", Icons.more_horiz),
              // _buildExpenseItem(6, "Bills", "₹500", Icons.receipt),
              // _buildExpenseItem(7, "Rent", "₹8000", Icons.home), // Added Rent
              // _buildExpenseItem(5, "Other", "₹500", Icons.more_horiz),
              // _buildExpenseItem(8,"Savings", "₹2000", Icons.savings), // Added Savings
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

              // Move these inside Column
              SizedBox(height: 20),

              Text(
                "WOW! The recommended budget helps you save ₹${budgetAllocation["Savings"]?.toInt() ?? 0} next month... Let's go!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      const Color.fromARGB(255, 45, 14, 116), // Stylish color
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Caption at the bottom
      // Some space before bottom navigation
    );
  }

  Widget _buildExpenseItem(
      int number, String category, double amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple,
            child:
                Text(number.toString(), style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.purple,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text("₹${amount.toInt()}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
