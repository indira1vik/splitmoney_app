import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class Roommates extends StatefulWidget {
  @override
  _Roommates createState() => _Roommates();
}

class _Roommates extends State<Roommates> {
  final TextEditingController roommateNameController =
      TextEditingController(text: '');
  final TextEditingController roommateDebtController =
      TextEditingController(text: '');

  @override
  void dispose() {
    roommateNameController.dispose();
    roommateDebtController.dispose();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Center(child: Text("Add Roommate")),
              content: SingleChildScrollView(
                  child: Column(children: [
                TextField(
                  controller: roommateNameController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Enter Roommate Name',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: roommateDebtController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Enter Debt Amount',
                    prefixText: '\$ ',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String name = roommateNameController.text.trim();
                    String debtText = roommateDebtController.text.trim();

                    if (name.isNotEmpty && debtText.isNotEmpty) {
                      final debt = double.tryParse(debtText);
                      if (debt != null) {
                        Provider.of<AppState>(context, listen: false)
                            .addRoommate(name, debt);
                        roommateNameController.clear();
                        roommateDebtController.clear();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Invalid debt amount. Please enter a valid number.")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill in all fields.")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 54)),
                  child: Text('Add'),
                ),
              ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    final roommates = Provider.of<AppState>(context).roommates;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            ...roommates.map((product) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['name'] ?? 'Unnamed Product',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${product['debt']}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
