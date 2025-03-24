// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:spendez_main/category_bills.dart';
// import 'package:spendez_main/category_food.dart';
// import 'package:spendez_main/category_fun.dart';
// import 'package:spendez_main/category_other.dart';
// import 'package:spendez_main/category_shopping.dart';
// import 'package:spendez_main/category_travel.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/home.dart';
// import 'package:spendez_main/tips.dart';

// class InsightsPage extends StatefulWidget {
//   final int userId;

//   InsightsPage({required this.userId});

//   @override
//   _InsightsPageState createState() => _InsightsPageState();
// }

// class _InsightsPageState extends State<InsightsPage> {
//   String _selectedDuration = 'Month';
//   double _totalSpent = 0.0;
//   final List<String> _durations = ['Week', 'Month', 'Year'];
//   int _selectedIndex = 2;
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = false;

//   final Map<String, String> _defaultCategories = {
//     "Food": "#FFA500",
//     "Travel": "#008000",
//     "Bills": "#FF0000",
//     "Fun": "#0000FF",
//     "Other": "#800080",
//     "Shopping": "#FF69B4"
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData(_selectedDuration);
//   }

//   Future<void> _fetchData(String duration) async {
//     setState(() {
//       _isLoading = true;
//     });

//     // final url = Uri.parse(
//     //     "http://127.0.0.1:5000/insights/${widget.userId}?duration=$duration");
//     final url = Uri.parse(
//         "http://10.0.2.2:5000/insights/${widget.userId}?duration=$duration");
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("Fetched data: $data");
//         Map<String, dynamic> fetchedCategories = {
//           for (var item in data['categories'])
//             item['name']: {
//               "amount": item['amount'],
//               "percentage": item['percentage'],
//               "color": item['color']
//             }
//         };

//         _categories = _defaultCategories.entries.map((entry) {
//           return {
//             "name": entry.key,
//             "color": entry.value,
//             "amount": fetchedCategories.containsKey(entry.key)
//                 ? fetchedCategories[entry.key]['amount']
//                 : "₹0.00",
//             "percentage": fetchedCategories.containsKey(entry.key)
//                 ? fetchedCategories[entry.key]['percentage']
//                 : "0%",
//           };
//         }).toList();

//         setState(() {
//           _totalSpent = data['total_spent'].toDouble();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
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

//   void _navigateToCategory(String categoryName) {
//     switch (categoryName) {
//       case "Food":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Food(userId: widget.userId)));
//         break;
//       case "Travel":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Travel(userId: widget.userId)));
//         break;
//       case "Bills":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Bill(userId: widget.userId)));
//         break;
//       case "Fun":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Fun(userId: widget.userId)));
//         break;
//       case "Others":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Other(userId: widget.userId)));
//         break;
//       case "Shopping":
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Shopping(userId: widget.userId)));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Insights",
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Center(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(
//                           height: 220,
//                           width: 200,
//                           child: PieChart(
//                             PieChartData(
//                               sections: _categories.map((category) {
//                                 return PieChartSectionData(
//                                   color: Color(int.parse(category['color']
//                                       .replaceAll("#", "0xff"))),
//                                   value: double.tryParse(category['percentage']
//                                           .replaceAll('%', '')) ??
//                                       0,
//                                   title: '',
//                                   radius: 25,
//                                 );
//                               }).toList(),
//                               sectionsSpace: 4,
//                               centerSpaceRadius: 80,
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Text("Spent this $_selectedDuration",
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.black54)),
//                             Text(
//                               "₹${_totalSpent.toStringAsFixed(0)}",
//                               style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: _durations.map((duration) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() => _selectedDuration = duration);
//                           _fetchData(duration);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           child: Text(
//                             duration,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: _selectedDuration == duration
//                                   ? const Color(0xFF3D33FF)
//                                   : Colors.grey,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 16),
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(24),
//                           topRight: Radius.circular(24)),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 6,
//                             offset: Offset(0, -2))
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Spending insights",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 16),
//                         GridView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2, // 2 cards per row
//                             crossAxisSpacing: 16,
//                             mainAxisSpacing: 16,
//                             childAspectRatio: 1, // Square cards
//                           ),
//                           itemCount: _categories.length,
//                           itemBuilder: (context, index) {
//                             final category = _categories[index];
//                             return _buildSquareCard(
//                               category['amount'],
//                               category['percentage'],
//                               category['name'],
//                               category['color'],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: Offset(0, -2)),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 selectedItemColor: const Color(0xFF7F07FF),
//                 unselectedItemColor: Colors.white.withOpacity(0.7),
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//                 type: BottomNavigationBarType.fixed,
//                 items: [
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.home), label: 'Home'),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.attach_money), label: 'Expense'),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.bar_chart), label: 'Insights'),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.lightbulb), label: 'Tips'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSquareCard(
//       String amount, String percentage, String category, String colorCode) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 4,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(int.parse(colorCode.replaceAll("#", "0xff"))),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   category,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               amount,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             SizedBox(height: 8),
//             Text(
//               percentage,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             SizedBox(height: 8),
//             // Text(
//             //   "Notes:",
//             //   style: TextStyle(fontSize: 14, color: Colors.black54),
//             // ),
//             // Text(
//             //   "Note subscription",
//             //   style: TextStyle(fontSize: 14, color: Colors.black54),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendez_main/category_bills.dart';
import 'package:spendez_main/category_food.dart';
import 'package:spendez_main/category_fun.dart';
import 'package:spendez_main/category_other.dart';
import 'package:spendez_main/category_shopping.dart';
import 'package:spendez_main/category_travel.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/tips.dart';
import 'analyse.dart';

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
  bool _isLoading = false;

  final Map<String, String> _defaultCategories = {
    "Food": "#FFA500",
    "Travel": "#008000",
    "Bills": "#FF0000",
    "Fun": "#0000FF",
    "Other": "#800080",
    "Shopping": "#FF69B4"
  };

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedDuration);
  }

  Future<void> _fetchData(String duration) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "http://10.0.2.2:5000/insights/${widget.userId}?duration=$duration");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched data: $data"); // Debugging: Print API response

        // Ensure the API response contains the expected fields
        if (data.containsKey('total_spent') && data.containsKey('categories')) {
          Map<String, dynamic> fetchedCategories = {
            for (var item in data['categories'])
              item['name']: {
                "amount": item['amount'],
                "percentage": item['percentage'],
                "color": item['color']
              }
          };

          _categories = _defaultCategories.entries.map((entry) {
            return {
              "name": entry.key,
              "color": entry.value,
              "amount": fetchedCategories.containsKey(entry.key)
                  ? fetchedCategories[entry.key]['amount']
                  : "₹0.00",
              "percentage": fetchedCategories.containsKey(entry.key)
                  ? fetchedCategories[entry.key]['percentage']
                  : "0%",
            };
          }).toList();

          // Parse total_spent as a double
          setState(() {
            _totalSpent = double.tryParse(data['total_spent'].toString()) ??
                0.0; // Fix: Parse as double
            _isLoading = false;
          });
        } else {
          throw Exception("Invalid API response structure");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e"); // Debugging: Print error
      setState(() {
        _isLoading = false;
        _totalSpent = 0.0; // Fallback to 0 if there's an error
      });
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

  void _navigateToCategory(String categoryName) {
    switch (categoryName) {
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
      case "Shopping":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Shopping(userId: widget.userId)));
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
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  color: Color(int.parse(category['color']
                                      .replaceAll("#", "0xff"))),
                                  value: double.tryParse(category['percentage']
                                          .replaceAll('%', '')) ??
                                      0,
                                  title: '',
                                  radius: 25,
                                );
                              }).toList(),
                              sectionsSpace: 4,
                              centerSpaceRadius: 80,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text("Spent this $_selectedDuration",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                            Text(
                              "₹${_totalSpent.toStringAsFixed(2)}", // Ensure this is correctly displayed
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
                        onTap: () {
                          setState(() => _selectedDuration = duration);
                          _fetchData(duration);
                        },
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
                    padding: EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Spending insights",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 cards per row
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1, // Square cards
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return _buildSquareCard(
                              category['amount'],
                              category['percentage'],
                              category['name'],
                              category['color'],
                            );
                          },
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

  Widget _buildSquareCard(
      String amount, String percentage, String category, String colorCode) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(colorCode.replaceAll("#", "0xff"))),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              percentage,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendez_main/category_bills.dart';
import 'package:spendez_main/category_food.dart';
import 'package:spendez_main/category_fun.dart';
import 'package:spendez_main/category_other.dart';
import 'package:spendez_main/category_shopping.dart';
import 'package:spendez_main/category_travel.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/tips.dart';
import 'analyse.dart'; // Import the AnalysePage

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
  bool _isLoading = false;

  final Map<String, String> _defaultCategories = {
    "Food": "#FFA500",
    "Travel": "#008000",
    "Bills": "#FF0000",
    "Fun": "#0000FF",
    "Other": "#800080",
    "Shopping": "#FF69B4"
  };

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedDuration);
  }

  Future<void> _fetchData(String duration) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "http://127.0.0.1:5000/insights/${widget.userId}?duration=$duration");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched data: $data"); // Debugging: Print API response

        // Ensure the API response contains the expected fields
        if (data.containsKey('total_spent') && data.containsKey('categories')) {
          Map<String, dynamic> fetchedCategories = {
            for (var item in data['categories'])
              item['name']: {
                "amount": item['amount'],
                "percentage": item['percentage'],
                "color": item['color']
              }
          };

          _categories = _defaultCategories.entries.map((entry) {
            return {
              "name": entry.key,
              "color": entry.value,
              "amount": fetchedCategories.containsKey(entry.key)
                  ? fetchedCategories[entry.key]['amount']
                  : "₹0.00",
              "percentage": fetchedCategories.containsKey(entry.key)
                  ? fetchedCategories[entry.key]['percentage']
                  : "0%",
            };
          }).toList();

          // Parse total_spent as a double
          setState(() {
            _totalSpent = double.tryParse(data['total_spent'].toString()) ??
                0.0; // Fix: Parse as double
            _isLoading = false;
          });
        } else {
          throw Exception("Invalid API response structure");
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e"); // Debugging: Print error
      setState(() {
        _isLoading = false;
        _totalSpent = 0.0; // Fallback to 0 if there's an error
      });
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

  void _navigateToCategory(String categoryName) {
    switch (categoryName) {
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
      case "Shopping":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Shopping(userId: widget.userId)));
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
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          // Add Analysis Button
          IconButton(
            icon: Icon(Icons.analytics, color: Colors.black),
            onPressed: () {
              // Navigate to AnalysePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalysisPage(userId:widget.userId), // Navigate to AnalysePage
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  color: Color(int.parse(category['color']
                                      .replaceAll("#", "0xff"))),
                                  value: double.tryParse(category['percentage']
                                          .replaceAll('%', '')) ??
                                      0,
                                  title: '',
                                  radius: 25,
                                );
                              }).toList(),
                              sectionsSpace: 4,
                              centerSpaceRadius: 80,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text("Spent this $_selectedDuration",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                            Text(
                              "₹${_totalSpent.toStringAsFixed(2)}", // Ensure this is correctly displayed
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
                        onTap: () {
                          setState(() => _selectedDuration = duration);
                          _fetchData(duration);
                        },
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
                    padding: EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Spending insights",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 cards per row
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1, // Square cards
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return _buildSquareCard(
                              category['amount'],
                              category['percentage'],
                              category['name'],
                              category['color'],
                            );
                          },
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

  Widget _buildSquareCard(
      String amount, String percentage, String category, String colorCode) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(colorCode.replaceAll("#", "0xff"))),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              percentage,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}