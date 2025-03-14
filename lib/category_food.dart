// import 'package:flutter/material.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/tips.dart';

// class Food extends StatelessWidget {
//   final int userId;
//   const Food({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Category - Food',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: FoodScreen(userId: userId),
//     );
//   }
// }

// class FoodScreen extends StatefulWidget {
//   final int userId;
//   const FoodScreen({required this.userId});

//   @override
//   _FoodScreenState createState() => _FoodScreenState();
// }

// class _FoodScreenState extends State<FoodScreen> {
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
//               MaterialPageRoute(builder: (context) => CategoryExpenseScreen(userId: widget.userId)),
//             );
//           },
//         ),
//         title: Text(
//           "Category - Food",
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
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
//         color: _isBudgetExceeded ? Colors.redAccent.withOpacity(0.2) : Colors.limeAccent.withOpacity(0.5),
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
//             MaterialPageRoute(builder: (context) => TipsScreen(userId: widget.userId)),
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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  double _budgetAllocation = 0;
  double _totalBudget = 0;
  double _budgetSpent = 0;
  double _budgetLeft = 0;
  String _statusMessage = "Nice!";
  bool _isBudgetExceeded = false;
  TextEditingController _budgetController = TextEditingController();
  List<double> _spendings = [];
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _fetchBudgetDetails();
    _fetchFoodCategorySpendings();
  }

  void _fetchBudgetDetails() async {
  final String apiUrl =
      "http://your-api-url/budget-details?user_id=${widget.userId}";

  final String foodExpenseApiUrl =
      "http://your-api-url/food-expense-sum?user_id=${widget.userId}";

  try {
    // Fetching total budget
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double totalBudget = data["total_budget"].toDouble();
      
      setState(() {
        _totalBudget = totalBudget;
        _budgetController.text = _totalBudget.toString();
      });
    } else {
      throw Exception("Failed to load budget details");
    }

    // Fetching total spent on food for the last month
    final foodResponse = await http.get(Uri.parse(foodExpenseApiUrl));

    if (foodResponse.statusCode == 200) {
      final foodData = jsonDecode(foodResponse.body);

      double spent = foodData["total_spent"].toDouble();

      setState(() {
        _budgetSpent = spent; // ✅ Update Budget Spent Circle
        _budgetLeft = _totalBudget - _budgetSpent; // ✅ Update Budget Left Circle
        _isBudgetExceeded = _budgetLeft < 0;

        _statusMessage = _isBudgetExceeded
            ? "Alert! You're over budget!"
            : "Nice! Great job! You're staying within your budget";
      });
    } else {
      throw Exception("Failed to load food category expenses");
    }
  } catch (error) {
    print("Error fetching budget details: $error");
  }
}


  void _fetchFoodCategorySpendings() async {
    final String apiUrl =
        "http://your-api-url/food-expense-history?user_id=${widget.userId}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<double> fetchedValues = List<double>.from(data["expenses"]);
        List<String> fetchedLabels = List<String>.from(data["dates"]);

        setState(() {
          _spendings = fetchedValues;
          _labels = fetchedLabels;
        });
      } else {
        throw Exception("Failed to load food category spendings");
      }
    } catch (error) {
      print("Error fetching food category spendings: $error");
    }
  }

  void _onBudgetEntered(String value) {
    double? enteredBudget = double.tryParse(value);
    if (enteredBudget != null) {
      setState(() {
        _totalBudget = enteredBudget;
        _updateBudgetStatus();
      });
    }
  }

  // void _updateBudgetStatus() {
  //   setState(() {
  //     _budgetLeft = _totalBudget - _budgetSpent;
  //     _isBudgetExceeded = _budgetLeft < 0;
  //   });
  // }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpendingsChart(),
            SizedBox(height: 20),
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

  Widget _buildSpendingsChart() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 228, 229),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spendings",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(
                    _spendings.length,
                    (index) => BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                            toY: _spendings[index],
                            color: Color(0xFF7F07FF),
                            width: 14,
                            borderRadius: BorderRadius.circular(6),
                          )
                        ])),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(_labels[value.toInt()],
                            style: TextStyle(fontSize: 10));
                      },
                      reservedSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
          onSubmitted: _onBudgetEntered,
          decoration: InputDecoration(
              border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8)),
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

