import 'package:flutter/material.dart';
import 'roommates.dart';
import 'charges.dart';
import 'addingprod.dart';
import 'package:provider/provider.dart';

class AppState extends ChangeNotifier {
  final List<Map<String, dynamic>> roommates = [
    {'name': 'Indira', 'debt': 0},
    {'name': 'Srinath', 'debt': 0},
    {'name': 'Viswa', 'debt': 0},
    {'name': 'Kavin', 'debt': 0},
    {'name': 'Nijanth', 'debt': 0},
  ];
  final List<Map<String, dynamic>> products = [];

  final List<Map<String, dynamic>> charges = [];

  void addCharges(double tax, double offer, double tip, double delivery) {
    charges.add({
      'tax': tax,
      'offer': offer,
      'tip': tip,
      'delivery': delivery,
    });
    notifyListeners();
  }

  void addRoommate(String name, double debt) {
    roommates.add({'name': name, 'debt': debt});
    notifyListeners();
  }

  void addProduct(String name, double price) {
    products.add({'name': name, 'price': price});
    notifyListeners();
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
    _tabController = TabController(length: 3, vsync: this);
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
            Tab(text: 'Results'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AddProduct(),
          ChargesForm(),
          Roommates(),
        ],
      ),
    );
  }
}
