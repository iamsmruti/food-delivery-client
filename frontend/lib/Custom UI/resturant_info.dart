import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/cart_model.dart';
import 'package:frontend/constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../Screens/cart_screen.dart';

class RestaurantInfo extends ConsumerWidget {
  const RestaurantInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            padding: const EdgeInsets.only(top: 5),
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back_ios,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Black Box",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "20 Min",
                              style: TextStyle(color: Colors.white),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "2KM",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Resturant",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const CartScreen(),
                      withNavBar: true,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          ref.watch(cartDataProv).cartItems.length.toString(),
                          style: const TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Orange Is Good For Health",
                    style: TextStyle(fontSize: 16)),
                Row(
                  children: const [
                    Icon(Icons.star_outline, color: primaryColor),
                    SizedBox(
                      width: 5,
                    ),
                    Text("4.5",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
