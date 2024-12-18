import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/overallInsights.dart';

class Tips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manage Finances',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TipsScreen(),
    );
  }
}

class TipsScreen extends StatefulWidget {
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  int _selectedIndex = 3;

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
      case 3: // Tips
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
          "Manage Finances",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Get Tips and Tricks for managing your finances effectively",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                TipCard(
                  icon: Icons.lightbulb,
                  title: "Follow 50/30/20 Rule",
                  description:
                      "Spend 50% on essentials, 30% on fun, and save 20%.",
                ),
                TipCard(
                  icon: Icons.lightbulb,
                  title: "Track every Rupee",
                  description:
                      "Keep an eye on your spending to spot areas of quick saving with our app.",
                ),
                TipCard(
                  icon: Icons.lightbulb,
                  title: "Set Budgeting Goals",
                  description:
                      "Set budgeting goals for each category, using our category-wise budgeting.",
                ),
                SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 120,
                        color: const Color.fromARGB(255, 0, 8, 255)
                            .withOpacity(0.2),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "MORE TIPS SOON :)",
                        style: TextStyle(
                          fontSize: 22,
                          color: const Color.fromARGB(255, 0, 8, 255)
                              .withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Color.fromARGB(255, 0, 58, 216),
                unselectedItemColor: Colors.white70,
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
}

class TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
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
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 24,
            child: Icon(
              icon,
              color: Colors.limeAccent,
              size: 28,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text(
          '$title Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
