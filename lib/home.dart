import 'package:flutter/material.dart';
import 'package:spendez_main/addTransaction.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/overallInsights.dart';
import 'package:spendez_main/tips.dart';

class HomeScr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/add': (context) => AddTransactionScreen(),
        '/expense': (context) => CategoryExpenseApp(),
        '/tips': (context) => Tips()
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Placeholder data simulating data from backend
  final List<Map<String, dynamic>> transactions = [
    {"date": "16 AUG", "name": "Netflix", "category": "Fun", "amount": -500},
    {"date": "16 AUG", "name": "Lunch", "category": "Food", "amount": -200},
    {"date": "16 AUG", "name": "Petrol", "category": "Travel", "amount": -500},
    {"date": "16 AUG", "name": "Bus", "category": "Travel", "amount": -100},
    {"date": "16 AUG", "name": "Lunch", "category": "Food", "amount": -300},
    {"date": "16 AUG", "name": "Breakfast", "category": "Food", "amount": -300},
    {"date": "16 AUG", "name": "Fees", "category": "Bill", "amount": -300},
    {"date": "16 AUG", "name": "Breakfast", "category": "Food", "amount": -300},
    {"date": "16 AUG", "name": "Breakfast", "category": "Food", "amount": -300},
  ];

  int _selectedIndex = 0;

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and Add Transaction
              Row(
                children: [
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Track Expense Card
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Track your Expense",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Click the add button below to track your individual expenses",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7F07FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "+ Add Transactions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Recent Transactions Sheet
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionItem(
                        date: transaction['date'],
                        name: transaction['name'],
                        category: transaction['category'],
                        amount: transaction['amount'],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
                backgroundColor: Colors.transparent, // Use container's color
                elevation: 0, // Remove default shadow
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
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String name;
  final String category;
  final int amount;

  TransactionItem({
    required this.date,
    required this.name,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(131, 101, 113, 245),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 51, 0, 255),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            category,
            style: TextStyle(
              color: category == 'Food'
                  ? Colors.amber
                  : category == 'Travel'
                      ? Colors.blue
                      : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Text(
            "₹${amount.toString()}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amount < 0 ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
