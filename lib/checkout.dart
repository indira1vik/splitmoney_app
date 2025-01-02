import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class CheckoutDetails extends StatefulWidget {
  @override
  _CheckoutDetails createState() => _CheckoutDetails();
}

extension StringExtension on String {
  String capitalize() {
    return this.isNotEmpty
        ? '${this[0].toUpperCase()}${this.substring(1)}'
        : this;
  }
}

class _CheckoutDetails extends State<CheckoutDetails> {
  @override
  Widget build(BuildContext context) {
    // Use listen: false for Provider access since we're not rebuilding
    final appState = Provider.of<AppState>(context, listen: false);
    final productList = appState.products;
    final chargesList = appState.charges;
    final roommateList = appState.roommates;
    bool checkBtn = Provider.of<AppState>(context).isButtonPressed;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Charges
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Charges",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...chargesList.entries.map((entry) {
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Charge Name (e.g., "Tax")
                            Text(
                              entry.key.capitalize(), // Capitalize first letter
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Charge Value (e.g., "0.69")
                            Text(
                              '\$${entry.value.toStringAsFixed(2)}', // Format value
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            // Display Products and Shares
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...productList.map((product) {
                    final selectedRoommates =
                        product['selectedRoommates'] ?? [];
                    final finalPrice =
                        product['finalPrice'] ?? product['price'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Unnamed Product',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text('Price: \$${finalPrice.toStringAsFixed(2)}'),
                              SizedBox(height: 8),
                              // Roommate Shares
                              Text(
                                "Shared With:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (selectedRoommates.isEmpty)
                                Text("No roommates selected."),
                              ...selectedRoommates.map((roommateName) {
                                final roommate = roommateList.firstWhere(
                                    (r) => r['name'] == roommateName,
                                    orElse: () => {
                                          'name': 'Unknown'
                                        }); // Safeguard for missing roommate

                                final share =
                                    finalPrice / selectedRoommates.length;

                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(roommate['name']),
                                      Text('\$${share.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (!checkBtn) {
                        // Call the split logic only once
                        appState.calculateWeightedPrices(
                            productList, chargesList);
                        appState.splitProductPrices(productList, roommateList);

                        // Update the state to disable the button
                        setState(() {
                          appState.changeBtn(true);
                        });

                        // Show SnackBar after splitting
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Prices have been split among roommates!'),
                          ),
                        );
                      } else {
                        // If already pressed, show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('You already split the money!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 54),
                    ),
                    child: Text('Split Money'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
