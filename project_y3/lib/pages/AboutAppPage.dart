import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About', textAlign: TextAlign.center),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'images/logo2.png', // Replace with your image
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Petopia is designed with a clean and inviting aesthetic, reflecting the warmth and joy of the pet-owner relationship. The color palette combines soft pastels, such as calming blues and gentle greens, to create a visually appealing and serene atmosphere. These colors evoke a sense of tranquility, which is perfect for an app centered around the well-being of pets.\n\nThe main objective of Petopia is to serve as a holistic and indispensable companion for pet owners and enthusiasts, fostering a deeper connection between individuals and their beloved cats and dogs.",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Developers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'images/dev.png'), // Replace with your developer's image
                  ),
                  SizedBox(height: 10),
                  Text('Lennel Sng', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    onTap: () async {
                      final url = 'mailto:lennelsng@gmail.com';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Call'),
                    onTap: () async {
                      final url = 'tel:++6588264272';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text('LinkedIn'),
                    onTap: () async {
                      final url = 'https://www.linkedin.com/in/lennelsng/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.video_library),
                    title: Text('YouTube'),
                    onTap: () async {
                      final url = 'https://www.youtube.com/@Glaheu/videos';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
