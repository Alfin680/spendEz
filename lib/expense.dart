// import 'package:flutter/material.dart';
// import 'package:spendez_main/home.dart';
// import 'package:spendez_main/overallInsights.dart';
// import 'package:spendez_main/tips.dart';

// class CategoryExpenseApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Category Expense',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: CategoryExpenseScreen(),
//     );
//   }
// }

// class CategoryExpenseScreen extends StatefulWidget {
//   @override
//   _CategoryExpenseScreenState createState() => _CategoryExpenseScreenState();
// }

// class _CategoryExpenseScreenState extends State<CategoryExpenseScreen> {
//   int _selectedIndex = 1;

//   // Handle navigation based on index
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navigate to respective pages
//     switch (index) {
//       case 0: // Home
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScr()),
//         );
//         break;
//       case 1: // Expense
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CategoryExpenseApp()),
//         );
//         break;
//       case 2: // Insights
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => InsightsPage()),
//         );
//         break;
//       case 3: // Tips
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Tips()),
//         );
//         break;
//     }
//   }

//   // List of categories and their icons
//   final List<Map<String, String>> categories = [
//     {"name": "Food", "icon": "assets/icons/Efood.png"},
//     {"name": "Travel", "icon": "assets/icons/Etravel.png"},
//     {"name": "Bills", "icon": "assets/icons/Ebills.png"},
//     {"name": "Shopping", "icon": "assets/icons/Eshopping.png"},
//     {"name": "Fun", "icon": "assets/icons/Efun.png"},
//     {"name": "Other", "icon": "assets/icons/Eother.png"},
//   ];

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
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           "Category Expense",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Click to view the Statistics of each category",
//               style: TextStyle(
//                 color: const Color.fromARGB(255, 0, 0, 0),
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return CategoryTile(
//                     name: category['name']!,
//                     iconPath: category['icon']!,
//                     onTap: () {
//                       // Handle tile tap
//                       print('${category['name']} tapped');
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       // Floating Bottom Navigation Bar
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.transparent, // Use container's color
//                 elevation: 0, // Remove default shadow
//                 selectedItemColor: const Color.fromARGB(255, 0, 58, 216),
//                 unselectedItemColor: const Color.fromARGB(179, 255, 255, 255),
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//                 type: BottomNavigationBarType.fixed,
//                 items: [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.attach_money),
//                     label: 'Expense',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.bar_chart),
//                     label: 'Insights',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.lightbulb),
//                     label: 'Tips',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CategoryTile extends StatelessWidget {
//   final String name;
//   final String iconPath;
//   final VoidCallback onTap;

//   const CategoryTile({
//     required this.name,
//     required this.iconPath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF7F07FF),
//               Color(0xFF4C0499),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Correct usage of Image.asset for icons
//             Image.asset(
//               iconPath,
//               width: 100,
//               height: 100,
//               fit: BoxFit.contain,
//             ),
//             SizedBox(height: 8),
//             Text(
//               name,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/overallInsights.dart';
import 'package:spendez_main/tips.dart';

// Import category detail pages
import 'category_food.dart';
import 'category_travel.dart';
import 'category_bills.dart';
import 'category_shopping.dart';
import 'category_fun.dart';
import 'category_other.dart';

class CategoryExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Category Expense',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CategoryExpenseScreen(),
    );
  }
}

class CategoryExpenseScreen extends StatefulWidget {
  @override
  _CategoryExpenseScreenState createState() => _CategoryExpenseScreenState();
}

class _CategoryExpenseScreenState extends State<CategoryExpenseScreen> {
  int _selectedIndex = 1;

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

  // List of categories and their icons with target pages
  final List<Map<String, dynamic>> categories = [
    {"name": "Food", "icon": "assets/icons/Efood.png", "page": Food()},
    {"name": "Travel", "icon": "assets/icons/Etravel.png", "page": Travel()},
    {"name": "Bills", "icon": "assets/icons/Ebills.png", "page": Bill()},
    {
      "name": "Shopping",
      "icon": "assets/icons/Eshopping.png",
      "page": Shopping()
    },
    {"name": "Fun", "icon": "assets/icons/Efun.png", "page": Fun()},
    {"name": "Other", "icon": "assets/icons/Eother.png", "page": Other()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Category Expense",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Click to view the Statistics of each category",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryTile(
                    name: category['name']!,
                    iconPath: category['icon']!,
                    onTap: () {
                      // Navigate to the respective category page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => category['page']),
                      );
                    },
                  );
                },
              ),
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

class CategoryTile extends StatelessWidget {
  final String name;
  final String iconPath;
  final VoidCallback onTap;

  const CategoryTile({
    required this.name,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F07FF),
              Color(0xFF4C0499),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
