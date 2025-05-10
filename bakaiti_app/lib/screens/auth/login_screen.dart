import 'dart:developer';
import 'dart:io';

import 'package:bakaiti_app/api/apis.dart';
import 'package:bakaiti_app/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../helper/dialogs.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  //initState method to make animated logo of the app.
  @override
  void initState() {
    super.initState();
    // Animated Position of the App name and Logo.
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

//Function For handling Google Button Click.
  _handleGoogleBtnClick() {
    //To Start Progress bar
    Dialogs.showProgressBar(context);

    //Calling Private function to Sign in with Google.
    _signInWithGoogle().then((user) async {
      //To Stop Progress bar
      Navigator.pop(context);
      if (user != null) {
        //To Get the user Information at log.
        // log('\nUser : ${user.user}');
        // log('\nUserAdditional Information : ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          });
        }
      }
    });
  }

  //Function for sign in with google.
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      //To Check user Internet status.
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle : $e');
      Dialogs.showSnackBar(context, 'Something went Wrong(Check Internet)');
      return null;
    }
  }

  //Build method.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //App bar of a App.
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: const Text('Welcome To Bakaiti'),
        ),

        //Body of the Login Screen.
        body: Stack(
          children: [
            //App Logo in the Login Screen.
            AnimatedPositioned(
                top: mq.height * .05,
                width: mq.width * .7,
                right: _isAnimate ? mq.width * .12 : -mq.width * .7,
                duration: const Duration(seconds: 1),
                child: Image.asset('images/app_icon.png')),

            //App name in Login Screen.s
            AnimatedPositioned(
                top: mq.height * .28,
                width: mq.width * .3,
                left: _isAnimate ? mq.width * .19 : -mq.width * .3,
                duration: Duration(seconds: 1),

                /*Here RichText is used to show the multicolor Text in the                 
                in the Login Screen.*/
                child: Container(
                  height: mq.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(244, 42, 49, 69)),

                  //Here is RichText.
                  child: Center(
                    child: RichText(
                      text: const TextSpan(children: [
                        //Text of 'Ba'
                        TextSpan(
                            text: 'Ba',
                            style: TextStyle(
                              color: Color(0xFF028E74),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            )),

                        //Text of 'कै'
                        TextSpan(
                            text: 'कै',
                            style: TextStyle(
                              color: Color.fromARGB(255, 253, 253, 253),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            )),

                        //Text of 'ti'
                        TextSpan(
                            text: 'ti',
                            style: TextStyle(
                              color: Color(0xFFFF7701),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            )),
                      ]),
                    ),
                  ),
                )),

            //Google signIn button in the Login Screen.
            Positioned(
                bottom: mq.height * .3,
                height: mq.height * .07,
                left: mq.width * .2,
                right: mq.width * .2,

                //Here is Google SignIn button.
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xF42A3145)),
                    onPressed: () {
                      //Calling this function for sign in with google.
                      _handleGoogleBtnClick();
                    },
                    icon: Image.asset(
                      'images/google.png',
                      height: mq.height * .05,
                    ),
                    label: const Text(
                      'SignIn with Google',
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ));
  }
}
