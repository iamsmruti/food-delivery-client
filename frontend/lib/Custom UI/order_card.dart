import 'package:flutter/material.dart';
import 'package:frontend/Models/order_details.dart';
import 'package:frontend/constant.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.orderDetails}) : super(key: key);
  final OrderDetails orderDetails;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {},
            child: Card(
              shape: roundedRectangle8,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListTile(
                  leading: Image.network(
                    "https://images.livemint.com/img/2023/01/13/600x338/Kolkata_Biryani_1673628587318_1673628598499_1673628598499.jpg",
                  ),
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 12),
                    child: Text(widget.orderDetails.itemName,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.orderDetails.orderNumber,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                        Row(
                          children: [
                            Card(
                              margin: const EdgeInsets.only(right: 0),
                              shape: roundedRectangle4,
                              color: primaryColor,
                              child: InkWell(
                                splashColor: Colors.white70,
                                customBorder: roundedRectangle4,
                                child: const Icon(
                                  Icons.remove,
                                  size: 22,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2),
                              child: Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.only(right: 0),
                              shape: roundedRectangle4,
                              color: primaryColor,
                              child: InkWell(
                                splashColor: Colors.white70,
                                customBorder: roundedRectangle4,
                                child: const Icon(
                                  Icons.add,
                                  size: 22,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}
