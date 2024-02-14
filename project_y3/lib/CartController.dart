import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_y3/auth.dart';
import 'package:project_y3/model/inventory.dart';
import 'package:project_y3/model/cartItem.dart';
import 'dart:async';
import 'dart:developer';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  final Auth authService = Auth();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndResolveCartItems();
  }

  void clearCart() {
    cartItems.clear();
  }

  void fetchAndResolveCartItems() async {
    isLoading(true);
    String userId = authService.getCurrentUserID();
    try {
      var fetchedCartItems = await fetchCartItems(userId);
      var resolvedCartItems = await resolveInventoryDetails(fetchedCartItems);
      cartItems.assignAll(resolvedCartItems);
    } catch (e) {
      log("Error in fetchAndResolveCartItems: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<List<CartItem>> fetchCartItems(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Cart')
        .doc(userId)
        .collection('CartItems')
        .get();
    return snapshot.docs.map((doc) {
      return CartItem(
        id: doc.id,
        inventoryId: doc['InventoryId'],
        quantity: doc['quantity'],
        price: doc['price'],
      );
    }).toList();
  }

  Future<List<CartItem>> resolveInventoryDetails(List<CartItem> items) async {
    for (var item in items) {
      var inventoryDetails = await fetchInventoryById(item.inventoryId);
      item.inventory = inventoryDetails;
    }
    return items;
  }

  void addItem(String inventoryId, double price) {
    var existingIndex = cartItems.indexWhere((item) => item.id == inventoryId);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(CartItem(id: inventoryId, price: price, quantity: 1));
    }
  }

  Future<void> addItemToCart(String userId, String inventoryId, int quantity,
      double pricePerItem) async {
    CollectionReference userCartCollection = FirebaseFirestore.instance
        .collection('Cart')
        .doc(userId)
        .collection('CartItems');
    // Check if the item already exists in the cart
    var existingCartItemQuery = await userCartCollection
        .where('InventoryId', isEqualTo: inventoryId)
        .limit(1)
        .get();
    if (existingCartItemQuery.docs.isNotEmpty) {
      // Item exists, update its quantity and total price
      var existingCartItemDoc = existingCartItemQuery.docs.first;
      int newQuantity = existingCartItemDoc['quantity'] + quantity;
      double newTotalPrice =
          newQuantity * pricePerItem; // Calculate the new total price
      userCartCollection.doc(existingCartItemDoc.id).update({
        'quantity': newQuantity,
        'price': newTotalPrice, // Update the document with the new total price
      });
    } else {
      // Item does not exist, add a new document with the total price
      double initialTotalPrice =
          quantity * pricePerItem; // Calculate the total price for the new item
      var cartItem = {
        'InventoryId': inventoryId,
        'quantity': quantity,
        'price': initialTotalPrice, // Use the total price for the new item
      };
      await userCartCollection.add(cartItem);
    }
  }

  Future<void> addProductToCartAndRefresh(String userId, String inventoryId,
      int quantity, double pricePerItem) async {
    await addItemToCart(userId, inventoryId, quantity, pricePerItem);
    fetchAndResolveCartItems();
  }

  Future<Inventory> fetchInventoryById(String inventoryId) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('Inventory')
        .doc(inventoryId)
        .get();
    var data = docSnapshot.data();
    if (data != null) {
      return Inventory.fromFirestore(data, docSnapshot.id);
    } else {
      throw Exception('Inventory data is null for ID: $inventoryId');
    }
  }

  Future<void> incrementQuantity(String inventoryId) async {
    try {
      String userId = authService.getCurrentUserID();
      var userCartCollection = FirebaseFirestore.instance
          .collection('Cart')
          .doc(userId)
          .collection('CartItems');
      var querySnapshot = await userCartCollection
          .where('InventoryId', isEqualTo: inventoryId)
          .get();
      fetchAndResolveCartItems();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        int currentQuantity = doc['quantity'];
        await doc.reference.update({'quantity': currentQuantity + 1});
        print("Incremented quantity for InventoryId: $inventoryId");
      }
    } catch (e) {
      print("Error incrementing quantity for InventoryId: $e");
    }
  }

  Future<void> decrementQuantity(String inventoryId) async {
    try {
      String userId = authService.getCurrentUserID();
      var userCartCollection = FirebaseFirestore.instance
          .collection('Cart')
          .doc(userId)
          .collection('CartItems');
      var querySnapshot = await userCartCollection
          .where('InventoryId', isEqualTo: inventoryId)
          .get();
      fetchAndResolveCartItems();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        int currentQuantity = doc['quantity'];
        if (currentQuantity > 1) {
          await doc.reference.update({'quantity': currentQuantity - 1});
          print("Decremented quantity for InventoryId: $inventoryId");
        } else {
          print(
              "Cannot decrement quantity below 1 for InventoryId: $inventoryId");
        }
      }
    } catch (e) {
      print("Error decrementing quantity for InventoryId: $e");
    }
  }

  Future<void> removeItem(String inventoryId) async {
    try {
      String userId = authService.getCurrentUserID();
      var userCartCollection = FirebaseFirestore.instance
          .collection('Cart')
          .doc(userId)
          .collection('CartItems');
      var querySnapshot = await userCartCollection
          .where('InventoryId', isEqualTo: inventoryId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted cart item with InventoryId: $inventoryId");
      }

      cartItems.removeWhere((item) => item.inventoryId == inventoryId);
    } catch (e) {
      print("Error removing item by InventoryId: $e");
    }
  }

  double getTotalCost() {
    double total = 0;
    for (var item in cartItems) {
      total += item.inventory.price * item.quantity;
    }
    return total;
  }
}
