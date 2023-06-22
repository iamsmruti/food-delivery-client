import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallFont extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final double height;
  final TextOverflow overflow;
  final FontWeight? fontWeight;

  const SmallFont(
      {super.key,
      this.color = const Color(0xFF332d2b),
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 15,
      this.height = 1.4,
      this.fontWeight = FontWeight.w600});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
          height: height,
          overflow: null,
        ),
      ),
    );
  }
}
