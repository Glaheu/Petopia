import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_y3/auth.dart';
import 'package:project_y3/model/inventory.dart';
import 'package:project_y3/pages/ReceiptPage.dart';

import 'ReceiptPage.dart'; // Make sure the path matches your project structure

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Future<List<dynamic>> _fetchPastOrders() async {
    List<dynamic> pastOrdersWithItems = [];
    var now = Timestamp.now();

    var ordersSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(Auth().getCurrentUserID()) // Adjust with actual user ID
        .collection('OrdersHistory')
        .where('estimatedDeliveryTime', isLessThan: now)
        .get();

    for (var orderDoc in ordersSnapshot.docs) {
      var orderData = orderDoc.data();
      List<dynamic> itemsList = [];
      double totalCost = 0;
      int itemCount = 0;

      var itemsSnapshot = await orderDoc.reference.collection('Items').get();
      itemCount = itemsSnapshot.docs.length;

      for (var itemDoc in itemsSnapshot.docs) {
        var itemData = itemDoc.data() as Map<String, dynamic>;
        totalCost += itemData['price'] * itemData['quantity'];

        var inventoryDoc = await FirebaseFirestore.instance
            .collection('Inventory')
            .doc(itemData['InventoryId'])
            .get();

        if (inventoryDoc.exists) {
          var inventoryData = Inventory.fromFirestore(
              inventoryDoc.data() as Map<String, dynamic>, inventoryDoc.id);
          itemData['imageUrl'] = inventoryData.imageUrl;
          itemData['title'] = inventoryData.title;
        } else {
          itemData['imageUrl'] = ''; // Default or placeholder image URL
        }

        itemsList.add(itemData);
      }

      pastOrdersWithItems.add({
        'orderData': orderData,
        'items': itemsList,
        'itemCount': itemCount,
        'totalCost': totalCost,
      });
    }
    return pastOrdersWithItems;
  }

  Widget _orderHistory(dynamic order, String date, String time,
      int numberOfItems, double cost, List<dynamic> items) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReceiptPage(
              order: order,
              items: items,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: 15), 
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
              SizedBox(height: 13),
              Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage(
                        "images/checkout.png"), 
                    color: Colors.black,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("$numberOfItems Items"),
                      SizedBox(height: 7),
                      Text("\$${cost.toStringAsFixed(2)}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: FutureBuilder<List<dynamic>>(
          future: _fetchPastOrders(),
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
                  DateTime orderDateTime = (orderInfo['orderData']
                          ['estimatedDeliveryTime'] as Timestamp)
                      .toDate();
                  String date =
                      "${orderDateTime.day}/${orderDateTime.month}/${orderDateTime.year}";
                  String time =
                      "${orderDateTime.hour}:${orderDateTime.minute.toString().padLeft(2, '0')}";

                  return _orderHistory(
                    orderInfo['orderData'],
                    date,
                    time,
                    orderInfo['itemCount'],
                    orderInfo['totalCost'],
                    orderInfo['items'],
                  );
                },
              );
            } else {
              return Center(child: Text('No past orders found'));
            }
          },
        ),
      ),
    );
  }
}
