import 'package:chatapp/screens/chatScreen.dart';
import 'package:chatapp/screens/registerationScreen.dart';
import 'package:chatapp/screens/signinScreen.dart';
import 'package:chatapp/screens/welcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Me',
      initialRoute: WelcomeScreen.routeScreen,
      routes: {
        WelcomeScreen.routeScreen: (context) => const WelcomeScreen(),
        SignInScreen.routeScreen: (context) => const SignInScreen(),
        RegistrationScreen.routeScreen: (context) => const RegistrationScreen(),
        ChatScreen.routeScreen: (context) => const ChatScreen()
      },
    );
  }
}
