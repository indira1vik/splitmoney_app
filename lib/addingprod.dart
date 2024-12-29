import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<AppState>(context).products;
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
                          '\$${product['price']}',
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: Icon(Icons.add),
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
