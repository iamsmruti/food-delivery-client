import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Custom%20UI/food_card.dart';
import 'package:frontend/Custom%20UI/resturant_info.dart';
import 'package:frontend/Models/food.dart';
import 'package:frontend/Screens/search_delegate.dart';
import 'package:frontend/constant.dart';

import '../Models/merchart.dart';

class MenuScreen extends StatefulWidget {
  final Merchant shop;
  final String distance;
  const MenuScreen({Key? key, required this.shop, required this.distance})
      : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedChipIndex = 0;
  List categoryMenu = [];
  List<Food> listOfItems = [];

  @override
  void initState() {
    super.initState();
    getCategories(widget.shop.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            RestaurantInfo(
              merchant: widget.shop,
              distance: widget.distance,
            ),
            const SizedBox(
              height: 10,
            ),
            buildSearchBar(),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: choiceChips(categoryMenu),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            buildFoodList()
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
                      style: subtitleStyle,
                    )
                  ],
                ),
              ))),
    );
  }

  Widget buildFoodList() {
    return StreamBuilder<List<Food>>(
      stream: fetchMenuItems(widget.shop.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            categoryMenu.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && categoryMenu.isNotEmpty) {
          listOfItems = snapshot.data!;
          final filteredFoods = listOfItems.where((food) {
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
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                return FoodCard(filteredFoods[index]);
              },
            ),
          );
        } else {
          return const Text('No menu items available');
        }
      },
    );
  }

  List<Widget> choiceChips(
    List menu,
  ) {
    List<Widget> chips = [];
    for (int i = 0; i < menu.length; i++) {
      Widget item = Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedChipIndex = i;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color:
                      selectedChipIndex == i ? primaryColor : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Center(
                    child: Text(
                  menu[i],
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
          ));
      chips.add(item);
    }
    return chips;
  }

  Stream<List<Food>> fetchMenuItems(String restaurantId) =>
      FirebaseFirestore.instance
          .collection("Merchants")
          .doc(restaurantId)
          .collection("Menu")
          .snapshots()
          .map((snapshot) {
        return Food.foodList(snapshot);
      });

  getCategories(String restaurantId) async {
    categoryMenu = await FirebaseFirestore.instance
        .collection("Merchants")
        .doc(restaurantId)
        .collection("Categories")
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());
    setState(() {
      categoryMenu.insert(0, "All");
    });
  }
}
