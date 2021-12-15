import 'package:flutter/material.dart';
import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/screens/user_report.dart';

class BalanceCell extends StatelessWidget {
  final ChatModel chatModel;
  double balance;
  final String userType;
  BalanceCell({
    Key? key,
    required this.chatModel,
    required this.balance,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType == 'SUPPLIER') {
      chatModel.transactionType.toString() == 'Receipt'
          ? balance += double.parse(chatModel.amount.toString())
          : balance -= double.parse(chatModel.amount.toString());
    } else {
      chatModel.transactionType.toString() == 'Receipt'
          ? balance -= double.parse(chatModel.amount.toString())
          : balance += double.parse(chatModel.amount.toString());
    }
    print("bal: $balance");
    print("main bal: ${UserReport.mainbalance}");
    UserReport.mainbalance += balance;
    return Text(UserReport.mainbalance.toString());
  }
}
