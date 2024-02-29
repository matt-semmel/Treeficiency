import 'package:flutter/material.dart';
import '../auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset(
              'assets/images/tree.png',
              height: 240,
            ),
          ),

          const SizedBox(height: 48),

          // title
          const Text(
            'Treefficiency',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 24),

          // sub title
          const Text(
            'Save electricity. Save trees. Save the world.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),

          // start new button
          GestureDetector(
            onTap: () {
              AuthService().signInWithGoogle();
              //Navigator.pushNamed(context, '/homepage');
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 63, 143, 122),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    )));
  }
}
