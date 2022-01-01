import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/models/user_model.dart';
import 'package:palets_app/screens/home.dart';
import 'package:palets_app/screens/individual_page.dart';
import 'package:palets_app/services/database_helper.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import '../constants.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import 'new_bill_card.dart';

class ChatCard extends StatelessWidget {
  final String? balance;
  final ChatModel chatModel;
  final UserModel userModel;
  final Future<void> Function(
      {required BuildContext context,
      String? transactionType,
      String? party,
      int? id,
      int? invoice,
      required String billStatus,
      required String amount,
      required String state,
      required String description}) function;

  const ChatCard({
    Key? key,
    required this.width,
    required this.chatModel,
    required this.function,
    required this.userModel,
    this.balance,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final SimpleDialog dialog = SimpleDialog(
      children: [
        SimpleDialogOption(
          child: Text(
            "Edit",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
            function(
              context: context,
              transactionType: chatModel.transactionType,
              id: chatModel.partyID,
              invoice: chatModel.inv,
              amount: chatModel.amount.toString(),
              state: chatModel.state.toString(),
              description: chatModel.description.toString(),
              billStatus: 'edit',
            );
          },
        ),
        SimpleDialogOption(
          child: const Text(
            "Delete",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            await DatabaseHelper.instance
                .deleteChat(inv: chatModel.inv!.toInt());
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => IndividualPage(userModel: userModel)),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Deleted ${chatModel.transactionType}  successfully"),
              ),
            );
          },
        ),
        SimpleDialogOption(
          child: const Text(
            "Share",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);
            final controller = ScreenshotController();
            final data = await DatabaseHelper.instance.getCompany();
            final bytes = await controller.captureFromWidget(
              NewBillCard(
                controller: controller,
                chatModel: chatModel,
                name: data[0].name,
                address1: data[0].address1,
                address2: data[0].address2,
                phone: data[0].phone,
                balance: balance,
                pin: data[0].pin,
              ),
              context: context,
            );
            final appStorage = await getApplicationDocumentsDirectory();
            final file = File('${appStorage.path}/image.png');
            await file.writeAsBytes(bytes);
            await Share.shareFiles(
              ['${appStorage.path}/image.png'],
            );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => NewBillCard(
            //         controller: controller,
            //         chatModel: chatModel,
            //         name: data[0].name,
            //         address1: data[0].address1,
            //         address2: data[0].address2,
            //         phone: data[0].phone,
            //         balance: balance,
            //         pin: data[0].pin,
            //       ),
            //     ));
          },
        ),
        SimpleDialogOption(
          child: Text(
            "Print",
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            Navigator.pop(context);
            final controller = ScreenshotController();

            final data = await DatabaseHelper.instance.getCompany();
            final bytes = await controller.captureFromWidget(
              NewBillCard(
                controller: controller,
                chatModel: chatModel,
                name: data[0].name,
                address1: data[0].address1,
                address2: data[0].address2,
                phone: data[0].phone,
                balance: balance,
                pin: data[0].pin,
              ),
              context: context,
            );
            final image = pw.MemoryImage(bytes);
            final pdf = pw.Document();
            pdf.addPage(pw.Page(
                pageFormat: PdfPageFormat.undefined,
                build: (pw.Context context) {
                  return pw.Image(image);
                }));
            await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => pdf.save());
          },
        ),
      ],
    );
    return GestureDetector(
      onLongPress: () {
        showDialog<void>(
            context: context,
            builder: (context) => dialog,
            );
      },
      child: Align(
        alignment: chatModel.transactionType == 'Payment'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: width - 45, minWidth: width - 210),
          child: Card(
            color: chatModel.transactionType == 'Payment'
                ? kPrimaryLightColor2
                : kPrimaryLightColor3,
            borderOnForeground: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Stack(
              children: [
                Positioned(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chatModel.user.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Icon(
                        Icons.note_alt_outlined,
                        size: 20,
                      ),
                    ],
                  ),
                  right: 5,
                  top: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹ ${MyHomePage.currencyFormat.format(chatModel.amount)}",
                            style: TextStyle(
                                fontSize: 25,
                                color: chatModel.transactionType == 'Payment'
                                    ? Color(0xffD71D1D)
                                    : Color(0xff04724D),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "${chatModel.transactionType} \n ${chatModel.description}",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        MyHomePage.dateFormatter
                            .format(DateTime.parse(chatModel.date.toString())),

                        // chatModel.date.toString().substring(0, 10),
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "  ${chatModel.time}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
