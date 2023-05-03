import 'package:flutter/material.dart';
import 'package:frontend/Custom%20UI/order_card.dart';
import 'package:frontend/constant.dart';
import '../Models/order_details.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<OrderDetails> details = [
    OrderDetails(
        itemName: 'Veggie tomato mix',
        icon: 'assets/images/image.png',
        orderNumber: '#1900'),
    OrderDetails(
        itemName: 'Fish with mix Orange',
        icon: 'assets/images/image1.png',
        orderNumber: '#1900'),
    OrderDetails(
        itemName: 'Veggie tomato mix',
        icon: 'assets/images/image.png',
        orderNumber: '#1900'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: secondaryColor,
        title: const Text(
          'Cart',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
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
              'Complete Order',
              style: TextStyle(fontSize: 18, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: const Color(0xffe2e7ef),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: ListView.builder(
          itemCount: details.length,
          itemBuilder: (context, index) =>
              OrderCard(orderDetails: details[index]),
        ),
      ),
    );
  }
}
