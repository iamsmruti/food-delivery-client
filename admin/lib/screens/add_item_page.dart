import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ItemAdd extends StatefulWidget {
  const ItemAdd(
      {super.key,
      required this.isEdit,
      this.itemName,
      this.itemPrice,
      this.description,
      this.isVeg,
      
      this.isAvailable,
      this.imageLink,
      this.itemId,
      this.category});
  final bool isEdit;
  final String? itemId;
  
  final String? itemName;
  final int? itemPrice;
  final bool? isVeg;
  final bool? isAvailable;
  final String? category;
  final String? imageLink;
  final String? description;

  @override
  State<ItemAdd> createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  List items = [];
  List itemIdList = [];
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
        title: widget.isEdit? const Text(
          "Update Item",
        ):const Text(
          "Add Item",
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
                          items: items
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
                        readOnly: true,
                        onTap: () {
                          if (Platform.isIOS) return;
                          selectImage();
                        },
                        controller: _itemImageController,
                        decoration: const InputDecoration(
                          hintText: "Select Image",
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {},
                      ),
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
        .collection("Merchants")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories")
        .get()
        .then((value) => items = value.docs.map((e) => e.id).toList());
    items.removeWhere((element) => element == "All");
    isLoading = false;
    setState(() {});
  }

Future<String> generateItemId() async {
  itemIdList.clear();
  await FirebaseFirestore.instance
      .collection("Merchants")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Menu")
      .get()
      .then((value) => itemIdList.addAll(value.docs.map((e) => e.id).toList()));
  String generatedItemId = itemIdList.isEmpty
      ? "100"
      : (int.parse(itemIdList[itemIdList.length - 1]) + 1).toString();

  _itemIdController.text = generatedItemId;
  return generatedItemId;
}


Future<void> addItem() async {
  bool checkItemId = await FirebaseFirestore.instance
      .collection("Merchants")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Menu")
      .doc(_itemIdController.text)
      .get()
      .then((value) => value.exists);

  // Disable itemId check for updates
  if (widget.isEdit) {
    checkItemId = false;
  }

  if (checkItemId) {
    Fluttertoast.showToast(
      msg: "Item Id already exists",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else if (selectedValue == null ||
      _itemNameController.text.isEmpty ||
      _itemPriceController.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Fill properly",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    // Prepare the data to be added or updated
    Map<String, dynamic> itemData = {
      "id": _itemIdController.text,
      "description": _itemDescriptionController.text,
      "image":
          _itemImageController.text.isEmpty ? imageLink : _itemImageController.text,
      "name": _itemNameController.text,
      "category": selectedValue,
      "veg": isVeg,
      "isAvailable": true,
      "price": int.parse(_itemPriceController.text),
    };

    try {
      if (widget.isEdit) {
        // Update existing item
        await FirebaseFirestore.instance
            .collection("Merchants")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Menu")
            .doc(widget.itemId)
            .update(itemData);
        Fluttertoast.showToast(
          msg: "Item Updated",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Add new item
        await FirebaseFirestore.instance
            .collection("Merchants")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Menu")
            .doc(_itemIdController.text)
            .set(itemData);
        Fluttertoast.showToast(
          msg: "Item Added",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      // Clear input fields and generate a new itemId
      _itemDescriptionController.clear();
      _itemIdController.clear();
      _itemImageController.clear();
      _itemNameController.clear();
      _itemPriceController.clear();
      await generateItemId();
      setState(() {});
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to ${widget.isEdit ? 'update' : 'add'} item: $error",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
                  FirebaseFirestore.instance
                      .collection("Merchants")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Categories")
                      .doc(_newCategoryController.text)
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

  void selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imageLink = await uploadImageToFirestore(image.path);
      _itemImageController.text = imageLink;
    }
  }

  Future<String> uploadImageToFirestore(String imagePath) async {
    String fileName = imagePath.split('/').last;
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask = ref.putFile(File(imagePath));
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
