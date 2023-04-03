import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:foodrecipe/screens/SignUpPage.dart';

import 'HomePage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pswcontroller = TextEditingController();
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            textItem("Email...", _emailController, false),
            SizedBox(
              height: 20,
            ),
            textItem("Password...", _pswcontroller, true),
            SizedBox(
              height: 20,
            ),
            colorButton(),
            SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "If you don't have an Account?",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignUpPage()),
                      (route) => false);
                },
                child: Text(
                  "  Sign Up",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            SizedBox(
              height: 10,
            ),
            Text(
              "Forgot Password ?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.signInWithEmailAndPassword(
                  email: _emailController.text, password: _pswcontroller.text);
          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Color(0xffff7043),
            Color(0xffffcc80),
            Color(0xffff7043),
          ]),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obsecureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            labelText: labeltext,
            labelStyle: TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.deepOrange,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ))),
      ),
    );
  }
}
