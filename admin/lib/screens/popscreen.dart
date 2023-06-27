import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPopupScreen extends StatefulWidget {
  final String orderId;

  MyPopupScreen({required this.orderId});

  @override
  _MyPopupScreenState createState() => _MyPopupScreenState();
}

class _MyPopupScreenState extends State<MyPopupScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  List<String> _steps = ['Order Placed', 'Out for Delivery', 'Order Completed'];
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late String _orderStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey.withOpacity(0.4),
      end: Colors.green,
    ).animate(_animationController);
    fetchOrderStatus();
  }

  Future<void> fetchOrderStatus() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final orderSnapshot =
          await FirebaseFirestore.instance.collection("Orders").doc(widget.orderId).get();
      final orderData = orderSnapshot.data() as Map<String, dynamic>?;
      if (orderData != null && orderData.containsKey('Order Status')) {
        setState(() {
          _orderStatus = orderData['Order Status'];
          _currentStep = _steps.indexOf(_orderStatus);
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching order status: $error');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final orderRef =
          FirebaseFirestore.instance.collection("Orders").doc(orderId);
      await orderRef.update({'Order Status': newStatus});
      setState(() {
        _orderStatus = newStatus;
        _currentStep = _steps.indexOf(newStatus);
      });

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error updating order status: $error');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          height: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: 15.0,
                    height: 240.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 2),
                      color: _currentStep == _steps.length - 1 ? Colors.green : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < _steps.length; i++)
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentStep >= i ? Colors.green : Colors.grey.withOpacity(0.4),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    height: 240,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < _steps.length; i++)
                          Container(
                            child: Text(
                              _steps[i],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: _currentStep >= i ? Colors.green : Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  if (_currentStep < _steps.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                        onPrimary: Colors.white,
                      ),
                      onPressed: _isLoading ? null : () async {
                        final newStatus = _steps[_currentStep + 1]; // Get the new status
                        await updateOrderStatus(widget.orderId, newStatus);
                        _animationController.forward(from: 0.0);
                      },
                      child: _isLoading
                          ? CircularProgressIndicator() // Show circular progress indicator when loading
                          : Text(_steps[_currentStep + 1]),
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              if (_orderStatus != null)
                Text(
                  'Order Status: $_orderStatus', // Display the order status
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
