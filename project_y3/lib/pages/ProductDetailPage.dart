import 'package:flutter/material.dart';
import 'package:project_y3/CartController.dart';
import 'package:project_y3/model/inventory.dart';
import 'package:get/get.dart';
import 'package:project_y3/pages/CartPage.dart';
import 'package:project_y3/auth.dart';
import 'package:project_y3/CartBinding.dart';
import 'package:badges/badges.dart';

class ProductDetailPage extends StatefulWidget {
  final Inventory inventory;

  ProductDetailPage({@required this.inventory});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}
class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _addToCart(BuildContext context, Inventory inventory, int quantity) {
    final CartController cartController = Get.find<CartController>();
    final Auth authService = Auth();
    String userId = authService.getCurrentUserID();
    double price = inventory.price;

    cartController
        .addItemToCart(userId, inventory.id, quantity, price)
        .then((_) {
      cartController.fetchAndResolveCartItems();
    }).catchError((error) {
      print("Error adding item to cart: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.inventory.title),
          backgroundColor: Colors.brown,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 15),
                child: Obx(() => Badge(
                    position: BadgePosition.topEnd(top: 2, end: -5),
                    badgeContent: Text(
                      '${cartController.cartItems.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () {
                          Get.to(() => CartPage());
                        }))))
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.inventory.imageUrl),
            SizedBox(height: 8),
            // Updated section starts here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.inventory.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${widget.inventory.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Updated section ends here
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.inventory.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                ),
                Text('Quantity: $_quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addToCart(context, widget.inventory, _quantity),
              child: Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
