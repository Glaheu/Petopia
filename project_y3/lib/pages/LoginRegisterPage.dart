import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_y3/BottomNavBar.dart';
import 'package:project_y3/auth.dart';
import 'package:project_y3/fade_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';
  bool loggedUser = false;
  bool isLogin = true;
  bool _passwordIsHidden = true;
  bool _repasswordIsHidden = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRepassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Using Get to navigate
      Get.offAll(() => BottomNavBar(loggedUser: true));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Using Get to navigate
      Get.offAll(() => BottomNavBar(loggedUser: true));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> checkPasswordSame() async {
    print(_controllerPassword.text);
    print(_controllerRepassword.text);
    if (_controllerPassword.text == _controllerRepassword.text) {
      createUserWithEmailAndPassword();
    } else {
      setState(() {
        errorMessage = "Passwords do not match";
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

  Widget _header() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('images/logo2.png'), height: 100),
            SizedBox(height: 15),
            FadeAnimation(
                1.2,
                Text(
                  isLogin ? "Login" : "Register",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 10,
            ),
            FadeAnimation(
                1.3,
                Text(
                  isLogin ? "Welcome Back!" : "Welcome!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }

  BoxDecoration _gradientDecoration() {
    return BoxDecoration(color: Colors.brown);
    // gradient: LinearGradient(
    //     begin: Alignment.topCenter,
    //     colors:
    //     [Colors.blue[900], Colors.blue[800], Colors.blue[400]]));
  }

  Widget _field() {
    if (isLogin == true) {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              controller: _controllerPassword,
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
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              obscureText: _passwordIsHidden,
              enableSuggestions: false,
              autocorrect: false,
              controller: _controllerPassword,
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
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]))),
            child: TextField(
              obscureText: _repasswordIsHidden,
              enableSuggestions: false,
              autocorrect: false,
              controller: _controllerRepassword,
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
      );
    }
  }

  Widget _errorMessage() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        errorMessage == '' ? '' : '$errorMessage',
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dontHaveAccount() {
    return FadeAnimation(
        1.5,
        InkWell(
            splashColor: Colors.brown,
            onTap: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Text(
              isLogin ? "Don't have account?" : "Already have an account?",
              style: TextStyle(color: Colors.grey),
            )));
  }

  Widget _submitButton() {
    return FadeAnimation(
      1.6,
      RaisedButton(
        color: Colors.brown[400],
        onPressed: isLogin ? signInWithEmailAndPassword : checkPasswordSame,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            isLogin ? 'Login Account' : 'Register Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _skip(bool loggedUser) {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.offAll(() => BottomNavBar(loggedUser: loggedUser));
      },
      label: const Text(
        'Skip',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.arrow_forward_ios),
      backgroundColor: Colors.brown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _gradientDecoration(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              _header(),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(33, 150, 243, .5),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: _field(),
                              )),
                          SizedBox(height: 30),
                          _errorMessage(),
                          _dontHaveAccount(),
                          SizedBox(height: 30),
                          _submitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
      floatingActionButton: _skip(loggedUser),
    );
  }
}
