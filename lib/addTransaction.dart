

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spendez_main/home.dart';

class AddTransactionScreen extends StatefulWidget {
  final int userId;

  const AddTransactionScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final String apiUrl = "http://10.0.2.2:5000/transactions";
  String selectedCategory = 'Food'; // Default category
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isRecurring = false;

  Future<void> _saveTransaction({bool shouldNavigateHome = false}) async {
    final String amountText = amountController.text.trim();
    final String name = expenseNameController.text.trim();
    final String category = selectedCategory.trim();
    final String description = descriptionController.text.trim();

    if (amountText.isEmpty || name.isEmpty || category.isEmpty) {
      _showCustomSnackBar('Please fill in all required fields');
      return;
    }

    // Ensure amount is correctly parsed (Backend may expect int or double)
    final double? parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null || parsedAmount <= 0) {
      _showCustomSnackBar('Invalid amount entered');
      return;
    }

    final Map<String, dynamic> transactionData = {
      'user_id': widget.userId, // Ensure userId is correct
      'amount': parsedAmount, // Correctly parsed amount
      'expense_name': name,
      'category': category,
      'description': description,
      'is_recurring': isRecurring,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        _showSuccessDialog(shouldNavigateHome);
      } else {
        print('❌ Error: ${response.statusCode}, user_id : ');
        print('❌ Response Body: ${response.body}');
        _showCustomSnackBar('Failed to save transaction: ${response.body}');
      }
    } catch (e) {
      print('❌ Network or Parsing Error: $e');
      _showCustomSnackBar('An error occurred: $e');
    }
  }

  void _showSuccessDialog(bool shouldNavigateHome) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          if (shouldNavigateHome) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScr(userId: widget.userId),
              ),
            );
          } else {
            _resetForm();
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

  void _resetForm() {
    setState(() {
      amountController.clear();
      expenseNameController.clear();
      descriptionController.clear();
      selectedCategory = 'Food'; // Reset to default category
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountInput(),
            SizedBox(height: 16),
            _buildExpenseNameInput(),
            SizedBox(height: 24),
            _buildCategorySelection(),
            SizedBox(height: 24),
            _buildRecurringSwitch(),
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
            _buildDescriptionInput(),
            SizedBox(height: 24),
            _buildSaveButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recurring Transaction",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Added bold style
              ),
            ),
            SizedBox(
                height: 4), // Adds spacing between the text and description
            Text(
              "Select only if the amount will be same",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600], // Slightly faded description text
              ),
            ),
          ],
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
    );
  }

  Widget _buildDescriptionInput() {
    return TextField(
      controller: descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText:
            '💡Tip: Click to write a short note in case you want to look back in the future...',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Save & Add Another Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6E23B4), // Purple
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () => _saveTransaction(shouldNavigateHome: false),
          child: Text(
            "Save & Add Another",
            style: TextStyle(color: Colors.white), // White text color
          ),
        ),

        // Save & Home Button with + Icon
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF6E23B4), // Changed to Blue
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Save & Home Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => _saveTransaction(shouldNavigateHome: true),
                child: Text(
                  "Save & Home",
                  style: TextStyle(color: Colors.white), // White text color
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Center(
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
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseNameInput() {
    return TextField(
      controller: expenseNameController,
      decoration: InputDecoration(
        hintText: 'Enter your Expense Name',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ],
    );
  }

  Widget _buildCategoryIcon(String category, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
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
              icon,
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
