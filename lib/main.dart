import 'package:flutter/material.dart';
import 'roommates.dart';
import 'charges.dart';
import 'addingprod.dart';
import 'checkout.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  final List<Map<String, dynamic>> roommates = [];
  final List<Map<String, dynamic>> products = [];
  final Map<String, dynamic> charges = {};
  bool isButtonPressed = false;

  // Add Charges (Clear and reset charges)
  void addCharges(double tax, double offer, double tip, double delivery) {
    charges.clear();
    charges['tax'] = tax;
    charges['offer'] = offer;
    charges['tip'] = tip;
    charges['delivery'] = delivery;
    notifyListeners();
  }

  void changeBtn(bool change) {
    isButtonPressed = change;
  }

  // Add Roommate (initialize debt to 0 if not provided)
  void addRoommate(String name, {double debt = 0.0}) {
    roommates.add({'name': name, 'debt': debt});
    notifyListeners();
  }

  // Add Product (initialize finalPrice and selectedRoommates)
  void addProduct(String name, double price) {
    products.add({
      'name': name,
      'price': price,
      'selectedRoommates': <String>[],
      'finalPrice': price, // Initialize finalPrice to price
    });
    notifyListeners();
  }

  // Edit Roommate (update name and debt)
  void editRoommate(
      Map<String, dynamic> roommate, String updatedName, double updatedDebt) {
    final index = roommates.indexOf(roommate);
    if (index != -1) {
      roommates[index]['name'] = updatedName;
      roommates[index]['debt'] = updatedDebt;
      notifyListeners();
    }
  }

  // Edit Product (update name, price, and recalculate finalPrice)
  void editProduct(
      Map<String, dynamic> product, String updatedName, double updatedPrice) {
    final index = products.indexOf(product);
    if (index != -1) {
      products[index]['name'] = updatedName;
      products[index]['price'] = updatedPrice;

      // Recalculate final price based on updated price
      double finalPrice = updatedPrice;
      products[index]['finalPrice'] = finalPrice;

      notifyListeners();
    }
  }

  // Calculate Weighted Prices based on charges (tax, offer, delivery, tip)
  void calculateWeightedPrices(
      List<Map<String, dynamic>> products, Map<String, dynamic> charges) {
    double totalSum =
        products.fold(0, (sum, product) => sum + product['price']);

    for (var product in products) {
      double weightage = product['price'] / totalSum;
      double deliveryShare = weightage * (charges['delivery'] ?? 0);
      double taxShare = weightage * (charges['tax'] ?? 0);
      double tipShare = weightage * (charges['tip'] ?? 0);
      double offerShare = weightage * (charges['offer'] ?? 0);

      product['finalPrice'] =
          product['price'] - offerShare + deliveryShare + taxShare + tipShare;
    }
  }

  // Split Product Prices among roommates
  void splitProductPrices(List<Map<String, dynamic>> products,
      List<Map<String, dynamic>> roommates) {
    for (var product in products) {
      List<String> selectedRoommates =
          List<String>.from(product['selectedRoommates'] ?? []);

      int splitAmong = selectedRoommates.length;

      if (splitAmong > 0) {
        double share = product['finalPrice'] / splitAmong;

        for (var roommate in roommates) {
          if (selectedRoommates.contains(roommate['name'])) {
            roommate['debt'] += share;
          }
        }
      }
    }
  }

  // Utility function to get a roommate by name (for use in splitting)
  Map<String, dynamic> getRoommateByName(String name) {
    return roommates.firstWhere(
      (roommate) => roommate['name'] == name,
      orElse: () => {'name': 'Unknown', 'debt': 0.0}, // Default if not found
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          title: 'SplitMoney App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SplitMoney',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Products'),
            Tab(text: 'Charges'),
            Tab(text: 'Checkout'),
            Tab(text: 'Roommates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AddProduct(),
          ChargesForm(),
          CheckoutDetails(),
          Roommates(),
        ],
      ),
    );
  }
}
