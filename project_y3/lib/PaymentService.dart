import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'BottomNavBar.dart';
import 'dart:developer';
import 'CartController.dart';
import 'package:get/get.dart';

class PaymentService {
  final String userId;

  PaymentService({@required this.userId});

  void startCardEntryFlow(
      {BuildContext context, Function(String) onSuccess, Function onCancel}) {
    InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-VlGlo_46a9xVFpjsaJ7qZw');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: (CardDetails result) {
        print('Card nonce: ${result.nonce}');
        InAppPayments.completeCardEntry(
          onCardEntryComplete: () async {
            await onPaymentSuccess(result.nonce, context);
            if (onSuccess != null) onSuccess(result.nonce);
          },
        );
      },
      onCardEntryCancel: () {
        if (onCancel != null) onCancel();
        Fluttertoast.showToast(
          msg: "Card entry cancelled",
          toastLength: Toast.LENGTH_SHORT,
        );
      },
    );
  }

  Future<void> onPaymentSuccess(String nonce, BuildContext context) async {
    try {
      // Generate a unique order ID
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Calculate estimated delivery time as 3 hours from now
      DateTime estimatedDeliveryTime = DateTime.now().add(Duration(hours: 3));

      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .doc(userId)
          .collection('CartItems')
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Prepare order metadata, including estimated delivery time
      Map<String, dynamic> orderMetadata = {
        'orderId': orderId,
        'estimatedDeliveryTime': estimatedDeliveryTime, // Firestore Timestamp
        'orderTime': DateTime.now(), // Firestore Timestamp
        // You can add more order related information here
      };

      // Create a document for the order metadata
      DocumentReference orderMetadataRef = FirebaseFirestore.instance
          .collection('Orders')
          .doc(userId)
          .collection('OrdersHistory')
          .doc(orderId);
      batch.set(orderMetadataRef, orderMetadata);

      for (var doc in cartSnapshot.docs) {
        DocumentReference orderItemRef = FirebaseFirestore.instance
            .collection('Orders')
            .doc(userId)
            .collection('OrdersHistory') // Changed to 'OrdersHistory'
            .doc(orderId) // Use the unique order ID
            .collection('Items') // Add a collection for items under the order
            .doc(); // Generate a new document ID for each item
        batch.set(orderItemRef, doc.data());
        batch.delete(doc.reference);
      }

      await batch.commit();
      final CartController cartController = Get.find<CartController>();
      cartController.clearCart();

      Fluttertoast.showToast(
        msg: "Payment successful, cart items moved to orders",
        toastLength: Toast.LENGTH_LONG,
      );

      // Navigate back to the BottomNavBar page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                BottomNavBar(loggedUser: true)), // Navigate to BottomNavBar
        ModalRoute.withName('/'), // Reset the stack to the root
      );
    } catch (e) {
      print("Error processing payment and updating cart/orders: $e");
      // Add more sophisticated error handling here
    }
  }
}
