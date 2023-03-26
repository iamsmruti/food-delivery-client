import 'package:flutter/material.dart';
import '../constant.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: const Text(
          'Orders',
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
            Icon(
                Icons.shopping_cart_outlined,
                size: 120,
                color: Colors.grey,
            ),
            DefaultTextStyle(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black),
                child: Text('No orders yet')
            ),
            DefaultTextStyle(
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black26),
                child: Text('Hit the button down below to Create an Order.')
            )
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 200,
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: ()  {},
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Start Ordering',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.5
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey.shade200,
    );
  }
}