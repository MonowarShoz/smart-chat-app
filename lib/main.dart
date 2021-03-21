import 'package:chat_smart_app/screens/home_screen.dart';
import 'package:chat_smart_app/screens/login_screen.dart';

import 'package:chat_smart_app/screens/signup_screen.dart';
import 'package:chat_smart_app/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartChat',
      navigatorKey: NavigationService.instance.navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(42, 117, 188, 1),
        accentColor: Color.fromRGBO(42, 117, 188, 1),
        backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      ),
      initialRoute: "login",
      routes: {
        "login" : (BuildContext _context) => LoginScreen(),
        "signup": (BuildContext _context) => SignupScreen(),
        "home": (BuildContext _context) => HomeScreen(),
        
      },
      
    );
  }
}
