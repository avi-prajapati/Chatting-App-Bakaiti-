import 'package:bakaiti_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/apis.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Boolean Variable for the Animated position of the App Name.
  bool _animate = false;

  //initState method to make animated logo of the app.
  @override
  void initState() {
    super.initState();

    //Animated Posiltion of App Name.
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _animate = true;
      });
    });

    //Changing Screen after 6 sec from Splash Screen.
    Future.delayed(const Duration(seconds: 9), () {
      //To Show Top Status Bar.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      //To Move in Different Screen After Splash Screen.
      if (APIs.auth.currentUser != null) {
        //To move in Home Screen.
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      } else {
        //To move in Login Screen.
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    });
  }

  //Build method.
  @override
  Widget build(BuildContext context) {
    //To Fetch the size of a device.
    mq = MediaQuery.of(context).size;

    return Scaffold(

        //Body of the Login Screen.
        body: Stack(
      children: [
        //App Logo in the Login Screen.
        Positioned(
            top: mq.height * .2,
            width: mq.width * .7,
            right: mq.width * .12,
            child: const FadeInImage(
              placeholder: AssetImage('images/1490.gif'),
              image: AssetImage('images/app_icon.png'),
              fadeInDuration: Duration(seconds: 2),
              fadeOutDuration: Duration(seconds: 2),
            )),

        //App name in Login Screen.s
        AnimatedPositioned(
            top: mq.height * .43,
            width: mq.width * .3,
            left: _animate ? mq.width * .19 : -mq.width * .3,
            duration: Duration(seconds: 2),

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
            bottom: mq.height * .2,
            height: mq.height * .07,
            left: mq.width * .2,
            right: mq.width * .2,

            //Here is Google SignIn button.
            child: const Center(
              child: Text('❤️Made In India❤️',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
            ))
      ],
    ));
  }
}
