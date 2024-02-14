import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_y3/OrderController.dart';
import 'package:project_y3/auth.dart';
import 'package:project_y3/model/inventory.dart';
import 'ReceiptPage.dart';
import 'package:intl/intl.dart';

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrder> {
  final OrderController _orderController = OrderController();

  Widget _currentOrder(
      dynamic order, int numberOfItems, double totalCost, List<dynamic> items) {
    DateTime orderDateTime = order['estimatedDeliveryTime'].toDate();
    String date =
        "${orderDateTime.day}/${orderDateTime.month}/${orderDateTime.year}";

    // Updated time formatting to include AM/PM as in the OrderHistory example
    String time = DateFormat('h:mm a').format(orderDateTime);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReceiptPage(
              order: order,
              items: items, // This should now be correctly recognized
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Order: ${order['orderId']}"),
                  Text("$date at $time"),
                ],
              ),
              Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage("images/tracking.png"),
                    color: Colors.black,
                    size: 60,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("$numberOfItems Items"),
                      SizedBox(height: 7),
                      Text("\$${totalCost.toStringAsFixed(2)}"),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _fetchOrdersAndItems() async {
    List<dynamic> ordersWithItems = [];
    // Get the current time
    DateTime now = DateTime.now();

    var ordersSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(Auth().getCurrentUserID()) // Adjust with actual user ID
        .collection('OrdersHistory')
        // Add condition to only fetch orders where estimatedDeliveryTime is greater than the current time
        .where('estimatedDeliveryTime', isGreaterThan: now)
        .get();

    for (var orderDoc in ordersSnapshot.docs) {
      var orderData = orderDoc.data();
      List<dynamic> itemsList = [];
      double totalCost = 0;
      int itemCount = 0;

      var itemsSnapshot = await orderDoc.reference.collection('Items').get();
      itemCount = itemsSnapshot.docs.length;
      for (var itemDoc in itemsSnapshot.docs) {
        var itemData = itemDoc.data();
        totalCost += itemData['price'] * itemData['quantity'];

        // Fetch inventory details based on InventoryId
        var inventoryDoc = await FirebaseFirestore.instance
            .collection('Inventory')
            .doc(itemData['InventoryId'])
            .get();

        if (inventoryDoc.exists) {
          var inventoryData =
              Inventory.fromFirestore(inventoryDoc.data(), inventoryDoc.id);
          itemData['imageUrl'] = inventoryData.imageUrl;
          itemData['title'] = inventoryData.title;
        } else {
          itemData['imageUrl'] = ''; // Default or placeholder image URL
        }

        itemsList.add(itemData);
      }

      ordersWithItems.add({
        'orderData': orderData,
        'items': itemsList,
        'itemCount': itemCount,
        'totalCost': totalCost,
      });
    }

    return ordersWithItems;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: FutureBuilder<List<dynamic>>(
        future: _fetchOrdersAndItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var orderInfo = snapshot.data[index];
                return Column(
                  children: [
                    _currentOrder(
                      orderInfo['orderData'],
                      orderInfo['itemCount'],
                      orderInfo['totalCost'],
                      orderInfo['items'],
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text('No current orders found'));
          }
        },
      ),
    );
  }
}
