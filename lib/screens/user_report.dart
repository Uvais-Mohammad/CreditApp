import 'dart:convert' show utf8, jsonDecode;
import 'package:flutter/material.dart';
import 'package:palets_app/components/balance_cell.dart';
import 'package:palets_app/components/scrollable_widget.dart';
import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/services/database_helper.dart';
import 'package:palets_app/services/pdf_helper.dart';

import '../main.dart';

class UserReport extends StatefulWidget {
  final int id;
  final String userType;
  const UserReport({Key? key, required this.id, required this.userType})
      : super(key: key);
  static double mainbalance = 0.0;
  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  bool isLoading = true;
  double mainbalance = 0.0;
  int i = 0;
  double crTotal = 0.0;
  double drTotal = 0.0;
  List<ChatModel> chatList = [];
  void getUserChats(int id) async {
    final data = await DatabaseHelper.instance.getChat(id);
    setState(() {
      chatList = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      mainbalance = 0;
    });
    getUserChats(widget.id);
  }

  final columnspdf = [
    'SI No',
    'Inv No',
    'Date',
    'Party',
    'Dr',
    'Cr',
    'Balance'
  ];
  final columns = ['Inv No', 'Date', 'Party', 'Dr', 'Cr', 'Balance'];

  @override
  Widget build(BuildContext context) {
    setState(() {
      UserReport.mainbalance = 0.0;
    });
    Color getColor(Set<MaterialState> states) {
      return Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                UserReport.mainbalance = 0.0;
                i = 0;
                crTotal = 0.0;
                drTotal = 0.0;
              });
              var encoded = utf8.encode(chatList[1].party.toString());
              final data = chatList
                  .map((ChatModel chatModel) => [
                        serialNo(),
                        chatModel.inv,
                        (MyHomePage.dateFormatter
                            .format(DateTime.parse(chatModel.date.toString()))),
                        chatModel.transactionType,
                        drCalculation(chatModel: chatModel),
                        crCalculation(chatModel: chatModel),
                        balanceForPdf(
                            chatModel: chatModel, balance: mainbalance)
                      ])
                  .toList();
              print(data);
              final pdfFile = await PDFHelper.generateTable(
                  headers: columnspdf,
                  data: data,
                  party: encoded,
                  drTotal: drTotal,
                  crTotal: crTotal,
                  mainTotal: UserReport.mainbalance);
              print(pdfFile.path);
              await PDFHelper.openFile(pdfFile);
              // await Share.shareFiles([pdfFile.path],
              //     text: "check out my website https://example.com");
            },
            tooltip: 'Share as PDF',
            icon: Icon(Icons.share),
          )
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ScrollableWidget(
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith(getColor),
                columnSpacing: 20,
                columns: getColumns(columns),
                rows: getRows(chatList),
              ),
            ),
    );
  }

  double balanceForPdf(
      {required ChatModel chatModel, required double balance}) {
    chatModel.transactionType.toString() == 'Receipt'
        ? balance += double.parse(chatModel.amount.toString())
        : balance -= double.parse(chatModel.amount.toString());
    print("bal: $balance");
    print("main bal: ${UserReport.mainbalance}");
    UserReport.mainbalance += balance;
    return UserReport.mainbalance;
  }

  double crCalculation({required ChatModel chatModel}) {
    if (chatModel.transactionType == 'Receipt') {
      crTotal += chatModel.amount!.toDouble();
      return chatModel.amount!.toDouble();
    } else {
      return 0.0;
    }
  }

  double drCalculation({required ChatModel chatModel}) {
    if (chatModel.transactionType == 'Payment') {
      drTotal += chatModel.amount!.toDouble();
      return chatModel.amount!.toDouble();
    } else {
      return 0.0;
    }
  }

  String serialNo() {
    i++;
    return '$i';
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<ChatModel> chatListModel) => chatListModel
      .map(
        (ChatModel chatModel) => DataRow(cells: [
          DataCell(Text(chatModel.inv.toString())),
          DataCell(Text(
              '${(chatModel.date!.day + 1).toString()}-${chatModel.date!.month.toString()}-${chatModel.date!.year.toString()}')),
          DataCell(Text(chatModel.transactionType.toString())),
          DataCell(
            chatModel.transactionType.toString() == "Receipt"
                ? Text(chatModel.amount.toString())
                : Text("0.0"),
          ),
          DataCell(chatModel.transactionType.toString() == "Payment"
              ? Text(chatModel.amount.toString())
              : Text("0.0")),
          DataCell(
            BalanceCell(
              chatModel: chatModel,
              balance: mainbalance,
              userType: widget.userType,
            ),
          ),
        ]),
      )
      .toList();
}
