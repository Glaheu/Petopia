import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String errorMessage = '';
  bool _passwordIsHidden = true;
  bool _repasswordIsHidden = true;
  bool emailUpdates = false;
  bool smsUpdates = false;

  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerReNewPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserPreferences();
  }

  Future<void> loadUserPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUID = user.uid;
      final docSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

      if (docSnapshot.exists) {
        setState(() {
          emailUpdates = docSnapshot.data()['emailUpdates'] ?? false;
          smsUpdates = docSnapshot.data()['smsUpdates'] ?? false;
        });
      }
    }
  }

  Future<void> updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        errorMessage = "No user logged in.";
      });
      return;
    }

    String newPassword = _controllerNewPassword.text.trim();
    String newRePassword = _controllerReNewPassword.text.trim();

    try {
      if (newPassword.isNotEmpty && newPassword == newRePassword) {
        if (newPassword.length >= 6) {
          await user.updatePassword(newPassword);
        } else {
          setState(() {
            errorMessage = "Password should be at least 6 characters!";
          });
          return;
        }
      } else if (newPassword.isNotEmpty || newRePassword.isNotEmpty) {
        setState(() {
          errorMessage = "Passwords don't match or are empty!";
        });
        return;
      }

      final userUID = user.uid;
      // Update email and SMS preferences in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userUID).set({
        'emailUpdates': emailUpdates,
        'smsUpdates': smsUpdates,
      }, SetOptions(merge: true));

      // Successful update
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "An error occurred.";
      });
    }
  }

  void _togglePasswordView() {
    setState(() {
      _passwordIsHidden = !_passwordIsHidden;
    });
  }

  void _togglerepasswordView() {
    setState(() {
      _repasswordIsHidden = !_repasswordIsHidden;
    });
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.brown,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)),
      title: Image(image: AssetImage('images/logo2.png'), height: 100),
    );
  }

  Widget _errorMessage() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        errorMessage == '' ? '' : '$errorMessage',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _recieveEmailUpdates() {
    return CheckboxListTile(
      title: Text("Agree to receive Email updates"),
      value: emailUpdates,
      onChanged: (newValue) {
        setState(() {
          emailUpdates = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _recieveSMSUpdates() {
    return CheckboxListTile(
      title: Text("Agree to receive SMS updates"),
      value: smsUpdates,
      onChanged: (newValue) {
        setState(() {
          smsUpdates = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(33, 150, 243, .5),
                        blurRadius: 15,
                      )
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: TextField(
                        controller: _controllerNewPassword,
                        obscureText: _passwordIsHidden,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            hintText: "Password",
                            suffix: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                _passwordIsHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _controllerReNewPassword,
                        obscureText: _repasswordIsHidden,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
                            suffix: InkWell(
                              onTap: _togglerepasswordView,
                              child: Icon(
                                _repasswordIsHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _errorMessage(),
              _recieveEmailUpdates(),
              _recieveSMSUpdates(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            updateUserProfile();
          },
          label: Text(
            "Save",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.brown,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
