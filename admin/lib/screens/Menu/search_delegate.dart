import 'package:flutter/material.dart';

import '../../Models/food.dart';
import '../../Widgets/food_widget.dart';
import '../../constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Food> data;
  CustomSearchDelegate({required this.data});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white, fontSize: 15)),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.white60),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: const Color(0xffF2F2F2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var name = data[index].name;
              if (name.toLowerCase().contains(query.toLowerCase())) {
                return buildFood(data[index], context);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: const Color(0xffF2F2F2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var name = data[index].name;
              if (name.toLowerCase().contains(query.toLowerCase())) {
                return buildFood(data[index], context);
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
