import 'dart:ui';
import 'package:palets_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:palets_app/screens/home.dart';
import 'package:palets_app/services/database_helper.dart';
import '../constants.dart';
import '../main.dart';
import '../screens/individual_page.dart';

class UserTile extends StatelessWidget {
  final UserModel userModel;
  bool isMainPage;
  Future<void> Function(
      {required BuildContext context,
      required String status,
      required String name,
      required String phone,
      required String address,
      required String route,
      required int id})? function;
  UserTile({
    Key? key,
    required this.userModel,
    required this.isMainPage,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SimpleDialog dialog = SimpleDialog(
      children: [
        SimpleDialogOption(
          child: const Text(
            "Edit",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            function!(
                context: context,
                name: userModel.name,
                phone: userModel.phone.toString(),
                route: userModel.route.toString(),
                address: userModel.address.toString(),
                status: 'Edit',
                id: userModel.id!.toInt());
          },
        ),
        SimpleDialogOption(
            child: const Text(
              "Delete",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await DatabaseHelper.instance
                  .deleteUser(id: userModel.id!.toInt());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Deleted party successfully"),
                ),
              );
              userModel.type == 'CUSTOMER'
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Home(
                                index: 1,
                              )),
                    )
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Home(
                                index: 2,
                              )),
                    );
            }),
        SimpleDialogOption(
          child: const Text(
            "Report",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          onLongPress: () {
            isMainPage
                ? showDialog<void>(
                    context: context, builder: (context) => dialog)
                : null;
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualPage(
                          userModel: userModel,
                        )));
          },
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          leading: CircleAvatar(
            child: Text(userModel.name[0].toUpperCase()),
          ),
          title: Text(
            userModel.name,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.done,
                size: 18,
              ),
              Text(userModel.route.toString()),
            ],
          ),
          tileColor: kPrimaryLightColor,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₹ ${MyHomePage.currencyFormat.format(double.parse(userModel.closingBalance))}',
                style: const TextStyle(
                    color: Color(0xDF107610),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(MyHomePage.dateFormatter
                  .format(DateTime.parse(userModel.createDate.toString()))),
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 0,
        ),
      ],
    );
  }
}
