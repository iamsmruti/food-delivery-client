import 'package:flutter/material.dart';
import 'package:frontend/Models/OrderDetails.dart';
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Container(
              color: Colors.white.withOpacity(0.6),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.asset(widget.orderDetails.icon),
                  ),
                  title: Text(
                      widget.orderDetails.itemName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )
                  ),
                  subtitle: Row(
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
                                        fontSize: 20,
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
                                    fontSize: 18,
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
                                        fontSize: 20,
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
        const SizedBox(height: 15)
      ],
    );
  }
}