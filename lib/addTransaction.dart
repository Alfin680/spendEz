import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final String apiUrl = "http://10.0.2.2:5000/transactions";
  String selectedCategory = '';
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isRecurring = false;

  Future<void> _saveTransaction({bool shouldNavigateHome = false}) async {
    final amount = amountController.text.trim();
    final name = expenseNameController.text.trim();
    final category = selectedCategory.trim();
    final description = descriptionController.text.trim();

    // Validation: Ensure required fields are not empty
    if (amount.isEmpty || name.isEmpty || category.isEmpty) {
      _showCustomSnackBar('Please fill in all required fields');
      return;
    }

    try {
      final transactionData = {
        'user_id': 1, // Replace with actual user ID
        'amount': double.tryParse(amount) ?? 0.0,
        'expense_name': name,
        'category': category,
        'description': description,
        'is_recurring': isRecurring,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        _showSuccessDialog(shouldNavigateHome);
      } else {
        _showCustomSnackBar('Failed to save transaction');
      }
    } catch (e) {
      _showCustomSnackBar('Error: $e');
    }
  }

// Function to show a success dialog
  void _showSuccessDialog(bool shouldNavigateHome) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close the popup
          if (shouldNavigateHome) {
            Navigator.of(context)
                .pushReplacementNamed('/home'); // Navigate to home
          } else {
            _resetForm(); // Reload the same page (clear input fields)
          }
        });

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 16),
              Text(
                "Transaction saved successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

// Function to reset form fields
  void _resetForm() {
    setState(() {
      amountController.clear();
      expenseNameController.clear();
      descriptionController.clear();
      selectedCategory = '';
      isRecurring = false;
    });
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
              // Recurring Transaction Section
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recurring Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Switch(
                    value: isRecurring,
                    onChanged: (value) {
                      setState(() {
                        isRecurring = value;
                      });
                    },
                    activeColor: Color(0xFF6E23B4),
                  ),
                ],
              ),
              Text(
                'Select only if the recurring amount is the same',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
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
              // Save Transaction Button and + Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _saveTransaction(
                        shouldNavigateHome: true), // Navigate to home
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
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF6E23B4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _saveTransaction(
                          shouldNavigateHome: false), // Reload the same page
                      icon: Icon(Icons.add, size: 32, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
