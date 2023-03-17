import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              child: const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    fillColor: Colors.green,
                    focusColor: Colors.grey,
                    labelText: 'Mobile Number'
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.green,
                    focusColor: Colors.grey,
                    labelText: 'Password'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}