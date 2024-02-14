import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    _initSquarePayment();
  }

  Future<void> _initSquarePayment() async {
  }

  void _startCardEntryFlow() {
    InAppPayments.setSquareApplicationId('sandbox-sq0idb-VlGlo_46a9xVFpjsaJ7qZw');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,
    );
  }

  void _cardNonceRequestSuccess(CardDetails result) {
    // This is where you would use the nonce (result.cardNonce) to process the payment
    print('Card nonce: ${result.nonce}');
    // For this example, we're just completing the card entry and showing a toast message
    InAppPayments.completeCardEntry(
      onCardEntryComplete: () => _cardEntryComplete(result.nonce),
    );
    // do cartcontroller shit here
  }

  void _cardEntryComplete(String nonce) {
    // Here, you would typically send the nonce to your server to process the payment
    Fluttertoast.showToast(
      msg: "Payment successful! Nonce: $nonce",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _cardEntryCancel() {
    // User cancelled the card entry
    Fluttertoast.showToast(
      msg: "Card entry cancelled",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startCardEntryFlow,
          child: Text('Enter Card Details'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // background
            onPrimary: Colors.white, // foreground
          ),
        ),
      ),
    );
  }
}
