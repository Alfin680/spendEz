import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
      case 3: // Tips
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScr()),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Insights",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCircularChart(),
            SizedBox(height: 16),
            _buildTimeToggleButtons(),
            SizedBox(height: 16),
            Text(
              "Spending insights",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _buildSpendingCards(),
            ),
          ],
        ),
      ),
      // Floating Bottom Navigation Bar
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
                  offset: Offset(0, -2),
                ),
              ],
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

  /// Circular Chart Section
  Widget _buildCircularChart() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Chart: Placeholder Widgets
          Container(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: 1, // Full circle
              strokeWidth: 12,
              color: Colors.yellow,
              backgroundColor: Colors.transparent,
            ),
          ),
          Positioned(
            child: Text(
              "Spent this April ▼\n₹400",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Place Chart Segments with Colors
          Positioned(
            top: 0,
            child: _buildSegmentLabel('25%', Colors.yellow),
          ),
          Positioned(
            bottom: 0,
            child: _buildSegmentLabel('25%', Colors.blue),
          ),
          Positioned(
            left: 0,
            child: _buildSegmentLabel('25%', Colors.green),
          ),
          Positioned(
            right: 0,
            child: _buildSegmentLabel('25%', Colors.cyan),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentLabel(String percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        Text(
          percentage,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

  /// Time Toggle Buttons (Week/Month/Year)
  Widget _buildTimeToggleButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton("Week", false),
          SizedBox(width: 8),
          _buildToggleButton("Month", true),
          SizedBox(width: 8),
          _buildToggleButton("Year", false),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.black : Colors.grey,
        decoration: isSelected ? TextDecoration.underline : null,
      ),
    );
  }

  /// Spending Insights Cards
  Widget _buildSpendingCards() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildSpendingCard(
            "₹100", "25%", "Fun", Icons.emoji_emotions, Colors.green),
        _buildSpendingCard("₹100", "25%", "Bills", Icons.receipt, Colors.blue),
        _buildSpendingCard(
            "₹100", "25%", "Food", Icons.restaurant, Colors.yellow),
        _buildSpendingCard(
            "₹100", "25%", "Travel", Icons.directions_car, Colors.cyan),
      ],
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
          Icon(icon, color: color, size: 36),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              print("$category View clicked");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
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
          )
        ],
      ),
    );
  }
}
