import 'package:flutter/material.dart';
import 'package:frontend/Models/order_details.dart';
import 'package:frontend/constant.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key,required this.orderDetails}) : super(key: key);
  final OrderDetails orderDetails;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    int count = 1;
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {},
            child: Card(
              shape: roundedRectangle8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                    leading: SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset(widget.orderDetails.icon),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 0, 6),
                      child: Text(

                          widget.orderDetails.itemName,
                          maxLines: 2,

                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          )
                      ),
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
                                color: primaryColor
                              ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Container(
                              color: primaryColor,
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                            '+',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      count.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          count--;
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                            '-',style: TextStyle(
                                            fontSize: 27,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          )
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