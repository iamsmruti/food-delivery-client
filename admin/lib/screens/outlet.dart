import 'package:admin/models/food.dart';
import 'package:admin/smallfont.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Outlet extends StatefulWidget {
  const Outlet({Key? key}) : super(key: key);

  @override
  State<Outlet> createState() => _OutletState();
}

class _OutletState extends State<Outlet> {
  PageController pageController = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Stream<List<Food>> readFoodDetails() => FirebaseFirestore.instance
          .collection("Merchants")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Menu")
          .snapshots()
          .map((snapshot) {
        return Food.foodList(snapshot);
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 186, 228, 228),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 50 * 2,
                  ),
                  Text(
                    "Menu",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<List<Food>>(
                    stream: readFoodDetails(),
                    builder: (context, snapshot) {
                      if (kDebugMode) {
                        print(snapshot.data?.length);
                      }
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error.toString()}");
                      } else if (snapshot.hasData) {
                        if (kDebugMode) {
                          // print(snapshot.data?.length);
                        }
                        final foods = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: foods.length,
                          itemBuilder: (context, index) =>
                              buildFood(foods[index]),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFood(Food food) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        padding: const EdgeInsets.all(15),
        height: 120,
        width: double.maxFinite,
        child: Row(
          children: [
            Container(
                height: 45 * 2,
                width: 45 * 2,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    food.image,
                    fit: BoxFit.cover,
                  ),
                )),
            const SizedBox(
              width: 15,
            ),
            Column(
              children: [
                SmallFont(
                  text: food.name,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
                SmallFont(text: food.description, fontWeight: FontWeight.w400),
                const Spacer(),
                Text(
                  "₹ ${food.price.toString()}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
              ],
            ),
            const Spacer(),
            // Row(
            //   children: [

            //     // const SizedBox(
            //     //   width: 120,
            //     // ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           food.isAvailable = !food.isAvailable;
            //         });
            //       },
            //       child: AnimatedContainer(
            //         duration: const Duration(milliseconds: 300),
            //         width: 50.0,
            //         // height: 50.0,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(25.0),
            //           color: food.isAvailable ? Colors.green : Colors.red,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: food.isAvailable
            //               ? MainAxisAlignment.end
            //               : MainAxisAlignment.start,
            //           children: [
            //             Container(
            //               width: 50.0,
            //               height: 50.0,
            //               decoration: const BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.white,
            //               ),
            //               child: Icon(
            //                 food.isAvailable ? Icons.check : Icons.close,
            //                 color: food.isAvailable
            //                     ? Colors.green
            //                     : Colors.red,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            Column(
              children: [
                Text("Availablity",style: TextStyle(fontSize: 12,color: Colors.black,fontWeight:FontWeight.w400),),
                Switch(
                  value: food.isAvailable,
                  onChanged: (value) async {
                    await FirebaseFirestore.instance
                        .collection("Merchants")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Menu")
                        .doc(food.id)
                        .update({"isAvailable": value});
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                const Spacer(),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.transparent),
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: food.isVeg ? Colors.green : Colors.red),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
