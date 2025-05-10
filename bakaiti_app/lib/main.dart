import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
// import 'screens/splash_screen.dart';

//Intialising object to get the size of a device.
late Size mq;

void main() {
  //For Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  //To hide bottom Device Controlling Bar.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //To make App only work in Potrait mode.
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakaiti App',
      debugShowCheckedModeBanner: false,

      //PreDefine theme for the Appbar which we use many times.
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xF42A3145),
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),

      //Home of the Application.
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
