import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_y3/CartController.dart'; // Ensure this import path is correct
import 'package:project_y3/OrderController.dart'; // Ensure this import path is correct
import 'package:project_y3/model/cartItem.dart';
import 'OrderSummaryPage.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(() {
        if (cartController.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('Your cart is empty'));
        }
        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            var cartItem = cartController.cartItems[index];
            return _buildCartItem(context, cartItem);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: cartController.cartItems.isNotEmpty
            ? () {
                Get.put(OrderController()).fetchCurrentCartItems();
                Get.to(OrderSummaryPage());
              }
            : null, 
        label: Obx(() => Text(
            'Checkout (\$${cartController.getTotalCost().toStringAsFixed(2)})')),
        icon: Icon(Icons.payment),
        backgroundColor: cartController.cartItems.isNotEmpty
            ? Colors.brown
            : Colors.grey, 
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return ListTile(
      leading: Image.network(cartItem.inventory.imageUrl,
          width: 100, height: 100, fit: BoxFit.fitHeight),
      title: Text(cartItem.inventory.title),
      subtitle: Text('Quantity: ${cartItem.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () =>
                cartController.decrementQuantity(cartItem.inventoryId),
          ),
          Text(
              '\$${(cartItem.inventory.price * cartItem.quantity).toStringAsFixed(2)}'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                cartController.incrementQuantity(cartItem.inventoryId),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => cartController.removeItem(cartItem.inventoryId),
          ),
        ],
      ),
      isThreeLine: true,
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      onTap: () {},
    );
  }
}
