import 'package:flutter/material.dart';
import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/screens/individual_page.dart';
import 'package:screenshot/screenshot.dart';

class NewBillCard extends StatelessWidget {
  ScreenshotController controller = ScreenshotController();
  final ChatModel chatModel;
  final String name;
  final String address1;
  final String address2;
  final String phone;
  final String pin;
  final String? balance;
  NewBillCard({
    Key? key,
    required this.controller,
    required this.chatModel,
    required this.name,
    required this.address1,
    required this.address2,
    required this.phone,
    required this.pin,
    this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.purple,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(address1,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        Text(address2,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        Text('Pin:$pin Phone: $phone',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                    width: double.infinity,
                  ),
                  Text(
                    chatModel.transactionType.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    chatModel.party.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Old Balance: ₹ ${IndividualPage.currencyFormat.format(double.parse(balance.toString()) + chatModel.amount!.toDouble())}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    " ₹ ${IndividualPage.currencyFormat.format(double.parse(chatModel.amount.toString()))}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "New Balance: ₹ ${IndividualPage.currencyFormat.format(double.parse(balance.toString()))}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${chatModel.date!.day.toString()}/${chatModel.date!.month.toString()}/${chatModel.date!.year.toString()}  ${chatModel.time}"),
                      ),
                    ),
                  ),
                  // Chip(
                  //   label: Text("15/10/2021  11:30 AM"),
                  //   backgroundColor: Colors.grey.shade100,
                  // ),
                  Text(
                    chatModel.description.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
