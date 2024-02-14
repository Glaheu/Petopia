import 'package:flutter/material.dart';
import 'package:project_y3/pages/LoginRegisterPage.dart';
import 'pages/HomePage.dart';
import 'package:project_y3/auth.dart';
import 'pages/RecipeCategoryPage.dart';
import 'pages/MorePage.dart';
import 'pages/MapsPage.dart';
import 'pages/eShop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'CartController.dart';
import 'package:get/get.dart';
import 'pages/CartPage.dart';

class BottomNavBar extends StatefulWidget {
  final bool loggedUser;

  BottomNavBar({@required this.loggedUser});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState(loggedUser);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final bool loggedUser;
  final CartController cartController = Get.find<CartController>();
  _BottomNavBarState(this.loggedUser);

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(loggedUser: widget.loggedUser),
      RecipeCategoryPage(),
      MapsPage(loggedUser: widget.loggedUser),
      EShopPage(loggedUser: widget.loggedUser),
      MorePage(loggedUser: widget.loggedUser),
    ];
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.brown,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Image(image: AssetImage('images/logo2.png'), height: 100),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: widget.loggedUser
              ? Obx(() => Badge(
                  position: BadgePosition.topEnd(top: 2, end: -5),
                  badgeContent: Text(
                    '${cartController.cartItems.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Get.to(() => CartPage());
                      })))
              : Container(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.brown,
          primaryColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Maps',
            ),
            if (loggedUser == true) ...[
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'eShop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ] else
              ...[]
          ],
        ),
      ),
      floatingActionButton: loggedUser == false
          ? FloatingActionButton(
              onPressed: () {
                Get.offAll(LoginPage());
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.brown[400],
            )
          : null,
    );
  }
}
