// import 'package:flutter/material.dart';
// import 'package:spendez_main/expense.dart';
// import 'package:spendez_main/home.dart';
// import 'package:spendez_main/overallInsights.dart';
// import 'package:spendez_main/tips.dart';

// class AddTransactionScreen extends StatefulWidget {
//   @override
//   _AddTransactionScreenState createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   String selectedCategory = ''; // To store selected category
//   TextEditingController expenseNameController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController amountController = TextEditingController();

//   int _selectedIndex = 0;

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Add Transaction",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Expense Amount Input
//               Center(
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: amountController,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF6E23B4),
//                       ),
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: '₹0',
//                         hintStyle: TextStyle(
//                           fontSize: 48,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF6E23B4).withOpacity(0.5),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Add your expense amount',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Expense Name Input
//               TextField(
//                 controller: expenseNameController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your Expense Name',
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//               // Category Section
//               Text(
//                 'Category',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 'Select the Category of the type of expense',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 16),
//               GridView.count(
//                 crossAxisCount: 3,
//                 shrinkWrap: true,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   _buildCategoryIcon('Food', Icons.restaurant),
//                   _buildCategoryIcon('Travel', Icons.airplanemode_active),
//                   _buildCategoryIcon('Bills', Icons.receipt_long),
//                   _buildCategoryIcon('Fun', Icons.sports_esports),
//                   _buildCategoryIcon('Shopping', Icons.shopping_bag),
//                   _buildCategoryIcon('Other', Icons.more_horiz),
//                 ],
//               ),
//               SizedBox(height: 24),
//               // Description Input
//               Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               TextField(
//                 controller: descriptionController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   hintText:
//                       '💡Tip: Click to write a short note in case you want to look back in the future...',
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//               // Save Transaction Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Save transaction logic
//                     final amount = amountController.text;
//                     final name = expenseNameController.text;
//                     final category = selectedCategory;
//                     final description = descriptionController.text;

//                     print('Amount: ₹$amount');
//                     print('Expense Name: $name');
//                     print('Category: $category');
//                     print('Description: $description');
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF6E23B4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 48, vertical: 16),
//                   ),
//                   child: Text(
//                     'SAVE TRANSACTION',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
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

//   // Helper function to build category icons
//   Widget _buildCategoryIcon(String category, IconData iconData) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedCategory = category;
//         });
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.all(20), // Adjusted padding for size
//             decoration: BoxDecoration(
//               color: selectedCategory == category
//                   ? Color(0xFF6E23B4)
//                   : Colors.grey[200],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               iconData,
//               size: 36, // Adjusted icon size
//               color: selectedCategory == category
//                   ? Colors.white
//                   : Color(0xFF6E23B4),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             category,
//             style: TextStyle(
//               fontSize: 14, // Adjusted for better readability
//               fontWeight: FontWeight.bold,
//               color: selectedCategory == category
//                   ? Color(0xFF6E23B4)
//                   : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:spendez_main/expense.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/overallInsights.dart';
import 'package:spendez_main/tips.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String selectedCategory = ''; // To store selected category
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
      case 3: // Tips
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Tips()),
        );
        break;
    }
  }

  // Function to save transaction
  void _saveTransaction() {
    final amount = amountController.text;
    final name = expenseNameController.text;
    final category = selectedCategory;
    final description = descriptionController.text;

    print('Amount: ₹$amount');
    print('Expense Name: $name');
    print('Category: $category');
    print('Description: $description');

    // Clear input fields to refresh the page for next transaction
    setState(() {
      amountController.clear();
      expenseNameController.clear();
      descriptionController.clear();
      selectedCategory = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Transaction",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expense Amount Input
              Center(
                child: Column(
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E23B4),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '₹0',
                        hintStyle: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E23B4).withOpacity(0.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your expense amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Expense Name Input
              TextField(
                controller: expenseNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Expense Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Category Section
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Select the Category of the type of expense',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildCategoryIcon('Food', Icons.restaurant),
                  _buildCategoryIcon('Travel', Icons.airplanemode_active),
                  _buildCategoryIcon('Bills', Icons.receipt_long),
                  _buildCategoryIcon('Fun', Icons.sports_esports),
                  _buildCategoryIcon('Shopping', Icons.shopping_bag),
                  _buildCategoryIcon('Other', Icons.more_horiz),
                ],
              ),
              SizedBox(height: 24),
              // Description Input
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      '💡Tip: Click to write a short note in case you want to look back in the future...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Save Transaction Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6E23B4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                  ),
                  child: Text(
                    'SAVE TRANSACTION',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTransaction,
        backgroundColor: Color(0xFF6E23B4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  // Helper function to build category icons
  Widget _buildCategoryIcon(String category, IconData iconData) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selectedCategory == category
                  ? Color(0xFF6E23B4)
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 36,
              color: selectedCategory == category
                  ? Colors.white
                  : Color(0xFF6E23B4),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selectedCategory == category
                  ? Color(0xFF6E23B4)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
