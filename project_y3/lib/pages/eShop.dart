import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_y3/model/inventory.dart';
import '../CartController.dart';
import 'package:project_y3/auth.dart';
import 'ProductDetailPage.dart';
import 'package:get/get.dart';

class EShopPage extends StatefulWidget {
  final bool loggedUser;
  EShopPage({@required this.loggedUser});
  @override
  _EShopPageState createState() => _EShopPageState();
}

class _EShopPageState extends State<EShopPage> {
  TextEditingController searchController = TextEditingController();

  Future<void> addInventory(Inventory inventory) async {
    CollectionReference inventoryCollection =
        FirebaseFirestore.instance.collection('Inventory');
    return inventoryCollection
        .add({
          'title': inventory.title,
          'description': inventory.description,
          'price': inventory.price,
          'imageUrl': inventory.imageUrl
        })
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  Stream<List<Inventory>> getInventory() {
    return FirebaseFirestore.instance
        .collection('Inventory')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Inventory(
              id: doc.id,
              title: doc['title'],
              description: doc['description'],
              price: doc['price'],
              imageUrl: doc['imageUrl']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Inventory>>(
        stream: getInventory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: Text("No products found"));
          }

          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, i) => ListTile(
              leading:
                  Image.network(products[i].imageUrl, width: 100, height: 100),
              title: Text(products[i].title),
              subtitle: Text('\$${products[i].price.toStringAsFixed(2)}'),
              trailing: widget.loggedUser
                  ? IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        final cartController = Get.find<CartController>();
                        cartController.addProductToCartAndRefresh(Auth().getCurrentUserID(),
                            products[i].id, 1, products[i].price);
                      },
                    )
                  : null,
              onTap: () {
                Get.to(ProductDetailPage(inventory: products[i]));
              },
            ),
          );
        });
  }
}
