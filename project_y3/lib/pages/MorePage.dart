import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'EditProfile.dart';
import 'LoginRegisterPage.dart';
import 'ViewOrderPage.dart';
import 'AboutAppPage.dart';
import 'package:project_y3/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // For base64 operations

class MorePage extends StatefulWidget {
  final bool loggedUser;
  MorePage({@required this.loggedUser});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  User currentUser;
  String userEmail = '';
  File _image; // For storing the picked image file
  ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    log("hi");
    imageProvider = AssetImage('images/logo2.png'); // Default placeholder image
    loadImageString();
  }

  Future<void> getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userEmail = currentUser.email ?? 'No email available';
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageProvider = FileImage(_image);
      });
      uploadImageString();
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Get.offAll(LoginPage());
  }

  Future<void> uploadImageString() async {
    if (_image != null) {
      final bytes = await _image.readAsBytes(); // Use async read
      String imgString = base64Encode(bytes);

      String userUID = Auth().getCurrentUserID();
      log("Uploading image string for user $userUID"); // Debug print

      await FirebaseFirestore.instance.collection('Users').doc(userUID).set({
        'imageString': imgString,
      }, SetOptions(merge: true)).then((_) {
        log("Document successfully updated");
      }).catchError((error) {
        log("Error updating document: $error");
      });
    } else {
      log("No image selected");
    }
  }

  void decodeImageFromBase64String(String base64String) {
    final decodedBytes = base64Decode(base64String);

    setState(() {
      _image = File.fromRawPath(decodedBytes);
    });
  }

  Future<void> loadImageString() async {
    String userUID = Auth().getCurrentUserID();
    var document =
        await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

    if (document.exists) {
      String imgString = document.data()['imageString'];
      final decodedBytes = base64Decode(imgString);
      setState(() {
        imageProvider = MemoryImage(decodedBytes); // Update the image provider
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$userEmail',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10), // Added some spacing
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        imageProvider, // Use the dynamic image provider
                  ),
                ),

                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.to(EditProfile());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewOrders()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'View Orders',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutAppPage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'About App',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: signOut,
          label: Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
