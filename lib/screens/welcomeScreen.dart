import 'package:chatapp/screens/registerationScreen.dart';
import 'package:chatapp/screens/signinScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String routeScreen = 'welcomeScreen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    height: 180,
                    child: Image.asset("images/logo.png"),
                  ),
                  const Text(
                    'MessageMe',
                    style: TextStyle(
                        color: Color(0xff2e386b),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                color: Colors.yellow[900]!,
                title: 'Sign in',
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.routeScreen);
                },
              ),
              MyButton(
                color: Colors.blue[800]!,
                title: 'register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.routeScreen);
                },
              ),
            ]),
      ),
    );
  }
}
