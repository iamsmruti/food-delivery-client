import 'package:admin/constants.dart';
import 'package:admin/handlers/google_maps.dart';
import 'package:admin/models/place_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewOutlet extends StatefulWidget {
  const NewOutlet({super.key});

  @override
  State<NewOutlet> createState() => _NewOutletState();
}

class _NewOutletState extends State<NewOutlet> {
  bool isLoading = false;

  String? name;
  String? description;

  TextEditingController searchQueryController = TextEditingController();
  PlaceSearch? predictions;
  bool predictionWidget = false;
  double? latitude;
  double? longitude;

  submitData() async {
    if (name == '') {
      Fluttertoast.showToast(msg: 'Name can\'t be empty');
    } else if (description == '') {
      Fluttertoast.showToast(msg: 'Description can\'t be empty');
    } else if (searchQueryController.text == '') {
      Fluttertoast.showToast(msg: 'Location can\'t be empty');
    } else {
      FirebaseFirestore.instance
          .collection("Merchants")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": name,
        "description": description,
        "lat": latitude,
        "lng": longitude,
        "notif_token": await FirebaseMessaging.instance.getToken()
      }).whenComplete(() {
        Fluttertoast.showToast(msg: "Outlet Created Successfully");

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OutletScreen()),
        // );
      }).onError((error, _) {
        Fluttertoast.showToast(msg: "$error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Register New Outlet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              TextField(
                onChanged: (value) {
                  name = value;
                  setState(() {});
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Name',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Description',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) async {
                  predictions =
                      await GoogleMapsHandler().getAutocomplete(value);
                  setState(() {
                    predictionWidget = true;
                  });
                },
                controller: searchQueryController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Location',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                  prefixIcon: Icon(
                    Icons.location_searching,
                    color: Color.fromARGB(255, 182, 182, 182),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 182, 182, 182)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              predictionWidget
                  ? Container(
                      height: 200,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                          itemCount: predictions?.predictions.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () async {
                                  searchQueryController.text = predictions!
                                      .predictions[index].description;
                                  predictionWidget = false;
                                  setState(() {});
                                  dynamic coordinatesResult =
                                      await GoogleMapsHandler()
                                          .getCoordinatesFromPlaceID(
                                              predictions!
                                                  .predictions[index].placeId);
                                  latitude = coordinatesResult['lat'];
                                  longitude = coordinatesResult['lng'];
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                    predictions!.predictions[index].description,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              )),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              MaterialButton(
                minWidth: double.infinity,
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                onPressed: () async {
                  await submitData();
                },
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(color: primaryColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
