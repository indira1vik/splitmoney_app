import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController prodNameController =
      TextEditingController(text: '');
  final TextEditingController prodPriceController =
      TextEditingController(text: '');

  @override
  void dispose() {
    prodNameController.dispose();
    prodPriceController.dispose();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Center(child: Text("Add Product")),
              content: SingleChildScrollView(
                  child: Column(children: [
                TextField(
                  controller: prodNameController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Enter Product Name',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: prodPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    labelText: 'Enter Product Price',
                    prefixText: '\$ ',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String nameText = prodNameController.text.trim();
                    String priceText = prodPriceController.text.trim();
                    if (nameText.isNotEmpty && priceText.isNotEmpty) {
                      final priceVal = double.tryParse(priceText);
                      if (priceVal != null) {
                        Provider.of<AppState>(context, listen: false)
                            .addProduct(nameText, priceVal);
                        prodNameController.clear();
                        prodPriceController.clear();
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


  void _showEditDialog(BuildContext context, Map<String, dynamic> product) {
    // Pre-fill text controllers with current values
    TextEditingController editNameController =
        TextEditingController(text: product['name']);
    TextEditingController editDebtController =
        TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Edit Product")),
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
                    labelText: 'Edit Product Name',
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
                    labelText: 'Edit Price',
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
                            .editProduct(product, updatedName, updatedDebt);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Invalid price. Please enter a valid number.")));
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


  @override
  Widget build(BuildContext context) {
    final products = Provider.of<AppState>(context).products;
    final roommates = Provider.of<AppState>(context).roommates;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            ...products.map((product) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                              product['name'] ?? 'Unnamed Product',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${product['price']}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showEditDialog(context, product);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            // All Checkbox
                            if (roommates.isNotEmpty && roommates.length > 1)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value:
                                        product['selectedRoommates']?.length ==
                                            roommates.length,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          product['selectedRoommates'] =
                                              roommates
                                                  .map((e) => e['name'])
                                                  .toList();
                                        } else {
                                          product['selectedRoommates'] = [];
                                        }
                                      });
                                    },
                                  ),
                                  Text("All"),
                                ],
                              ),

                            ...roommates.map((roommate) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: product['selectedRoommates']
                                            ?.contains(roommate['name']) ??
                                        false,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          product['selectedRoommates'] ??= [];
                                          product['selectedRoommates']
                                              .add(roommate['name']);
                                        } else {
                                          product['selectedRoommates']
                                              ?.remove(roommate['name']);
                                        }
                                      });
                                    },
                                  ),
                                  Text(roommate['name']),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      )
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
