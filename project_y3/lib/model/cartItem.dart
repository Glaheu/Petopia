import 'package:project_y3/model/inventory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String id; // Firestore document id
  String inventoryId; // Primary identifier for the cart item
  Inventory inventory; // Detailed inventory data
  int quantity;
  double price;

  CartItem(
      {this.id, this.inventoryId, this.inventory, this.quantity, this.price});

  factory CartItem.fromFirestore(
      Map<String, dynamic> firestoreData, String docId) {
    return CartItem(
      inventoryId: firestoreData['InventoryId'],
      quantity: firestoreData['quantity'],
      price: firestoreData['price'],
    );
  }
  factory CartItem.fromDocument(QueryDocumentSnapshot doc) {
    return CartItem(
      inventoryId: doc['InventoryId'],
      price: doc['price'].toDouble(),
      quantity: doc['quantity'],
    );
  }
}
