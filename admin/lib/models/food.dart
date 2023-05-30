import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  Food({
    required this.image,
    required this.price,
    required this.name,
    required this.description,
    required this.id,
    required this.category,
    required this.isVeg,
    required this.isAvilable,
  });

  final String image;
  final int price;
  final String name;
  final String description;
  final String id;
  final String category;
  final bool isVeg;
  final bool isAvilable;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
      image: json["image"],
      price: json["price"],
      name: json["name"],
      description: json["description"],
      id: json["id"],
      category: json["category"],
      isVeg: json["veg"],
      isAvilable: json["isAvilable"]);

  static List<Food> foodList(QuerySnapshot json) {
    var data = json.docs
        .map(
          (e) => e.data(),
        )
        .toList();
    List<Food> list = [];
    for (dynamic vals in data) {
      list.add(Food(
          id: vals["id"],
          name: vals["name"],
          image: vals["image"],
          price: vals["price"],
          description: vals["description"],
          category: vals["category"],
          isVeg: vals["veg"],
          isAvilable: vals["isAvailable"] ?? false));
    }
    return list;
  }
}
