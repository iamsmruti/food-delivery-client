import 'package:flutter/material.dart';
import 'package:frontend/Custom%20UI/food_card.dart';
import 'package:frontend/Custom%20UI/resturant_info.dart';
import 'package:frontend/Models/food.dart';
import 'package:frontend/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedChipIndex = 0;
  List<String> categoryMenu = [
    "Chinese Items",
    "Indian",
    "Biryani",
    "South Indian",
    "North Indian"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const RestaurantInfo(),
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
                children: choiceChips(categoryMenu),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 7,
                itemBuilder: ((context, index) {
                  return FoodCard(Food(
                      image:
                          "https://images.theconversation.com/files/368263/original/file-20201109-22-lqiq5c.jpg?ixlib=rb-1.1.0&rect=10%2C0%2C6699%2C4476&q=45&auto=format&w=926&fit=clip",
                      price: 200,
                      name: "How $index",
                      description: "Now",
                      id: "105",
                      category: "Dinner",
                      isVeg: true,
                      isAvilable: true));
                }),
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
        // showSearch(
        //     context: context, delegate: CustomSearchDelegate(data: itemList));
      }),
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Card(
              shape: roundedRectangle12,
              color: secondaryColor,
              child:  Padding(
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
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        itemBuilder: ((context, index) {
          return FoodCard(Food(
              image:
                  "https://images.livemint.com/img/2023/01/13/600x338/Kolkata_Biryani_1673628587318_1673628598499_1673628598499.jpg",
              price: 200,
              name: "How $index",
              description: "Now",
              id: "105",
              category: "Dinner",
              isVeg: true,
              isAvilable: false));
        }),
      ),
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
}
