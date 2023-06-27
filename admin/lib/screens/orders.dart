import 'package:admin/screens/popscreen.dart';
import 'package:admin/smallfont.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: SizedBox(
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / 2;

                return Stack(
                  children: [
                    Positioned(
                      left: _currentPageIndex * itemWidth,
                      bottom: 0,
                      child: Container(
                        width: itemWidth,
                        height: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              height: 48.0,
                              alignment: Alignment.center,
                              child: const Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              height: 48.0,
                              alignment: Alignment.center,
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: const [
          PendingScreen(),
          CompletedScreen(),
        ],
      ),
    );
  }
}

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key});

 void showBillBottomSheet(BuildContext context, String orderId) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching ordered items',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              final orderedItems = snapshot.data?.get('Ordered Items');
              final totalAmount = snapshot.data?.get('Total Price');
              
              return Container(
                height: 500,
                color: Color.fromARGB(255, 2, 54, 37),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'Ordered Items',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: orderedItems != null && orderedItems.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderedItems.length,
                                itemBuilder: (context, index) {
                                  final item = orderedItems[index];
                                  final name = item['name'];
                                  final quantity = item['quantity'];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(221, 220, 242, 236),
                                        borderRadius: BorderRadius.circular(10),
                                        
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Quantity: $quantity',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'No ordered items',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.teal,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Payment Status: Paid Online',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.teal,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Total Amount: $totalAmount",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
      width: double.maxFinite,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orderList = snapshot.data?.docs;
            if (orderList != null && orderList.isNotEmpty) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data?.docs[index]['Resturant Id'] ==
                      FirebaseAuth.instance.currentUser?.uid) {
                    String orderId = snapshot.data!.docs[index].id;
                    String orderStatus =
                        snapshot.data!.docs[index]['Order Status'];

                    if (orderStatus == 'Order Completed') {
                      return SizedBox.shrink();
                    }

                    return Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 180,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                    0,
                                    3,
                                  ), // changes the shadow direction vertically
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15 * 3.5,
                                ),
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.food_bank),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallFont(
                                          text: snapshot.data?.docs[index]
                                              ['Address']['name'],
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(
                                          height: 10 / 3,
                                        ),
                                        SmallFont(
                                          text: snapshot.data?.docs[index]
                                                  ['Address']['address'] +
                                              " , " +
                                              snapshot.data?.docs[index]
                                                  ['Address']['streetName'] +
                                              " , " +
                                              snapshot.data?.docs[index]
                                                  ['Address']['city'],
                                          fontWeight: FontWeight.w600,
                                          size: 12,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                         showBillBottomSheet(context,orderId);
                                      },
                                      child: Container(
                                        height: 25 + 10 / 1.3,
                                        width: 40 * 4.7,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            91,
                                            169,
                                            161,
                                          ).withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: SmallFont(
                                            text:
                                                "Total No of Items ${snapshot.data?.docs[index]['Ordered Items'].length}",
                                            size: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => MyPopupScreen(
                                            orderId: orderId,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 25 + 10 / 1.3,
                                        width: 15 * 4.7,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            104,
                                            212,
                                            122,
                                          ).withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: SmallFont(
                                            text: "Accept",
                                            size: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 10 / 1.5,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 132, 203, 203),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            height: 20 * 2.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SmallFont(
                                  text: snapshot.data?.docs[index]
                                      ['Order Status'],
                                  color: Colors.teal[900],
                                  fontWeight: FontWeight.w600,
                                  size: 10 + 10 / 5,
                                ),
                                const SizedBox(
                                  height: 10 / 2,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.timelapse,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 10),
                                    SmallFont(
                                      text: DateFormat(
                                        'ddth MMMM yyyy   hh:mm aa',
                                      ).format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data?.docs[index]
                                              ['Order Id'],
                                        ),
                                      ),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            } else {
              return Center(
                child: Text(
                  'No pending orders',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key});

  void showBillBottomSheet(BuildContext context, String orderId) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 500,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching ordered items',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              final orderedItems = snapshot.data?.get('Ordered Items');
              final totalAmount = snapshot.data?.get('Total Price');
              
              return Container(
                height: 500,
                color: Color.fromARGB(255, 2, 54, 37),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'Ordered Items',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: orderedItems != null && orderedItems.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderedItems.length,
                                itemBuilder: (context, index) {
                                  final item = orderedItems[index];
                                  final name = item['name'];
                                  final quantity = item['quantity'];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(221, 220, 242, 236),
                                        borderRadius: BorderRadius.circular(10),
                                        
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Quantity: $quantity',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'No ordered items',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.teal,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Payment Status: Paid Online',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.teal,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Total Amount: $totalAmount",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
      width: double.maxFinite,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orderList = snapshot.data?.docs;
            if (orderList != null && orderList.isNotEmpty) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data?.docs[index]['Resturant Id'] ==
                      FirebaseAuth.instance.currentUser?.uid) {
                        String orderId = snapshot.data!.docs[index].id;
                    String orderStatus =
                        snapshot.data!.docs[index]['Order Status'];

                    if (orderStatus != 'Order Completed') {
                      return SizedBox.shrink();
                    }

                    return Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 180,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15 * 3.5,
                                ),
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.food_bank),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallFont(
                                          text: snapshot.data?.docs[index]
                                              ['Address']['name'],
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(
                                          height: 10 / 3,
                                        ),
                                        SmallFont(
                                          text: snapshot.data?.docs[index]
                                                  ['Address']['address'] +
                                              " , " +
                                              snapshot.data?.docs[index]
                                                  ['Address']['streetName'] +
                                              " , " +
                                              snapshot.data?.docs[index]
                                                  ['Address']['city'],
                                          fontWeight: FontWeight.w600,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showBillBottomSheet(context,orderId);
                                      },
                                      child: Container(
                                        height: 25 + 10 / 1.3,
                                        width: 40 * 4.7,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                                  255, 91, 169, 161)
                                              .withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: SmallFont(
                                            text:
                                                "Total No of Items ${snapshot.data?.docs[index]['Ordered Items'].length}",
                                            size: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25 + 10 / 1.3,
                                      width: 15 * 4.7,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 27, 7, 80)
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: SmallFont(
                                          text: "Completed",
                                          size: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 10 / 1.5,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 132, 203, 203),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            height: 20 * 2.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SmallFont(
                                  text: snapshot.data?.docs[index]
                                      ['Order Status'],
                                  color: Colors.teal[900],
                                  fontWeight: FontWeight.w600,
                                  size: 10 + 10 / 5,
                                ),
                                const SizedBox(
                                  height: 10 / 2,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.timelapse,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 10),
                                    SmallFont(
                                      text: DateFormat(
                                              'ddth MMMM yyyy   hh:mm aa')
                                          .format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data?.docs[index]
                                              ['Order Id'],
                                        ),
                                      ),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No completed orders',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
