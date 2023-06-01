import 'dart:ui';

import 'package:flutter/material.dart';

class SmallFont extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;
  TextOverflow overflow;

  SmallFont(
      {super.key,
      this.color = const Color(0xFF332d2b),
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 15,
      this.height = 1.4, required FontWeight fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //overflow: overflow,
      style: TextStyle(
          color: color,
          fontFamily: 'ROBOTO',
          fontSize: size,
          height: height,
          overflow: null),
    );
  }
}