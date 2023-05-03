import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'food.dart';

final cartDataProv = ChangeNotifierProvider<MyCart>((ref) => MyCart());

class MyCart extends ChangeNotifier {
  List<CartItem> items = [];
  List<CartItem> get cartItems => items;

  bool addItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.food.name == cart.food.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        notifyListeners();
        return true;
      }
    }

    items.add(cartItem);
    notifyListeners();
    return true;
  }

  void removeItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.food.name == cart.food.name) {
        if (cartItems[cartItems.indexOf(cart)].quantity <= 1) {
          removeAllInCart(cartItem.food);
          return;
        }
        cartItems[cartItems.indexOf(cart)].quantity--;
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  void decreaseItem(CartItem cartModel) {
    if (cartItems[cartItems.indexOf(cartModel)].quantity <= 1) {
      return;
    }
    cartItems[cartItems.indexOf(cartModel)].quantity--;
    notifyListeners();
  }

  void increaseItem(CartItem cartModel) {
    cartItems[cartItems.indexOf(cartModel)].quantity++;
    notifyListeners();
  }

  void removeAllInCart(Food food) {
    cartItems.removeWhere((f) {
      return f.food.name == food.name;
    });
    notifyListeners();
  }
}

class CartItem {
  Food food;
  int quantity;

  CartItem({required this.food, required this.quantity});
}
