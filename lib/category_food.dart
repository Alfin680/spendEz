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
  double _budgetAllocation = 1000;
  double _totalBudget = 1000;
  double _budgetSpent = 650;
  double _budgetLeft = 350;
  bool _isBudgetExceeded = false;
  TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _budgetController.text = _totalBudget.toString();
    _updateBudgetStatus();
    _fetchFoodCategorySpendings();
  }

  void _fetchFoodCategorySpendings() async {
    // Simulate fetching food-related spendings from backend
    List<double> fetchedValues = [
      400,
      300,
      250,
      350,
      500,
      450,
      300,
      200
    ]; // Replace with API call
    setState(() {
      _budgetSpent = fetchedValues.reduce((a, b) => a + b) /
          fetchedValues.length; // Example: average spent
      _updateBudgetStatus();
    });
  }

  void _updateBudgetStatus() {
    setState(() {
      _budgetLeft = _totalBudget - _budgetSpent;
      _isBudgetExceeded = _budgetLeft < 0;
    });
  }

  void _onBudgetAllocationChanged(double value) {
    setState(() {
      _budgetAllocation = value;
      _totalBudget = value;
      _budgetController.text = value.toString();
      _updateBudgetStatus();
    });
  }

  void _onBudgetEntered(String value) {
    double? enteredBudget = double.tryParse(value);
    if (enteredBudget != null) {
      setState(() {
        _totalBudget = enteredBudget;
        _budgetAllocation = enteredBudget;
        _updateBudgetStatus();
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Spendings",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                barGroups: _getBarGroups(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> labels = [
                          "AUG 12",
                          "AUG 13",
                          "AUG 14",
                          "AUG 15",
                          "AUG 16",
                          "AUG 17",
                          "AUG 18",
                          "AUG 19"
                        ];
                        return Text(labels[value.toInt()],
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

  List<BarChartGroupData> _getBarGroups() {
    List<double> values = [
      400,
      300,
      250,
      350,
      500,
      450,
      300,
      200
    ]; // Food category data
    return List.generate(
      values.length,
      (index) => BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: values[index],
            color: Colors.purple,
            width: 14,
            borderRadius: BorderRadius.circular(6)),
      ]),
    );
  }

  Widget _buildBudgetAllocation() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Budget Allocation",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Slider(
                value: _budgetAllocation,
                min: 100,
                max: 1000,
                divisions: 9,
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                onChanged: _onBudgetAllocationChanged,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 80,
          child: TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onSubmitted: _onBudgetEntered,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
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
              _isBudgetExceeded
                  ? "Alert! You're over budget!"
                  : "Nice! Great job! You're staying within your budget",
              style: TextStyle(
                  color: _isBudgetExceeded ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTipsButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TipsScreen(userId: widget.userId)));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text("Get Finance Tips",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
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
