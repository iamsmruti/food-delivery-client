import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Models/address_model.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/handlers/location_handler.dart';

class AddressEdit extends StatefulWidget {
  final bool isEdit;
  const AddressEdit({super.key, required this.isEdit});

  @override
  State<AddressEdit> createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      Address address = Address.getAddress()!;
      nameController.text = address.name;
      addressController.text = address.address;
      streetNameController.text = address.streetName;
      phoneController.text = address.phoneNumber;
      cityController.text = address.city ?? "";
      stateController.text = address.state ?? "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Address",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: "name",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.home,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.recordingtape,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: streetNameController,
                  decoration: const InputDecoration(
                      hintText: "Street Name",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.recordingtape,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                      hintText: "City",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.recordingtape,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: stateController,
                  decoration: const InputDecoration(
                      hintText: "State",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  CupertinoIcons.phone,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.black54)),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    streetNameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  await LocationHanler().determinePosition().then((value) {
                    Address.addAddress(Address(
                        name: nameController.text,
                        address: addressController.text,
                        streetName: streetNameController.text,
                        latitude: value.latitude,
                        longitude: value.longitude,
                        phoneNumber: phoneController.text,
                        city: cityController.text,
                        state: stateController.text));
                    Navigator.pop(context,true);
                  });
                }
              },
              child: Text(
                widget.isEdit ? "Update" : "Add",
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
