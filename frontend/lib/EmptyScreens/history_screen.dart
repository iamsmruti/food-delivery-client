import 'package:flutter/material.dart';
import '../constant.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: const Text(
          'History',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Vector.png',
                height: 70,
                width: 70,
              ),
              const DefaultTextStyle(
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.black),
                  child: Text('No history yet')),
              const DefaultTextStyle(
                  style: TextStyle(fontSize: 15, color: Colors.black26),
                  child: Text('Hit the button down below to Create an Order.'))
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: () {},
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Start Ordering',
              style: TextStyle(fontSize: 18, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey.shade200,
    );
  }
}
