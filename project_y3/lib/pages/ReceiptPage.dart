import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatelessWidget {
  final dynamic order; // Assuming 'order' contains all necessary order details
  final List<dynamic> items; // List of items in the order

  ReceiptPage({Key key, this.order, this.items}) : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = items.fold(
        0,
        (previousValue, item) =>
            previousValue + (item['price'] * item['quantity']));
    DateTime orderDateTime = order['estimatedDeliveryTime'].toDate();
    String formattedOrderDateTime = _formatDateTime(orderDateTime);

    return Scaffold(
        appBar: AppBar(
          title: Text('Receipt'),
          backgroundColor: Colors.brown,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Image.network(item['imageUrl'],
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item['title']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text(
                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total: \$${totalCost.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Order Date: $formattedOrderDateTime',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 15)
          ],
        ));
  }
}
