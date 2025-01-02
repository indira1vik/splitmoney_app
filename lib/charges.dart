import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ChargesForm extends StatefulWidget {
  @override
  _ChargesFormState createState() => _ChargesFormState();
}

class _ChargesFormState extends State<ChargesForm> {
  final TextEditingController taxAmountController =
      TextEditingController(text: '');
  final TextEditingController offerAmountController =
      TextEditingController(text: '');
  final TextEditingController tipAmountController =
      TextEditingController(text: '');
  final TextEditingController deliveryChargesController =
      TextEditingController(text: '');

  @override
  void dispose() {
    taxAmountController.dispose();
    offerAmountController.dispose();
    tipAmountController.dispose();
    deliveryChargesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.5,
          child: TextField(
            controller: taxAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              labelText: 'Enter Final Tax Amount',
              prefixText: '\$ ',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: TextField(
            controller: offerAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              labelText: 'Enter Offer Amount',
              prefixText: '\$ ',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: TextField(
            controller: tipAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              labelText: 'Enter Tip Amount',
              prefixText: '\$ ',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: TextField(
            controller: deliveryChargesController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              labelText: 'Enter Delivery Charges',
              prefixText: '\$ ',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: ElevatedButton(
            onPressed: () {
              final taxAmount =
                  double.tryParse(taxAmountController.text.trim()) ?? 0.0;
              final offerAmount =
                  double.tryParse(offerAmountController.text.trim()) ?? 0.0;
              final tipAmount =
                  double.tryParse(tipAmountController.text.trim()) ?? 0.0;
              final deliveryCharges =
                  double.tryParse(deliveryChargesController.text.trim()) ?? 0.0;

              Provider.of<AppState>(context, listen: false).addCharges(
                  taxAmount, offerAmount, tipAmount, deliveryCharges);
              taxAmountController.clear();
              offerAmountController.clear();
              tipAmountController.clear();
              deliveryChargesController.clear();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 54),
            ),
            child: Text('Save'),
          ),
        ),
      ],
    );
  }
}
