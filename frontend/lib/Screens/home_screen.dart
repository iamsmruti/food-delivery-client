import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Custom%20UI/food_card.dart';
import 'package:frontend/Custom%20UI/resturant_info.dart';
import 'package:frontend/Models/food.dart';
import 'package:frontend/constant.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  const MenuScreen({Key? key, required this.restaurantId}) : super(key: key);


  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
            Container(
              child: FutureBuilder<List<Food>>(
                future: fetchMenuItems(widget.restaurantId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Food> menuItems = snapshot.data!;
                    
                    return ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        Food menuItem = menuItems[index];
                        return FoodCard(Food(
                            image:
                                menuItem.image,
                            price: menuItem.price,
                            name: menuItem.name,
                            description: menuItem.description,
                            id: menuItem.id,
                            category: menuItem.category,
                            isVeg: menuItem.isVeg,
                            isAvilable: menuItem.isAvilable,));
                      },
                    );
                  } else {
                    return Text('No menu items available');
                  }
                },
              ),
            )
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
              child: Padding(
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

  Future<List<Food>> fetchMenuItems(String restaurantId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Merchants')
        .doc(widget
            .restaurantId) 
        .collection('Menu')
        .get();

    List<Food> menuItems = snapshot.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Food(
        name: data['name'],
        description: data['description'],
        category: data['categoty'],
        price: data['price'],
        isAvilable: data['isAvailable'],
        id: data['id'],
        isVeg: data['veg'],
        image: data['image'],
        
      );
    }).toList();

    return menuItems;
  }
}
