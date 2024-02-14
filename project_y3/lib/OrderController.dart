import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_y3/auth.dart';
import 'model/cartItem.dart'; // Ensure this path is correct
import 'dart:developer';

class OrderController extends GetxController {
  var currentOrderItems = <CartItem>[].obs; // Use RxList to make it observable
  var isLoading = true.obs; // To track loading state
  String userId = Auth().getCurrentUserID();
  @override
  void onInit() {
    super.onInit();
    fetchCurrentCartItems(); // Fetch order items when the controller is initialized
  }

  Future<void> fetchCurrentCartItems() async {
    isLoading(true); // Start loading
    try {
      var orderItemsSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(userId)
          .collection(
              'CurrentOrder') // Adjust based on your actual collection name
          .get();

      // Assuming fromDocument is correctly defined as a static method or factory constructor
      var items = orderItemsSnapshot.docs
          .map((doc) => CartItem.fromDocument(doc))
          .toList();
      log(items.toString());

      currentOrderItems
          .assignAll(items); // Update the observable list with CartItem objects
      log(currentOrderItems.toString());
    } catch (e) {
      print("Error fetching order items: $e");
      // Handle the error appropriately
    } finally {
      isLoading(false); // End loading
    }
  }

  // Function to fetch orders and categorize them
  Future<Map<String, dynamic>> fetchAndCategorizeOrders() async {
    Map<String, dynamic> categorizedOrders = {
      'currentOrders': [],
      'historicalOrders': [],
    };

    try {
      // Fetch orders from Firestore
      var ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(userId)
          .collection('OrdersHistory')
          .get();

      for (var orderDoc in ordersSnapshot.docs) {
        var orderData = orderDoc.data();
        DateTime now = DateTime.now();
        DateTime estimatedDeliveryTime =
            orderData['estimatedDeliveryTime'].toDate();

        // Categorize order based on estimatedDeliveryTime
        if (estimatedDeliveryTime.isAfter(now)) {
          // This is a current order
          categorizedOrders['currentOrders'].add(orderData);
        } else {
          // This is a historical order
          categorizedOrders['historicalOrders'].add(orderData);
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }

    return categorizedOrders;
  }

  Future<List<dynamic>> fetchCurrentOrders() async {
    List<dynamic> currentOrders = [];

    try {
      var ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(userId)
          .collection('OrdersHistory')
          .get();

      DateTime now = DateTime.now();

      for (var orderDoc in ordersSnapshot.docs) {
        var orderData = orderDoc.data();
        DateTime estimatedDeliveryTime =
            (orderData['estimatedDeliveryTime'] as Timestamp).toDate();

        if (estimatedDeliveryTime.isAfter(now)) {
          currentOrders.add(orderData);
        }
      }
    } catch (e) {
      print("Error fetching current orders: $e");
    }

    return currentOrders;
  }

  Future<List<dynamic>> fetchHistoricalOrders() async {
    List<dynamic> historicalOrders = [];

    try {
      var ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(userId)
          .collection('OrdersHistory')
          .get();

      DateTime now = DateTime.now();

      for (var orderDoc in ordersSnapshot.docs) {
        var orderData = orderDoc.data();
        DateTime estimatedDeliveryTime =
            (orderData['estimatedDeliveryTime'] as Timestamp).toDate();

        if (estimatedDeliveryTime.isBefore(now)) {
          historicalOrders.add(orderData);
        }
      }
    } catch (e) {
      print("Error fetching historical orders: $e");
    }

    return historicalOrders;
  }
}
