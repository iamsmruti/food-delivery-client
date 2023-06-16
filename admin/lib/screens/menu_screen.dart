import 'package:admin/models/food.dart';
import 'package:admin/smallfont.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'add_item_page.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  PageController pageController = PageController(viewportFraction: 0.85);
  int selectedChipIndex = 0;
  List<String> categoryMenu = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

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

  Stream<List<String>> getCategoryMenuStream() {
    final merchantId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("Merchants")
        .doc(merchantId)
        .collection("Categories")
        .snapshots()
        .map((snapshot) {
      final categories = snapshot.docs.map((doc) => doc.id).toList();
      categories.insert(0, "All");
      return categories;
    });
  }

  Future<void> getCategories() async {
    final merchantId = FirebaseAuth.instance.currentUser!.uid;
    final categorySnapshot = await FirebaseFirestore.instance
        .collection("Merchants")
        .doc(merchantId)
        .collection("Categories")
        .get();
    final categories = categorySnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      categoryMenu = categories;
      categoryMenu.insert(0, "All");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 231, 249, 249),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Menu",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder<List<String>>(
                    stream: getCategoryMenuStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text(
                          "Error: ${snapshot.error.toString()}",
                        );
                      }
                      final categories = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: choiceChips(categories),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Food>>(
                  stream: readFoodDetails(),
                  builder: (context, snapshot) {
                    if (kDebugMode) {
                      print(snapshot.data?.length);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error.toString()}");
                    } else if (snapshot.hasData) {
                      final foods = snapshot.data!;
                      final filteredFoods = foods.where((food) {
                        if (categoryMenu[selectedChipIndex] == "All") {
                          return true;
                        } else {
                          return food.category == categoryMenu[selectedChipIndex];
                        }
                      }).toList();
                      if (filteredFoods.isEmpty) {
                        return const Center(
                          child: Text("No items in this category"),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredFoods.length,
                        itemBuilder: (context, index) {
                          return buildFood(filteredFoods[index]);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> choiceChips(List<String> menu) {
    return menu.map((category) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedChipIndex = menu.indexOf(category);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: selectedChipIndex == menu.indexOf(category)
                  ? Colors.teal
                  : Colors.blueGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Center(
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget buildFood(Food food) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
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
                    size: 20,
                    
                  ),
                  SmallFont(
                    text: food.description,
                    fontWeight: FontWeight.w400,
                  ),
                  const Spacer(),
                  Text(
                    "₹ ${food.price.toString()}",
                    style: const TextStyle(
                      fontSize: 20,
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
}
