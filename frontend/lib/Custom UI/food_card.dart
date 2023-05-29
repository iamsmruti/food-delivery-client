import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/cart_model.dart';
import '../Models/food.dart';
import '../constant.dart';

class FoodCard extends ConsumerStatefulWidget {
  final Food food;
  const FoodCard(this.food, {super.key});

  @override
  ConsumerState<FoodCard> createState() => FoodCardState();
}

class FoodCardState extends ConsumerState<FoodCard>
    with SingleTickerProviderStateMixin {
  Food get food => widget.food;
  CartItem get item {
    return ref.watch(cartDataProv).items.firstWhere(
        (element) => element.food.name == food.name,
        orElse: () => CartItem(food: food, quantity: 0));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      shape: roundedRectangle12,
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImage(),
                  buildTitleAndPrice(),
                ],
              ),
              buildButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 7,
      width: MediaQuery.of(context).size.width / 4,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
        child: Image.network(
          widget.food.image,
          fit: BoxFit.fitHeight,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          num.parse(
                              loadingProgress.expectedTotalBytes.toString())
                      : null),
            ));
          },
        ),
      ),
    );
  }

  Widget buildTitleAndPrice() {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      width: MediaQuery.of(context).size.width / 2.2,
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.crop_square_sharp,
                        color: food.isVeg ? Colors.green : Colors.red,
                        size: 22,
                      ),
                      Icon(Icons.circle,
                          color: food.isVeg ? Colors.green : Colors.red,
                          size: 10),
                    ],
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.7,
                    child: Text(
                      food.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Text(
                  "Category : ${food.category}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                food.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: infoStyle,
              ),
            ],
          ),
          Text(
            '₹${food.price}',
            style: titleStyle,
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 16, bottom: 8, top: 8),
      child: !item.food.isAvilable
          ? const Text("Not Available")
          : item.quantity == 0
              ? ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: addItemToCard,
                  child: const Text("Add"),
                )
              : Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(right: 0),
                      shape: roundedRectangle4,
                      color: primaryColor,
                      child: InkWell(
                        onTap: removeItemfromCard,
                        splashColor: Colors.white70,
                        customBorder: roundedRectangle4,
                        child: const Icon(
                          Icons.remove,
                          size: 20,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2),
                      child: Text("${item.quantity}", style: titleStyle),
                    ),
                    Card(
                      margin: const EdgeInsets.only(right: 0),
                      shape: roundedRectangle4,
                      color: primaryColor,
                      child: InkWell(
                        onTap: addItemToCard,
                        splashColor: Colors.white70,
                        customBorder: roundedRectangle4,
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  int quantity() {
    var items = ref.read(cartDataProv).items;
    for (CartItem item in items) {
      if (item.food == food) {
        return item.quantity;
      }
    }
    return 0;
  }

  addItemToCard() {
    ref.read(cartDataProv).addItem(CartItem(food: food, quantity: 1));
    setState(() {});
  }

  removeItemfromCard() {
    ref.read(cartDataProv).removeItem(CartItem(food: food, quantity: 0));
    setState(() {});
  }
}
