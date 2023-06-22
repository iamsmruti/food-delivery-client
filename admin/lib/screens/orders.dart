import 'package:admin/smallfont.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
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
          preferredSize: Size.fromHeight(48.0),
          child: Container(
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
                                duration: Duration(milliseconds: 300),
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
                                duration: Duration(milliseconds: 300),
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
        children: [
          PendingScreen(),
          CompletedScreen(),
        ],
      ),
    );
  }
}

class PendingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(10),
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
                        offset: Offset(
                            0, 3), // changes the shadow direction vertically
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15 * 3.5,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.food_bank)),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallFont(
                                text: "Dibya Ranjan Sahu",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: 10 / 3,
                              ),
                              SmallFont(
                                text: "C/99,Sector-7,Rourkela",
                                fontWeight: FontWeight.w600,
                                size: 12,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 25 + 10 / 1.3,
                            width: 40 * 4.7,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 91, 169, 161)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: SmallFont(
                              text: "Total No of Items 3",
                              size: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            )),
                          ),
                          Container(
                            height: 25 + 10 / 1.3,
                            width: 15 * 4.7,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 104, 212, 122)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: SmallFont(
                              text: "Accept",
                              size: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            )),
                          )
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
                  padding: EdgeInsets.only(left: 15, top: 10 / 1.5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 132, 203, 203),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  height: 20 * 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SmallFont(
                        text: "Order Recieved!",
                        color: Colors.teal[900],
                        fontWeight: FontWeight.w600,
                        size: 10 + 10 / 5,
                      ),
                      SizedBox(
                        height: 10 / 2,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            size: 15,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallFont(
                                text: "25th April 2023",
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                size: 10,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              SmallFont(
                                text: "7:30 PM",
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                size: 10,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: const Center(
        child: Text(
          'Completed',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
