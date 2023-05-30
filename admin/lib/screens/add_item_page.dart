import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemAdd extends StatefulWidget {
  const ItemAdd(
      {super.key,
      required this.isEdit,
      this.itemName,
      this.itemPrice,
      this.description,
      this.isVeg,
      this.imageLink,
      this.itemId,
      this.category});
  final bool isEdit;
  final String? itemId;
  final String? itemName;
  final int? itemPrice;
  final bool? isVeg;
  final String? category;
  final String? imageLink;
  final String? description;

  @override
  State<ItemAdd> createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  List? items;
  List? itemIdList;
  String? selectedValue;
  bool isLoading = true;
  String? itemName;
  int? itemPrice;
  bool isVeg = true;
  String imageLink =
      "https://images.everydayhealth.com/images/diet-nutrition/34da4c4e-82c3-47d7-953d-121945eada1e00-giveitup-unhealthyfood.jpg?sfvrsn=a31d8d32_0";
  String? description;
  final _itemIdController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemImageController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  final _newCategoryController = TextEditingController();

  List<String> categorylist = ["Indian", "Chinese"];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _itemIdController.text = widget.itemId!;
      _itemNameController.text = widget.itemName!;
      _itemPriceController.text = widget.itemPrice!.toString();
      selectedValue = widget.category;
      isVeg = widget.isVeg!;
      _itemImageController.text = widget.imageLink!;
      _itemDescriptionController.text = widget.description!;
    } else {
      generateItemId();
    }
    getcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Items",
        ),
        actions: [
          IconButton(
              onPressed: displayTextInputDialog, icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _itemIdController,
                        decoration: const InputDecoration(
                            hintText: "Item Id",
                            hintStyle: TextStyle(color: Colors.black54)),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _itemNameController,
                        decoration: const InputDecoration(
                            hintText: "Item Name",
                            hintStyle: TextStyle(color: Colors.black54)),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          itemName = value;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _itemPriceController,
                        decoration: const InputDecoration(
                            hintText: "Item Price",
                            hintStyle: TextStyle(color: Colors.black54)),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          itemPrice = int.parse(val);
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          items: categorylist
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_rubl_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ChoiceChip(
                      label: Text(
                        "Veg",
                        style: TextStyle(
                            fontSize: 16,
                            color: isVeg ? Colors.white : Colors.black),
                      ),
                      selected: isVeg ? true : false,
                      selectedColor: Colors.green,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            isVeg = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ChoiceChip(
                      label: Text(
                        "Non Veg",
                        style: TextStyle(
                            fontSize: 16,
                            color: !isVeg ? Colors.white : Colors.black),
                      ),
                      selected: !isVeg ? true : false,
                      selectedColor: Colors.red,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            isVeg = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        CupertinoIcons.money_dollar_circle,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _itemImageController,
                        decoration: const InputDecoration(
                            hintText: "Select Image",
                            hintStyle: TextStyle(color: Colors.black54)),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          try {} catch (e) {}
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.description_rounded,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _itemDescriptionController,
                        decoration: const InputDecoration(
                            hintText: "Item Description",
                            hintStyle: TextStyle(color: Colors.black54)),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        maxLength: 100,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await addItem();
                      if (!mounted) return;
                      widget.isEdit ? Navigator.pop(context) : {};
                    },
                    child: Text(
                      widget.isEdit ? "Update" : "Add",
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
            ),
    );
  }

  getcategories() async {
    await FirebaseFirestore.instance
        .collection("Catagories")
        .get()
        .then((value) => items = value.docs.map((e) => e.id).toList());
    items!.removeWhere((element) => element == "All");
    isLoading = false;
    setState(() {});
  }

  generateItemId() async {
    await FirebaseFirestore.instance
        .collection("Merchants")
        .doc("FirebaseAuth.instance.currentUser!.uid")
        .collection("Menu")
        .get()
        .then((value) => itemIdList = value.docs.map((e) => e.id).toList());
    // if (itemIdList!.isEmpty) {
    //   itemIdList!.add("99");
    // }
    _itemIdController.text =
        (int.parse(itemIdList?[itemIdList!.length - 1]) + 1).toString();
  }

  Future addItem() async {
    // bool checkItemId = await FirebaseFirestore.instance
    //     .collection("Merchants")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("Menu")
    //     .doc(_itemIdController.text)
    //     .get()
    //     .then((value) => value.exists);
    // if (widget.isEdit) {
    //   checkItemId = false;
    // }
    if (false) {
      Fluttertoast.showToast(
          msg: "Item Id already Exits",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (selectedValue == null ||
          _itemNameController.text.isEmpty ||
          _itemPriceController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Fill Properly",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print("Xyz");
        await FirebaseFirestore.instance
            .collection("Merchants")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Menu")
            .doc(_itemIdController.text)
            .set({
          "id": _itemIdController.text,
          "description": _itemDescriptionController.text,
          "image": _itemImageController.text.isEmpty
              ? imageLink
              : _itemImageController.text,
          "name": _itemNameController.text,
          "category": selectedValue,
          "veg": isVeg,
          "price": int.parse(_itemPriceController.text)
        }).whenComplete(() => Fluttertoast.showToast(
                        msg: "Item Added",
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0)
                    .then((value) async {
                  _itemDescriptionController.clear();
                  _itemIdController.clear();
                  _itemImageController.clear();
                  _itemNameController.clear();
                  _itemPriceController.clear();
                  //await generateItemId();
                  setState(() {});
                }));
      }
    }
  }

  displayTextInputDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter New Category'),
            content: TextField(
              controller: _newCategoryController,
              decoration: const InputDecoration(hintText: "Category Name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("Catagories")
                    ..doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Menu")
                        .doc(_itemIdController.text)
                        .set({});
                  setState(() {
                    getcategories();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
