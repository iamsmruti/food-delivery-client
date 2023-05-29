import 'package:flutter/material.dart';

import '../Models/cart_model.dart';
import '../constant.dart';

Widget buildCartItem(
    MyCart cart, CartItem cartModel, AnimationController animationController) {
  return Row(
    children: [
      Expanded(
        child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: secondaryColor,
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Image.network(
                    cartModel.food.image,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cartModel.food.name,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: Text(
                        '₹${cartModel.food.price}',
                        style: titleStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          margin: const EdgeInsets.only(right: 0),
                          shape: roundedRectangle4,
                          color: primaryColor,
                          child: InkWell(
                            onTap: () {
                              cart.decreaseItem(cartModel);
                              animationController.reset();
                              animationController.forward();
                            },
                            splashColor: Colors.white70,
                            customBorder: roundedRectangle4,
                            child: const Icon(
                              Icons.remove,
                              size: 20,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child:
                              Text('${cartModel.quantity}', style: titleStyle),
                        ),
                        Card(
                          margin: const EdgeInsets.only(right: 0),
                          shape: roundedRectangle4,
                          color: primaryColor,
                          child: InkWell(
                            onTap: () {
                              cart.increaseItem(cartModel);
                              animationController.reset();
                              animationController.forward();
                            },
                            splashColor: Colors.white70,
                            customBorder: roundedRectangle4,
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          cart.removeAllInCart(cartModel.food);
          animationController.reset();
          animationController.forward();
        },
        customBorder: roundedRectangle12,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.delete_sweep, size: 30, color: Colors.red),
        ),
      )
    ],
  );
}
