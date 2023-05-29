import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Models/address_model.dart';
import 'package:frontend/Models/cart_model.dart';
import 'package:frontend/Screens/address_edit.dart';
import 'package:frontend/constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../Custom UI/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen>
    with SingleTickerProviderStateMixin {
  var now = DateTime.now();
  double oldTotal = 0;
  int? timesOrderd;
  double total = 0;
  String? gender;

  ScrollController scrollController = ScrollController();
  AnimationController? animationController;
  TextEditingController addressController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  // onCheckOutClick(MyCart cart) async {
  //   User user = FirebaseAuth.instance.currentUser!;
  //   try {
  //     final orderId = DateTime.now().millisecondsSinceEpoch;
  //     final orderDate = DateTime.now();
  //     List<Map> data = List.generate(cart.cartItems.length, (index) {
  //       return {
  //         "id": cart.cartItems[index].food.id,
  //         "name": cart.cartItems[index].food.name,
  //         "quantity": cart.cartItems[index].quantity,
  //       };
  //     }).toList();
  //     FirebaseFirestore.instance
  //         .collection("Orders")
  //         .doc(orderId.toString())
  //         .set({
  //       "Ordered Items": data,
  //       "Address": addressController.text,
  //       "Order Status": "Order Placed",
  //       "Total Price": int.parse(total.toString()),
  //       "Final Price": int.parse(dicountedPrice.toString()),
  //       "Order Id": orderId,
  //       "Date": orderDate,
  //       "UserId": user.uid,
  //       "Phone Number": user.phoneNumber,
  //       "Cooking Instructions": instructionsController.text
  //     });
  //     FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(user.uid)
  //         .collection("Orders")
  //         .doc(orderId.toString())
  //         .set({
  //       "Ordered Items": data,
  //       "Address": addressController.text,
  //       "Order Status": "Order Placed",
  //       "Total Price": int.parse(total.toString()),
  //       "Final Price": int.parse(dicountedPrice.toString()),
  //       "Date": orderDate
  //     });
  //   } catch (ex) {
  //     if (kDebugMode) {
  //       print(ex.toString());
  //     }
  //   }
  //   for (CartItem item in cart.cartItems) {
  //     MixPanelAnalyticsManager.instance.sendEvent(
  //       eventName: item.food.name,
  //       properties: {
  //         'api_endpoint': '/${item.food.category}/${item.food.name}',
  //         'status': 200,
  //         'Quantity': '${item.quantity}',
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cart = ref.watch(cartDataProv);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Checkout',
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCart(cart),
                  const Divider(
                    thickness: 2,
                  ),
                  buildAddress(),
                  const Divider(
                    thickness: 2,
                  ),
                  buidPaymentOptions(),
                  const SizedBox(
                    height: 170,
                  )
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomSection(cart))
        ],
      ),
    );
  }

  Widget buildCart(MyCart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cart",
          style: headerStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        cart.cartItems.isEmpty
            ? SizedBox(
                height: 200,
                width: double.infinity,
                child: Card(
                  shape: roundedRectangle12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Items"),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Add Items"))
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: cart.cartItems.length,
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return buildCartItem(
                      cart, cart.cartItems[index], animationController!);
                },
              ),
      ],
    );
  }

  Widget buildPriceInfo(MyCart cart) {
    oldTotal = total;
    total = 0;
    for (CartItem cart in cart.cartItems) {
      total += cart.food.price * cart.quantity;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Total:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AnimatedBuilder(
              animation: animationController!,
              builder: (context, child) {
                return Text(
                  '₹${lerpDouble(oldTotal, total, animationController!.value)!.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAddress() {
    print(Address.getAddress());
    bool isAddressAvilable = Address.getAddress() != null;
    Address? address;
    if (isAddressAvilable) {
      address = Address.getAddress()!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address",
          style: headerStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: Card(
              shape: roundedRectangle12,
              color: secondaryColor,
              child: isAddressAvilable
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Name : ${address!.name}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Address : ${address.address}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "StreetName : ${address.streetName}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "City : ${address.city} ,${address.state}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Phone: ${address.phoneNumber}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: const AddressEdit(
                                      isEdit: true,
                                    ));
                              },
                              child: const Text("Edit")),
                        ),
                      ],
                    )
                  : Center(
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: const AddressEdit(
                                  isEdit: false,
                                ));
                          },
                          child: const Text("Add Address")),
                    )),
        )
      ],
    );
  }

  Widget checkoutButton(MyCart cart, context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // if (cart.cartItems.isEmpty) {
          //   Fluttertoast.showToast(
          //       webPosition: "center", msg: "Your Cart Is Empty");
          // } else if (dicountedPrice < 199) {
          //   Fluttertoast.showToast(
          //       webPosition: "center", msg: "Minimum Order Value 200Rs.");
          // } else {
          //   displayTextInputDialog(context, cart);
          // }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
          backgroundColor: primaryColor,
          shape: const StadiumBorder(),
        ),
        child:
            Text('Checkout', style: titleStyle.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget buidPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Options",
          style: headerStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Card(
          shape: roundedRectangle12,
          child: Column(
            children: [
              RadioListTile(
                title: const Text("Online Mode"),
                value: "online",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: const Text("Cash On Delivery"),
                value: "cod",
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value.toString();
                  });
                },
              ),
            ],
          ),
        ),
        // RadioListTile(
        //   title: const Text("Other"),
        //   value: "other",
        //   groupValue: gender,
        //   onChanged: (value) {
        //     setState(() {
        //       gender = value.toString();
        //     });
        //   },
        // ),
      ],
    );
  }

  Widget buildBottomSection(MyCart cart) {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          )),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          buildPriceInfo(cart),
          checkoutButton(cart, context),
        ],
      ),
    );
  }
}
