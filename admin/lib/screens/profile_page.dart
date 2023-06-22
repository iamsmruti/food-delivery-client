import 'package:admin/Models/merchart.dart';
import 'package:admin/constants.dart';
import 'package:admin/screens/Authentication&Oboard/login_screen.dart';
import 'package:admin/screens/Authentication&Oboard/new_outlet.dart';
import 'package:admin/screens/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(); // Variable to store the fetched photo URL
  bool _hasChanges = false;
  String? _photoUrl;
  bool isLoading = true;
  bool isSaving = false;
  Merchant? shop;

  @override
  void initState() {
    super.initState();
    fetchMerchantData(); // Fetch merchant data when the page initializes
    // Add listeners to check for changes in the text fields
    _nameController.addListener(_textFieldListener);
    _descriptionController.addListener(_textFieldListener);
    _addressController.addListener(_textFieldListener);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  fetchMerchantData() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('Merchants')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    shop = Merchant(
        name: data['name'],
        description: data['description'],
        photoUrl: data['image'] ?? " ",
        placeId: data['address'],
        latitude: data['lat'],
        longitude: data['lng']);
    setState(() {
      _nameController.text = shop!.name!;
      _descriptionController.text = shop!.description!;
      _addressController.text = shop!.placeId!;
      _photoUrl = shop!.photoUrl == " "
          ? "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80"
          : shop!.photoUrl;
      isLoading = false;
    });
    ref.read(venueDataProv).clear();
  }

  void _textFieldListener() {
    setState(() {
      _hasChanges = true;
    });
  }

  void _saveChanges() {
    // Save the changes to Firestore
    setState(() {
      isSaving = true;
    });
    String name = _nameController.text;
    String description = _descriptionController.text;
    String address = _addressController.text;

    FirebaseFirestore.instance
        .collection('Merchants')
        .doc(FirebaseAuth.instance.currentUser!
            .uid) // Replace with the document ID of your merchant data
        .update({
      'name': name,
      'description': description,
      'address': address,
      'lat': double.parse(
          ref.read(venueDataProv).latitude ?? shop!.latitude.toString()),
      'lng': double.parse(
          ref.read(venueDataProv).longitude ?? shop!.longitude.toString())
    }).then((value) {
      setState(() {
        _hasChanges = false;
        isSaving = false;
        FocusScope.of(context).unfocus(); // Remove cursor
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to save changes. Please try again.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: primaryColor,
        actions: [
          if (_hasChanges)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 189, 217, 231),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                _photoUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                              onPressed: () {
                                // Add images functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  'Update Image',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Restaurant Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (_) => _textFieldListener(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _descriptionController,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (_) => _textFieldListener(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _addressController,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (_) => _textFieldListener(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          color: Colors.teal.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () async {
                              final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Maps(
                                            loc: LatLng(shop!.latitude!,
                                                shop!.longitude!),
                                          )));
                              if (res != null) {
                                shop!.latitude = double.parse(
                                    ref.read(venueDataProv).latitude!);
                                shop!.longitude = double.parse(
                                    ref.read(venueDataProv).longitude!);
                              }
                              setState(() {});
                            },
                            title: Text(
                              ref
                                      .read(venueDataProv)
                                      .venueController
                                      .text
                                      .isNotEmpty
                                  ? ref.read(venueDataProv).venueController.text
                                  : "Update Resturant Location",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) =>
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Log Out',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: isSaving,
                    child: Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                            color: Colors.grey.shade200.withOpacity(0.7),
                            child: const Center(
                                child: CircularProgressIndicator()))))
              ],
            ),
    );
  }
}
