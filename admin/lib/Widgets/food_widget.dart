import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/food.dart';
import '../screens/Menu/add_item_page.dart';
import '../smallfont.dart';

Widget buildFood(Food food, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemAdd(
            category: food.category,
            isEdit: true,
            itemId: food.id,
            itemName: food.name,
            itemPrice: food.price,
            isVeg: food.isVeg,
            isAvailable: food.isAvailable,
            imageLink: food.image,
            description: food.description,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
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
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  food.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SmallFont(
                  text: food.name,
                  fontWeight: FontWeight.bold,
                  size: 16,
                ),
                SmallFont(
                  text: food.description,
                  fontWeight: FontWeight.w400,
                  size: 12,
                ),
                const Spacer(),
                Text(
                  "₹ ${food.price.toString()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  "Availability",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 / 2),
                        color: food.isVeg ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
