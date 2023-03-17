import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/LoginScreen.dart';
import 'package:frontend/constant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 100), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context)=>const LoginScreen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width.toDouble();
    double height = size.height.toDouble();
    return Container(
      height: size.height,
      width: size.width,
      color: primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width*0.15,vertical: height*0.12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
            const DefaultTextStyle(
                style: TextStyle(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.white
                ),
                child: Text('Food for')
            ),
            const DefaultTextStyle(
                style: TextStyle(
                    height: 0.8,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.white
                ),
                child: Text('Everyone')
            ),
            SizedBox(height: height*0.45),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: width*0.6,
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
                            style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 35),
                            backgroundColor: Colors.white
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}