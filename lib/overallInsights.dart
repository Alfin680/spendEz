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
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsightsPage extends StatefulWidget {
  final int userId;

  InsightsPage({required this.userId});

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String _selectedDuration = 'Month';
  double _totalSpent = 0.0;
  final List<String> _durations = ['Week', 'Month', 'Year'];
  int _selectedIndex = 2;

  List<Map<String, dynamic>> _categories = [];

  Future<void> _fetchData(String duration) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:5000/insights/${widget.userId}?duration=$duration'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _selectedDuration = duration;
          _totalSpent = data['total_spent'];
          _categories = List<Map<String, dynamic>>.from(data['categories']);
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching insights: $e');
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScr(userId: widget.userId)));
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryExpenseScreen(userId: widget.userId)));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => InsightsPage(userId: widget.userId)));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TipsScreen(userId: widget.userId)));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedDuration);
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
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            color: Color(int.parse(
                                category['color'].replaceAll("#", "0xff"))),
                            value: double.tryParse(category['percentage']
                                    .replaceAll('%', '')) ??
                                0,
                            title: '',
                            radius: 25,
                            titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        }).toList(),
                        sectionsSpace: 4,
                        centerSpaceRadius: 80,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Spent this $_selectedDuration",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                      Text(
                        "₹${_totalSpent.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _durations.map((duration) {
                return GestureDetector(
                  onTap: () => _fetchData(duration),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      duration,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedDuration == duration
                            ? const Color(0xFF3D33FF)
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2))
                ],
              ),
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildSpendingCard(
                    category['amount'],
                    category['percentage'],
                    category['name'],
                    category['color'],
                  );
                },
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
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color(0xFF7F07FF),
                unselectedItemColor: Colors.white.withOpacity(0.7),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.attach_money), label: 'Expense'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: 'Insights'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.lightbulb), label: 'Tips'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingCard(
      String amount, String percentage, String category, String colorCode) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.category,
            color: Color(int.parse(colorCode.replaceAll("#", "0xff")))),
        title: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$amount ($percentage)"),
        trailing: ElevatedButton(
          onPressed: () {
            _navigateToCategory(category);
          },
          child: Text("VIEW"),
        ),
      ),
    );
  }

  void _navigateToCategory(String category) {
    switch (category) {
      case "Food":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Food(userId: widget.userId)));
        break;
      case "Travel":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Travel(userId: widget.userId)));
        break;
      case "Bills":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Bill(userId: widget.userId)));
        break;
      case "Fun":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Fun(userId: widget.userId)));
        break;
      case "Others":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Other(userId: widget.userId)));
        break;
      default:
        print("No page found for $category");
    }
  }
}
