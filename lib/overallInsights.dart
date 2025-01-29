import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendez_main/category_bills.dart';
import 'package:spendez_main/category_food.dart';
import 'package:spendez_main/category_fun.dart';
import 'package:spendez_main/category_other.dart';
import 'package:spendez_main/category_travel.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/tips.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String _selectedDuration = 'Month'; // Default duration.
  double _totalSpent = 400; // Total spent (from backend)
  final List<String> _durations = ['Week', 'Month', 'Year'];

  // Categories fetched from backend
  List<Map<String, dynamic>> _categories = [
    {
      "name": "Fun",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.emoji_emotions,
      "color": Colors.green
    },
    {
      "name": "Bills",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.receipt,
      "color": Colors.blue
    },
    {
      "name": "Food",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.fastfood,
      "color": Colors.amber
    },
    {
      "name": "Travel",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.directions_car,
      "color": Colors.cyan
    },
    {
      "name": "Shopping",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.shopping_bag,
      "color": Colors.pink
    },
    {
      "name": "Others",
      "amount": "₹100",
      "percentage": "25%",
      "icon": Icons.more_horiz,
      "color": Colors.grey
    },
  ];

  // Mock backend data fetch for dynamic updates
  Future<void> _fetchData(String duration) async {
    // Simulate a backend API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _selectedDuration = duration;

      // Update dynamic data based on duration (mock example)
      if (duration == 'Week') {
        _totalSpent = 150;
        _categories = [
          {
            "name": "Fun",
            "amount": "₹50",
            "percentage": "33%",
            "icon": Icons.emoji_emotions,
            "color": Colors.green
          },
          {
            "name": "Bills",
            "amount": "₹40",
            "percentage": "27%",
            "icon": Icons.receipt,
            "color": Colors.blue
          },
          {
            "name": "Food",
            "amount": "₹30",
            "percentage": "20%",
            "icon": Icons.fastfood,
            "color": Colors.amber
          },
          {
            "name": "Travel",
            "amount": "₹30",
            "percentage": "20%",
            "icon": Icons.directions_car,
            "color": Colors.cyan
          },
          {
            "name": "Shopping",
            "amount": "₹100",
            "percentage": "25%",
            "icon": Icons.shopping_bag,
            "color": Colors.pink
          },
          {
            "name": "Others",
            "amount": "₹100",
            "percentage": "25%",
            "icon": Icons.more_horiz,
            "color": Colors.grey
          },
        ];
      } else if (duration == 'Month') {
        _totalSpent = 600;
        _categories = [
          {
            "name": "Fun",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.emoji_emotions,
            "color": Colors.green
          },
          {
            "name": "Bills",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.receipt,
            "color": Colors.blue
          },
          {
            "name": "Food",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.fastfood,
            "color": Colors.amber
          },
          {
            "name": "Travel",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.directions_car,
            "color": Colors.cyan
          },
          {
            "name": "Shopping",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.shopping_bag,
            "color": Colors.pink
          },
          {
            "name": "Others",
            "amount": "₹100",
            "percentage": "16.6%",
            "icon": Icons.more_horiz,
            "color": Colors.grey
          },
        ];
      } else if (duration == 'Year') {
        _totalSpent = 4500;
        _categories = [
          {
            "name": "Fun",
            "amount": "₹2000",
            "percentage": "44.4%",
            "icon": Icons.emoji_emotions,
            "color": Colors.green
          },
          {
            "name": "Bills",
            "amount": "₹1500",
            "percentage": "33.3%",
            "icon": Icons.receipt,
            "color": Colors.blue
          },
          {
            "name": "Food",
            "amount": "₹1000",
            "percentage": "22.22%",
            "icon": Icons.fastfood,
            "color": Colors.amber
          },
        ];
      }
    });
  }

  int _selectedIndex = 2;

  // Handle navigation based on index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective pages
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScr()),
        );
        break;
      case 1: // Expense
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoryExpenseApp()),
        );
        break;
      case 2: // Insights
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InsightsPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Tips()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Insights",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Circular Chart
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 220,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _categories.map((category) {
                          return PieChartSectionData(
                            color: category['color'],
                            value: double.tryParse(category['percentage']
                                    .replaceAll('%', '')) ??
                                0,
                            title: '',
                            radius: 25,
                            titleStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 4,
                        centerSpaceRadius: 80, // Ring effect
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Spent this $_selectedDuration",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        "₹${_totalSpent.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Duration Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _durations.map((duration) {
                return GestureDetector(
                  onTap: () async {
                    await _fetchData(duration); // Update dynamically
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      duration,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedDuration == duration
                            ? const Color.fromARGB(255, 61, 51, 255)
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // White background sheet with curved edges
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Spending insights",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return _buildSpendingCard(
                            category['amount'],
                            category['percentage'],
                            category['name'],
                            category['icon'],
                            category['color'],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color.fromARGB(255, 0, 58, 216),
                unselectedItemColor: const Color.fromARGB(179, 255, 255, 255),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.attach_money),
                    label: 'Expense',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Insights',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lightbulb),
                    label: 'Tips',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingCard(String amount, String percentage, String category,
      IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Icon(icon, color: color, size: 36),
          ),
          SizedBox(height: 8),
          Flexible(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 8),
          Flexible(
            flex: 3,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to respective page
                  switch (category) {
                    case "Food":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Food()),
                      );
                      break;
                    case "Travel":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Travel()),
                      );
                      break;
                    case "Bills":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Bill()),
                      );
                      break;
                    case "Fun":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Fun()),
                      );
                      break;
                    case "Others":
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Other()),
                      );
                      break;
                    default:
                      print("No page found for $category");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "VIEW",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
