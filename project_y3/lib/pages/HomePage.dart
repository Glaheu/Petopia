import 'package:flutter/material.dart';
import 'package:project_y3/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:project_y3/pages/DogPage.dart';
import 'package:project_y3/pages/CatPage.dart';

class Home extends StatefulWidget {
  final bool loggedUser;
  Home({@required this.loggedUser});
  @override
  State<Home> createState() => HomePage(this.loggedUser);
}

class HomePage extends State<Home> {
  HomePage(bool loggedUser);
  final User user = Auth().currentUser;

  Widget _carousel(String banner1, String banner2, String banner3,
      String banner4, String banner5) {
    return CarouselSlider(
      autoPlayCurve: Curves.ease,
      items: [banner1, banner2, banner3, banner4, banner5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image(
                  image: AssetImage("images/$i"),
                  fit: BoxFit.fill,
                ));
          },
        );
      }).toList(),
      autoPlay: true,
      height: 100, // Adjusted for demonstration
    );
  }

  Widget _infoButton(String imagePath, String label, Widget destination) {
    return InkWell(
      onTap: () {
        Get.to(() => destination);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center, 
          children: [
            Image(
              image: AssetImage(imagePath),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5), // Darken the image
              colorBlendMode: BlendMode.darken,
            ),
            // The text
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 15),
            _carousel(
              "banner1.jpg",
              "banner2.jpg",
              "banner3.jpg",
              "banner4.jpg",
              "banner5.jpg",
            ),
            SizedBox(height: 20),
            _infoButton('images/dog.jpg', 'Dog Information', DogPage()),
            SizedBox(height: 20), 
            _infoButton('images/cat.jpg', 'Cat Information', CatPage()),
          ],
        ),
      ),
    );
  }
}
