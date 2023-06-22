import 'package:admin/constants.dart';
import 'package:admin/screens/Menu/search_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/food_widget.dart';
import '../../Models/food.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  PageController pageController = PageController(viewportFraction: 0.85);
  int selectedChipIndex = 0;
  List<String> categoryMenu = [];
  List<Food> listOfItems = [];

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 249, 249),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: categoryMenu.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  buildSearchBar(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: choiceChips(categoryMenu),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder<List<Food>>(
                      stream: readFoodDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error.toString()}");
                        } else if (snapshot.hasData) {
                          listOfItems = snapshot.data!;
                          final filteredFoods = listOfItems.where((food) {
                            if (categoryMenu[selectedChipIndex] == "All") {
                              return true;
                            } else {
                              return food.category ==
                                  categoryMenu[selectedChipIndex];
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
                              return buildFood(filteredFoods[index], context);
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
    );
  }

  Widget buildSearchBar() {
    return InkWell(
      onTap: (() {
        showSearch(
            context: context,
            delegate: CustomSearchDelegate(data: listOfItems));
      }),
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Card(
              shape: roundedRectangle12,
              color: secondaryColor,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search Items",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ))),
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
}
