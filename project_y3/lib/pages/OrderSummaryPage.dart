import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_y3/CartController.dart'; // Ensure this matches your project structure
import 'package:intl/intl.dart';
import 'package:project_y3/PaymentService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_y3/auth.dart';

class OrderSummaryPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  String _getEstimatedDeliveryDateTime() {
    DateTime now = DateTime.now();
    DateTime estimatedDeliveryDateTime = now.add(
        Duration(hours: 3)); 
    return DateFormat('yyyy-MM-dd h:mm a').format(
        estimatedDeliveryDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Summary'),
          backgroundColor: Colors.brown,
        ),
        body: Obx(() {
          if (cartController.isLoading.isTrue) {
            return Center(child: CircularProgressIndicator());
          }
          if (cartController.cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return ListTile(
                      leading: Image.network(item.inventory.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item.inventory.title),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: \$${cartController.getTotalCost().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Estimated Delivery Date: ${_getEstimatedDeliveryDateTime()}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 80), // Spacer or Padding at the bottom for FAB
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            PaymentService(userId: Auth().getCurrentUserID())
                .startCardEntryFlow(
              context: context,
              onSuccess: (nonce) {
                Fluttertoast.showToast(
                  msg: "Payment successful! Nonce: $nonce",
                  toastLength: Toast.LENGTH_LONG,
                );
              },
              onCancel: () {},
            );
          },
          label: Text('Proceed to Payment'),
          icon: Icon(Icons.payment),
          backgroundColor: Colors.brown,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
