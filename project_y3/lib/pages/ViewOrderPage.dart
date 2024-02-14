import 'package:flutter/material.dart';
import 'CurrentOrderPage.dart';
import 'OrderHistoryPage.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ViewOrdersPage();
}

class ViewOrdersPage extends State<ViewOrders> {
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.brown,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "Orders",
        style: TextStyle(
            fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      bottom: TabBar(
        tabs: [
          Tab(
            icon: ImageIcon(
              AssetImage("images/tracking.png"),
              color: Colors.white,
              size: 40,
            ),
            text: "Current Orders",
          ),
          Tab(
            icon: ImageIcon(
              AssetImage("images/checkout.png"),
              color: Colors.white,
              size: 40,
            ),
            text: "Past Orders",
          ),
        ],
      ), //TabBar
    ); //AppBar
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _appBar(),
          body: TabBarView(
            children: [
              CurrentOrder(),
              OrderHistory(),
            ],
          ),
        ),
      ), //Scaffold
    ); //MaterialApp
  }
}
