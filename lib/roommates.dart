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
                            .addRoommate(name);
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> roommate) {
    // Pre-fill text controllers with current values
    TextEditingController editNameController =
        TextEditingController(text: roommate['name']);
    TextEditingController editDebtController =
        TextEditingController(text: roommate['debt'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Edit Roommate")),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: editNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Edit Roommate Name',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: editDebtController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Edit Debt Amount',
                    prefixText: '\$ ',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String updatedName = editNameController.text.trim();
                    String updatedDebtText = editDebtController.text.trim();

                    if (updatedName.isNotEmpty && updatedDebtText.isNotEmpty) {
                      final updatedDebt = double.tryParse(updatedDebtText);
                      if (updatedDebt != null) {
                        // Update roommate details
                        Provider.of<AppState>(context, listen: false)
                            .editRoommate(roommate, updatedName, updatedDebt);
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
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteRoommate(BuildContext context,
      List<Map<String, dynamic>> roommates, Map<String, dynamic> roommate) {
    setState(() {
      roommates.remove(roommate);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${roommate['name']} has been removed.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roommates = Provider.of<AppState>(context).roommates;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            ...roommates.map((roommate) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              roommate['name'] ?? 'Unnamed Roommate',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${roommate['debt'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Edit Icon
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showEditDialog(context, roommate);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: Text('Edit'),
                                  ),
                                  SizedBox(width: 8), // Spacing between buttons
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteRoommate(
                                          context, roommates, roommate);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
