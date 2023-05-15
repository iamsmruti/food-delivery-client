import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  String? searchQuery;

  Future getOutlets() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Center(
                    child: Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_UgZWvP.json',
                        width: 250,
                        height: 250,
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Search the Outlet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create one if you don\'t find yours',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color.fromARGB(255, 182, 182, 182)),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) => {searchQuery = value},
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                  prefixIcon: Icon(
                    Icons.search,
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
