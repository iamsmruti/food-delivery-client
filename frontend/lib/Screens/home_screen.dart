import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Menu"),centerTitle: true, backgroundColor: primaryColor,), );
  }
}