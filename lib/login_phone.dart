import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/user_home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}
class LoginPhone extends StatefulWidget {
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId='';

  bool showLoading = false;

    void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> UserHome()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      e.message;

    
    }
  }

  getMobileFormWidget(context) {
    
    return ListView(
      children: [
          Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                  height: 270,
                  child: Image.asset('assets/firebase.png')),
                
              ),
              
            ),
        Spacer(),
        
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            
            hintText: "eg +91 999 999",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });



            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                //signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
               
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("SEND"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }


   getOtpFormWidget(context) {
    return ListView(
      children: [
          Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                  height: 270,
                  child: Image.asset('assets/firebase.png')),
                
              ),
              
            ),
        
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));

      
    
  }
}