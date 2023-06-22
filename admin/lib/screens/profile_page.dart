import 'package:admin/models/merchart.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String _photoUrl = ''; // Variable to store the fetched photo URL
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    fetchMerchantData(); // Fetch merchant data when the page initializes
    fetchMerchantPhotoUrl().then((url) {
      setState(() {
        _photoUrl = url;
      });
    });

    // Set initial values for the text fields
    _nameController.text = 'Restaurant Name';
    _descriptionController.text = 'Description of the restaurant';
    _addressController.text = 'Restaurant Address';

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

  Future<List<Merchant>> fetchMerchantData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Merchants').get();

    List<Merchant> shops = snapshot.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Merchant(
        name: data['name'],
        description: data['description'],
        photoUrl: data['image'],
        placeId: data['address'],
      );
    }).toList();

    if (shops.isNotEmpty) {
      // If there are merchant records, update the text fields with the first merchant's data
      setState(() {
        _nameController.text = shops[0].name!;
        _descriptionController.text = shops[0].description!;
        _addressController.text = shops[0].placeId!;
      });
    }

    return shops;
  }

  Future<String> fetchMerchantPhotoUrl() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Merchants')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['photoUrl'];
    }

    return '';
  }

  void _textFieldListener() {
    setState(() {
      _hasChanges = true;
    });
  }

  void _saveChanges() {
    // Save the changes to Firestore
    String name = _nameController.text;
    String description = _descriptionController.text;
    String address = _addressController.text;

    FirebaseFirestore.instance
        .collection('Merchants')
        .doc(FirebaseAuth.instance.currentUser!.uid) // Replace with the document ID of your merchant data
        .update({
      'name': name,
      'description': description,
      'address': address,
    }).then((value) {
      setState(() {
        _hasChanges = false;
        FocusScope.of(context).unfocus(); // Remove cursor
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes. Please try again.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (_hasChanges)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 189, 217, 231),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _photoUrl.isNotEmpty
                    ? Image.network(
                        _photoUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.asset(
                        "assets/images/cafe.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            SizedBox(height: 5),
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
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Add Images',
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
              padding: EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}
