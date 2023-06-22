import 'package:admin/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import '../handlers/google_maps.dart';
import '../Models/place_search.dart';
import 'Authentication&Oboard/new_outlet.dart';

class Maps extends ConsumerStatefulWidget {
  final LatLng? loc;
  const Maps({Key? key, this.loc}) : super(key: key);

  @override
  ConsumerState<Maps> createState() => _MapsState();
}

class _MapsState extends ConsumerState<Maps> {
  late GoogleMapController myController;
  LatLng? curLocation;
  String? address;
  PlaceSearch? predictions;
  bool isSearchScreen = false;
  TextEditingController serachController = TextEditingController();
  FocusNode serachBarFocus = FocusNode();

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();
    getLiveLocation();
  }

  getLiveLocation() async {
    if (widget.loc != null) {
      curLocation = widget.loc;
    } else {
      final Position position = await GoogleMapsHandler().determinePosition();
      curLocation = LatLng(position.latitude, position.longitude);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 100,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                  onPressed: () {
                    if (address != null) {
                      ref.read(venueDataProv).setAddress(
                          TextEditingController(text: address),
                          curLocation!.latitude.toString(),
                          curLocation!.longitude.toString());
                    }
                    Navigator.pop(context,true);
                  },
                  child: const Text("Done",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black))),
            )
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Select Location",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  Colors.green,
                ]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 120, bottom: 20, left: 15, right: 15),
            child: curLocation == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: <Widget>[
                      isSearchScreen
                          ? searchScreen()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: true,
                                myLocationButtonEnabled: false,
                                onCameraMove: (position) {
                                  setState(() {
                                    curLocation = position.target;
                                  });
                                },
                                onCameraIdle: () async {
                                  try {
                                    GeoData data =
                                        await Geocoder2.getDataFromCoordinates(
                                            latitude: curLocation!.latitude,
                                            longitude: curLocation!.longitude,
                                            googleMapApiKey:
                                                "AIzaSyBg-zP2SI88okiEVVRv7v9Awp76BCUKswA");
                                    address = data.address;
                                    setState(() {});
                                  } catch (e) {
                                    if (kDebugMode) {
                                      print(e.toString());
                                    }
                                  }
                                },
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(curLocation!.latitude,
                                      curLocation!.longitude),
                                  zoom: 15.0,
                                ),
                              ),
                            ),
                      Visibility(
                        visible: !isSearchScreen,
                        child: const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.pin_drop,
                              size: 50,
                              color: Colors.red,
                            )),
                      ),
                      Visibility(
                        visible: !isSearchScreen,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(12),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Location",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(address ?? "Your Address",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(12),
                          ),
                          child: TextFormField(
                            focusNode: serachBarFocus,
                            controller: serachController,
                            onChanged: (value) async {
                              predictions = await GoogleMapsHandler()
                                  .getAutocomplete(value);
                              setState(() {});
                            },
                            onTap: () {
                              isSearchScreen = true;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              fillColor: Colors.grey,
                              hintText: "Search for a place or address",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget searchScreen() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              isSearchScreen = false;
              serachBarFocus.unfocus();
              await getLiveLocation();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text("Use Current Location",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff71C0BD))),
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Color(0xff71C0BD),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount:
                    predictions == null ? 0 : predictions!.predictions.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        dynamic codes = await GoogleMapsHandler()
                            .getCoordinatesFromPlaceID(
                                predictions!.predictions[index].placeId);
                        curLocation = LatLng(codes['lat'], codes['lng']);
                        setState(() {
                          isSearchScreen = false;
                          serachController.clear();
                          serachBarFocus.unfocus();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff71C0BD),
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                  predictions!.predictions[index].description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
