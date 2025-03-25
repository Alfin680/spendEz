// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/tips.dart';

// class Shopping extends StatelessWidget {
//   final int userId;
//   const Shopping({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Category - Shopping',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: ShoppingScreen(userId: userId),
//     );
//   }
// }

// class ShoppingScreen extends StatefulWidget {
//   final int userId;
//   const ShoppingScreen({required this.userId});

//   @override
//   _ShoppingScreenState createState() => _ShoppingScreenState();
// }

// class _ShoppingScreenState extends State<ShoppingScreen> {
//   double _totalBudget = 5000;
//   double _budgetSpent = 0; // Will be fetched from the backend
//   double _budgetLeft = 0;
//   String _statusMessage = "Nice!";
//   bool _isBudgetExceeded = false;
//   List<double> _spendings = []; // Will be fetched from the backend
//   List<String> _labels = []; // Will be fetched from the backend
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSpendingData();
//     _fetchBudgetSpent();
//   }

//   Future<void> _fetchSpendingData() async {
//     final url = Uri.parse(
//         "http://127.0.0.1:5000/category-spending-week?user_id=${widget.userId}&category=Shopping"); // Replace "Shopping" with the desired category
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("Fetched spending data: $data"); // Debugging
//         setState(() {
//           _spendings = List<double>.from(data['spendings'].map((value) =>
//               double.tryParse(value.toString()) ??
//               0.0)); // Parse strings to doubles
//           _labels = List<String>.from(data['labels']);
//         });
//       } else {
//         throw Exception("Failed to load spending data");
//       }
//     } catch (e) {
//       print("Error fetching spending data: $e"); // Debugging
//     }
//   }

//   Future<void> _fetchBudgetSpent() async {
//     final url = Uri.parse(
//         "http://127.0.0.1:5000/category-budget-spent?user_id=${widget.userId}&category=Shopping"); // Replace "Shopping" with the desired category
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("Fetched budget spent data: $data"); // Debugging
//         setState(() {
//           _budgetSpent = double.tryParse(data['budget_spent'].toString()) ??
//               0.0; // Parse as double
//           _budgetLeft = _totalBudget - _budgetSpent;
//           _isBudgetExceeded = _budgetLeft < 0;
//           _statusMessage = _isBudgetExceeded
//               ? "Alert! You're over budget!"
//               : "Nice! Great job! You're staying within your budget";
//           _isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load budget spent data");
//       }
//     } catch (e) {
//       print("Error fetching budget spent data: $e"); // Debugging
//       setState(() {
//         _isLoading = false;
//       });
//     }
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
//                   builder: (context) =>
//                       CategoryExpenseScreen(userId: widget.userId)),
//             );
//           },
//         ),
//         title: Text(
//           "Category - Shopping",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildBarChart(),
//                   SizedBox(height: 30),
//                   _buildBudgetAllocation(),
//                   SizedBox(height: 30),
//                   _buildBudgetInsights(),
//                   SizedBox(height: 30),
//                   _buildBudgetStatus(),
//                   SizedBox(height: 30),
//                   _buildFinanceTipsButton(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildBarChart() {
//     print("Spendings: $_spendings"); // Debugging
//     print("Labels: $_labels"); // Debugging

//     // Check if all spendings are zero
//     bool allZeros = _spendings.every((value) => value == 0);

//     return Container(
//       height: 300, // Increased height of the container
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: allZeros
//           ? Center(
//               child: Text(
//                 "No spending data available for this week.",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 16,
//                 ),
//               ),
//             )
//           : BarChart(
//               BarChartData(
//                 borderData: FlBorderData(show: false),
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         // Split the label into date and month
//                         final parts = _labels[value.toInt()].split(' ');
//                         final date = parts[0]; // Date (e.g., "15")
//                         final month = parts[1]; // Month (e.g., "Mar")

//                         return SideTitleWidget(
//                           space: 4,
//                           angle: 0,
//                           meta: meta,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 date, // Display the date
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                               Text(
//                                 month, // Display the month below the date
//                                 style: TextStyle(fontSize: 10),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       reservedSize:
//                           40, // Increased reserved size for the labels
//                     ),
//                   ),
//                 ),
//                 barGroups: _spendings.asMap().entries.map((entry) {
//                   return BarChartGroupData(
//                     x: entry.key,
//                     barRods: [
//                       BarChartRodData(
//                           toY: entry.value, color: Color(0xFF7F07FF), width: 16)
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//     );
//   }

//   Widget _buildBudgetAllocation() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Budget Allocation",
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black)),
//         Slider(
//           value: _totalBudget,
//           min: 100,
//           max: 10000,
//           divisions: 100,
//           label: _totalBudget.round().toString(),
//           onChanged: (value) {
//             setState(() {
//               _totalBudget = value;
//               _budgetLeft = _totalBudget - _budgetSpent;
//               _isBudgetExceeded = _budgetLeft < 0;
//             });
//           },
//         ),
//       ],
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
// }
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/tips.dart';

// Widget _buildBudgetCircle(String value, String label) {
//   return Column(
//     children: [
//       Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//             colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
//           ),
//         ),
//         child: Center(
//           child: Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//       SizedBox(height: 8),
//       Text(
//         label,
//         style: TextStyle(fontSize: 12, color: Colors.black54),
//       ),
//     ],
//   );
// }

// class Shopping extends StatelessWidget {
//   final int userId;
//   const Shopping({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Category - Shopping',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: ShoppingScreen(userId: userId),
//     );
//   }
// }

// class ShoppingScreen extends StatefulWidget {
//   final int userId;
//   const ShoppingScreen({required this.userId});

//   @override
//   _ShoppingScreenState createState() => _ShoppingScreenState();
// }

// class _ShoppingScreenState extends State<ShoppingScreen> {
//   double _budgetAllocation = 1000;
//   double _totalBudget = 1000;
//   double _budgetSpent = 650;
//   double _budgetLeft = 350;
//   TextEditingController _budgetController = TextEditingController();

//   String _statusMessage = "Nice!";
//   bool _isBudgetExceeded = false;

//   @override
//   void initState() {
//     super.initState();
//     _updateBudgetStatus();
//     _budgetController.text = _totalBudget.toString();
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

//   void _onBudgetChanged(String value) {
//     setState(() {
//       double? newBudget = double.tryParse(value);
//       if (newBudget != null) {
//         _totalBudget = newBudget;
//         _updateBudgetStatus();
//       }
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
//                   builder: (context) =>
//                       CategoryExpenseScreen(userId: widget.userId)),
//             );
//           },
//         ),
//         title: Text(
//           "Category - Shopping",
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
//             _buildBarChart(),
//             SizedBox(height: 16),
//             _buildBudgetInput(),
//             SizedBox(height: 20),
//             _buildBudgetInsights(),
//             SizedBox(height: 16),
//             _buildBudgetStatus(),
//             SizedBox(height: 16),
//             _buildFinanceTipsButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBarChart() {
//     return Container(
//       height: 200,
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: BarChart(
//         BarChartData(
//           borderData: FlBorderData(show: false),
//           gridData: FlGridData(show: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   List<String> labels = ["Mon", "Tue", "Wed", "Thu", "Fri"];
//                   return SideTitleWidget(
//                     space: 4, // Adjust space between title and axis
//                     angle: 0, // Set rotation if needed
//                     meta: meta,
//                     child: Text(
//                       labels[value.toInt()],
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   );
//                 },
//                 reservedSize: 32,
//               ),
//             ),
//           ),
//           barGroups: [
//             BarChartGroupData(x: 0, barRods: [
//               BarChartRodData(toY: 200, color: Color(0xFF7F07FF), width: 16)
//             ]),
//             BarChartGroupData(x: 1, barRods: [
//               BarChartRodData(toY: 300, color: Color(0xFF7F07FF), width: 16)
//             ]),
//             BarChartGroupData(x: 2, barRods: [
//               BarChartRodData(toY: 150, color: Color(0xFF7F07FF), width: 16)
//             ]),
//             BarChartGroupData(x: 3, barRods: [
//               BarChartRodData(toY: 280, color: Color(0xFF7F07FF), width: 16)
//             ]),
//             BarChartGroupData(x: 4, barRods: [
//               BarChartRodData(toY: 180, color: Color(0xFF7F07FF), width: 16)
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBudgetInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Set Budget",
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: _budgetController,
//           keyboardType: TextInputType.number,
//           onChanged: _onBudgetChanged,
//           decoration: InputDecoration(
//             hintText: "Enter your budget",
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             prefixIcon: Icon(Icons.attach_money, color: Color(0xFF7F07FF)),
//           ),
//         ),
//         SizedBox(height: 16),
//       ],
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
//           child: Text("Get Finance Tips",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
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
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/tips.dart';

class Shopping extends StatelessWidget {
  final int userId;
  const Shopping({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category - Shopping',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ShoppingScreen(userId: userId),
    );
  }
}

class ShoppingScreen extends StatefulWidget {
  final int userId;
  const ShoppingScreen({required this.userId});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final String _category = "Shopping";
  double _totalBudget = 30000;
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
    _loadBudget();
    _fetchSpendingData();
    _fetchBudgetSpent();
  }

  Future<void> _loadBudget() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedBudget = prefs.getDouble('budget_$_category');
    
    setState(() {
      _totalBudget = savedBudget ?? 30000; // Use your default value
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
    });
  } catch (e) {
    print('Error loading budget: $e');
    setState(() {
      _totalBudget = 30000; // Fallback value
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
    });
  }
}

  Future<void> _saveBudget(double newBudget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget_$_category', newBudget);
  }

  Future<void> _fetchSpendingData() async {
    final url = Uri.parse(
        "http://10.0.2.2:5000/category-spending-week?user_id=${widget.userId}&category=Shopping"); // Replace "Shopping" with the desired category
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
        "http://10.0.2.2:5000/category-budget-spent?user_id=${widget.userId}&category=Shopping"); // Replace "Shopping" with the desired category
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
          "Category - Shopping",
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
            _saveBudget(value);
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
