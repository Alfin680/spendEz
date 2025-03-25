// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:spendez_main/addTransaction.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/overallInsights.dart';
// import 'package:spendez_main/tips.dart';
// import 'package:intl/intl.dart';
// import 'package:spendez_main/shared_pref.dart'; // Import SharedPrefs
// import 'package:spendez_main/login.dart'; // Import LoginPage for navigation

// class HomeScr extends StatelessWidget {
//   final int userId;

//   HomeScr({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Expense Tracker',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeScreen(userId: userId),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   final int userId;

//   HomeScreen({required this.userId});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final String apiUrl = "http://127.0.0.1:5000/transactions";
//   //final String apiUrl = "http://10.0.2.2:5000/transactions";

//   Future<List<Map<String, dynamic>>> _fetchTransactions() async {
//     try {
//       final response = await http.get(Uri.parse("$apiUrl/${widget.userId}"));

//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
//       } else {
//         throw Exception('Failed to load transactions');
//       }
//     } catch (e) {
//       throw Exception('Error fetching transactions: $e');
//     }
//   }

//   void _onItemTapped(int index) {
//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => HomeScr(userId: widget.userId)));
//         break;
//       case 1:
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     CategoryExpenseScreen(userId: widget.userId)));
//         break;
//       case 2:
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => InsightsPage(userId: widget.userId)));
//         break;
//       case 3:
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => TipsScreen(userId: widget.userId)));
//         break;
//     }
//   }

//   // Logout function
//   Future<void> _logout() async {
//     await SharedPrefs().clear(); // Clear Shared Preferences
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => LoginPage()), // Redirect to LoginPage
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Custom Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Home",
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.logout),
//                     onPressed: _logout, // Call logout function
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),

//               // Rest of your content
//               _buildAddTransactionCard(),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Recent Transactions",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               AllTransactions(userId: widget.userId),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "VIEW ALL",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               _buildTransactionList(),
//             ],
//           ),
//         ),
//       ),

//       // Floating Bottom Navigation Bar
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }

//   Widget _buildAddTransactionCard() {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.shade300,
//               blurRadius: 10,
//               offset: Offset(0, 4)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Track your Expense",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
//           SizedBox(height: 8),
//           Text(
//             "Click the add button below to track your individual expenses",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
//           ),
//           SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             AddTransactionScreen(userId: widget.userId)));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF7F07FF),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//               ),
//               child: Text("+ Add Transactions",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionList() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 10,
//                 offset: Offset(0, 4)),
//           ],
//         ),
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: _fetchTransactions(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text("No transactions available."));
//             }

//             // Limit transactions to 6
//             List<Map<String, dynamic>> recentTransactions =
//                 snapshot.data!.take(6).toList();

//             return ListView.builder(
//               itemCount: recentTransactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = recentTransactions[index];
//                 return TransactionItem(
//                   date: transaction['date_time'],
//                   name: transaction['expense_name'],
//                   category: transaction['category'],
//                   amount:
//                       double.tryParse(transaction['amount'].toString()) ?? 0.0,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: Offset(0, -2)),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: BottomNavigationBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               selectedItemColor: const Color(0xFF7F07FF),
//               unselectedItemColor: Colors.white.withOpacity(0.7),
//               currentIndex: _selectedIndex,
//               onTap: _onItemTapped,
//               type: BottomNavigationBarType.fixed,
//               items: [
//                 BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.attach_money), label: 'Expense'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.bar_chart), label: 'Insights'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.lightbulb), label: 'Tips'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Transaction List Item Widget
// class TransactionItem extends StatelessWidget {
//   final String date;
//   final String name;
//   final String category;
//   final num amount;

//   TransactionItem({
//     required this.date,
//     required this.name,
//     required this.category,
//     required this.amount,
//   });

//   String _formatDate(String date) {
//     try {
//       // Parse the RFC 1123 formatted date
//       DateTime parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
//           .parseUtc(date)
//           .toLocal();

//       // Return formatted day and month abbreviation (e.g., "13 Mar")
//       return "${parsedDate.day} ${_getMonthAbbreviation(parsedDate.month)}";
//     } catch (e) {
//       print("Date parsing error: $e, input: $date");
//       return "Invalid Date"; // Handle errors gracefully
//     }
//   }

//   String _getMonthAbbreviation(int month) {
//     const months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];
//     return months[month - 1];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3.5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16), // Curved edges
//           border: Border.all(
//               color: const Color.fromARGB(255, 31, 30, 30),
//               width: 2), // Black boundary
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ListTile(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           leading: CircleAvatar(
//             backgroundColor: Colors.blue.shade100,
//             child: Text(
//               _formatDate(date),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//           ),
//           title: Text(
//             name,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           subtitle: Text(
//             category,
//             style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
//           ),
//           trailing: Text(
//             "₹${amount.toStringAsFixed(2)}",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: amount < 0 ? Colors.red : Colors.green,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class AllTransactions extends StatelessWidget {
//   final int userId;

//   AllTransactions({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "All Transactions",
//           style: TextStyle(
//             fontWeight: FontWeight.bold, // Make the text bolder
//             fontSize: 20, // Optional: Adjust the font size
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchTransactions(userId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//                 child: Text("No transactions available for this month."));
//           }

//           return Container(
//             margin: EdgeInsets.all(16), // Add margin around the container
//             padding: EdgeInsets.all(16), // Add padding inside the container
//             decoration: BoxDecoration(
//               color: Colors.white, // White background
//               borderRadius: BorderRadius.circular(20), // Rounded corners
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final transaction = snapshot.data![index];
//                 return TransactionItem(
//                   date: transaction['date_time'],
//                   name: transaction['expense_name'],
//                   category: transaction['category'],
//                   amount:
//                       double.tryParse(transaction['amount'].toString()) ?? 0.0,
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<List<Map<String, dynamic>>> _fetchTransactions(int userId) async {
//     try {
//       final response = await http
//           .get(Uri.parse("http://10.0.2.2:5000/transactions/$userId"));

//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         // Convert to List<Map<String, dynamic>> and sort by date (most recent first)
//         List<Map<String, dynamic>> transactions =
//             jsonData.map((item) => Map<String, dynamic>.from(item)).toList();

//         // Sort by date (assuming 'date_time' is in RFC 1123 format)
//         transactions.sort((a, b) {
//           DateTime dateA = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
//               .parseUtc(a['date_time']);
//           DateTime dateB = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
//               .parseUtc(b['date_time']);
//           return dateB.compareTo(dateA); // Sort in descending order
//         });

//         // Filter transactions to include only those from the current month
//         DateTime now = DateTime.now();
//         List<Map<String, dynamic>> currentMonthTransactions =
//             transactions.where((transaction) {
//           DateTime transactionDate =
//               DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
//                   .parseUtc(transaction['date_time']);
//           return transactionDate.month == now.month &&
//               transactionDate.year == now.year;
//         }).toList();

//         return currentMonthTransactions;
//       } else {
//         throw Exception('Failed to load transactions');
//       }
//     } catch (e) {
//       throw Exception('Error fetching transactions: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spendez_main/addTransaction.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/overallInsights.dart';
import 'package:spendez_main/tips.dart';
import 'package:intl/intl.dart';
import 'package:spendez_main/shared_pref.dart'; // Import SharedPrefs
import 'package:spendez_main/login.dart'; // Import LoginPage for navigation

class HomeScr extends StatelessWidget {
  final int userId;

  HomeScr({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(userId: userId),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  //final String apiUrl = "http://127.0.0.1:5000/transactions";
  final String apiUrl = "http://10.0.2.2:5000/transactions";

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/${widget.userId}"));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
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

  // Logout function
  Future<void> _logout() async {
    await SharedPrefs().clear(); // Clear Shared Preferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Redirect to LoginPage
    );
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
              // Custom Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: _logout, // Call logout function
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Rest of your content
              _buildAddTransactionCard(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllTransactions(userId: widget.userId),
                        ),
                      );
                    },
                    child: Text(
                      "VIEW ALL",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildTransactionList(),
            ],
          ),
        ),
      ),

      // Floating Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAddTransactionCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Track your Expense",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text(
            "Click the add button below to track your individual expenses",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTransactionScreen(userId: widget.userId)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7F07FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("+ Add Transactions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: Offset(0, 4)),
          ],
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No transactions available."));
            }

            // Limit transactions to 6
            List<Map<String, dynamic>> recentTransactions =
                snapshot.data!.take(6).toList();

            return ListView.builder(
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                return TransactionItem(
                  date: transaction['date_time'],
                  name: transaction['expense_name'],
                  category: transaction['category'],
                  amount: transaction['amount'].toString(), // Pass as String
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SafeArea(
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
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String name;
  final String category;
  final String amount;

  TransactionItem({
    required this.date,
    required this.name,
    required this.category,
    required this.amount,
  });

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
          .parseUtc(date)
          .toLocal();
      return "${parsedDate.day} ${_getMonthAbbreviation(parsedDate.month)}";
    } catch (e) {
      print("Date parsing error: $e, input: $date");
      return "Invalid Date";
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    double parsedAmount = double.tryParse(amount) ?? 0.0;
    String formattedAmount = parsedAmount.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color.fromARGB(255, 31, 30, 30), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              _formatDate(date),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            category,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          trailing: Text(
            "₹$formattedAmount",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: parsedAmount < 0 ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

class AllTransactions extends StatefulWidget {
  final int userId;

  AllTransactions({required this.userId});

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  List<int> _selectedTransactions = [];

  Future<void> _deleteSelectedTransactions() async {
    if (_selectedTransactions.isEmpty) return;

    final response = await http.delete(
      Uri.parse("http://10.0.2.2:5000/transactions/delete"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"transaction_ids": _selectedTransactions}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _selectedTransactions.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transactions deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete transactions.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Transactions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (_selectedTransactions.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedTransactions,
            ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTransactions(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No transactions available for this month."));
          }

          return Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                final isSelected = _selectedTransactions
                    .contains(transaction['transaction_id']);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedTransactions
                              .add(transaction['transaction_id']);
                        } else {
                          _selectedTransactions
                              .remove(transaction['transaction_id']);
                        }
                      });
                    },
                  ),
                  title: Text(transaction['expense_name']),
                  subtitle: Text(transaction['category']),
                  trailing: Text(
                    "₹${double.tryParse(transaction['amount'].toString())?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          (double.tryParse(transaction['amount'].toString()) ??
                                      0.0) <
                                  0
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions(int userId) async {
    try {
      final response = await http
          .get(Uri.parse("http://10.0.2.2:5000/transactions/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Map<String, dynamic>> transactions =
            jsonData.map((item) => Map<String, dynamic>.from(item)).toList();

        transactions.sort((a, b) {
          DateTime dateA = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
              .parseUtc(a['date_time']);
          DateTime dateB = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
              .parseUtc(b['date_time']);
          return dateB.compareTo(dateA);
        });

        DateTime now = DateTime.now();
        List<Map<String, dynamic>> currentMonthTransactions =
            transactions.where((transaction) {
          DateTime transactionDate =
              DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
                  .parseUtc(transaction['date_time']);
          return transactionDate.month == now.month &&
              transactionDate.year == now.year;
        }).toList();

        return currentMonthTransactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
