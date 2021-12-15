// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';

class CashCard extends StatelessWidget {
  final IconData iconData;
  final double amount;
  const CashCard({
    Key? key,
    required this.width,
    required this.iconData,
    required this.amount,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        width: (width / 2) - 20,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "₹ ${MyHomePage.currencyFormat.format(amount)}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ));
  }
}
