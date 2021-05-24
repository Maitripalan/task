import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/login_phone.dart';
import 'package:task/user_home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    _loadUser();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isUserSignedIn = false;

  _loadUser() async {
    User? currentuser = await FirebaseAuth.instance.currentUser;
    print(currentuser!.email);
    print(currentuser.displayName);
    print(currentuser.phoneNumber);
    print(currentuser.photoURL);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString("name", currentuser.displayName.toString());
   await sharedPreferences.setString("email", currentuser.email.toString());
  await  sharedPreferences.setString("photo", currentuser.photoURL.toString());
  await  sharedPreferences.setString("id", currentuser.uid.toString());

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UserHome()));
  }

  Future<User?> _handleSign() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? userDetails = (await _auth.signInWithCredential(credential)).user;

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                    height: 270, child: Image.asset('assets/firebase.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade500),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(color: Colors.blue.shade500)))),
                  onPressed: () {
                    _handleSign();
                  },
                  child: Row(
                    children: [
                    
                      Text(
                        "Google",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      //   textStyle: MaterialStateProperty.all<TextStyle>(),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(color: Colors.green)))),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPhone()));
                  },
                  child: Row(
                    children: [Icon(Icons.phone), Text("Phone")],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
