import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: const Text(
          'My offers',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DefaultTextStyle(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: Colors.black),
                child: Text('ohh snap! No offers yet')
            ),
            DefaultTextStyle(
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black26),
                child: Text("Bella doesn't have any offers"),
            ),
            DefaultTextStyle(
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black26),
                child: Text("yet please check again.")
            )
          ],
        ),
      ),
    );
  }
}