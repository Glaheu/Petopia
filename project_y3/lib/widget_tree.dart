import 'package:project_y3/auth.dart';
import 'package:project_y3/pages/HomePage.dart';
import 'BottomNavBar.dart';
import 'package:project_y3/pages/LoginRegisterPage.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BottomNavBar(
            loggedUser: true,
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
