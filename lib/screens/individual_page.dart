import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:palets_app/components/cash_card.dart';
import 'package:palets_app/components/chat_card.dart';
import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/screens/home.dart';
import 'package:palets_app/screens/user_report.dart';
import 'package:palets_app/services/database_helper.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import 'package:palets_app/models/user_model.dart';

import '../main.dart';

class IndividualPage extends StatefulWidget {
  final UserModel userModel;
  const IndividualPage({Key? key, required this.userModel}) : super(key: key);

  @override
  _IndividualPageState createState() => _IndividualPageState();
  static var currencyFormat = NumberFormat("###0.00#");
}

class _IndividualPageState extends State<IndividualPage> {
  bool isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _state = TextEditingController();
  var now = DateTime.now();
  var formatter = DateFormat('dd/MM/yyyy');
  var formatterSQl = DateFormat('yyyy-MM-dd');
  List<ChatModel> chatList = [];
  static var formattedSql;

  double receiptSum = 0;
  double paymentSum = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    formattedSql = formatterSQl.format(selectedDate);
    _date.text = MyHomePage.dateFormatter
        .format(DateTime.parse(selectedDate.toString()));
    getChats(widget.userModel.id!.toInt());
  }

  void getChats(int id) async {
    chatList = await DatabaseHelper.instance.getChat(id);
    setState(() {
      isLoading = false;
    });
    for (int i = 0; i < chatList.length; i++) {
      if (chatList[i].transactionType == "Payment") {
        paymentSum += double.parse(chatList[i].amount.toString());
      } else {
        receiptSum += double.parse(chatList[i].amount.toString());
      }
    }
    widget.userModel.type == 'CUSTOMER'
        ? total = paymentSum - receiptSum
        : total = receiptSum - paymentSum;

    // var response2 = await networkHandler.put('/api/party/closingbal', {
    //   "closingbal": total.toString(),
    //   "last_date": DateFormat.yMd().format(selectedDate),
    //   "id": widget.userModel.id
    // });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedSql = formatterSQl.format(selectedDate);
        selectedDate = picked;
        _date.text = MyHomePage.dateFormatter
            .format(DateTime.parse(selectedDate.toString()));
        // MyHomePage.dateFormatter.format(DateTime.parse(chatModel.date.toString()))
      });
    }
  }

  Future<void> showInformationDialog(
      {required BuildContext context,
      String? transactionType,
      String? party,
      int? id,
      int? invoice,
      required String billStatus,
      required String amount,
      required String state,
      required String description}) async {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            if (billStatus == 'edit') {
              setState(() {
                _amount.text = amount;
                _state.text = state;
                _description.text = description;
              });
            }
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                            clear();
                          },
                          child: const CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: kPrimaryColor,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 40),
                              child: TextFormField(
                                validator: (value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : "Enter amount";
                                },
                                controller: _amount,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: '₹ ',
                                  alignLabelWithHint: true,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _date,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                onTap: () {
                                  _selectDate(context);
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Date ',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _state,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'State',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _description,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  hintText: 'Description(Optional) ',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: const Text("Submit"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ChatModel chatModel = billStatus == 'new'
                                        ? ChatModel(
                                            user: 'Admin',
                                            transactionType: transactionType,
                                            amount: double.parse(_amount.text),
                                            date: DateTime.parse(formattedSql),
                                            description: _description.text,
                                            party: party,
                                            state: _state.text,
                                            partyID: widget.userModel.id,
                                            time: MyHomePage.timeFormatter
                                                .format(now),
                                          )
                                        : ChatModel(
                                            inv: invoice,
                                            transactionType: transactionType,
                                            party: party,
                                            user: 'Admin',
                                            partyID: widget.userModel.id,
                                            amount: double.parse(_amount.text),
                                            date: DateTime.parse(formattedSql),
                                            description: _description.text,
                                            state: _state.text,
                                            time: MyHomePage.timeFormatter
                                                .format(now),
                                          );
                                    billStatus == 'new'
                                        ? await DatabaseHelper.instance
                                            .addChat(chatModel: chatModel)
                                        : await DatabaseHelper.instance
                                            .updateChat(chatModel: chatModel);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IndividualPage(
                                              userModel: widget.userModel)),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: billStatus == 'new'
                                            ? Text(
                                                "Added $transactionType successfully")
                                            : Text(
                                                "Updated $transactionType successfully"),
                                      ),
                                    );
                                    clear();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF5F0FA),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 64,
        titleSpacing: 5,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              await showInformationDialog(
                  context: context,
                  id: widget.userModel.id,
                  transactionType: 'Receipt',
                  party: widget.userModel.name,
                  billStatus: 'new',
                  amount: '',
                  description: '',
                  state: '');
            },
            label: Text("Receipt"),
            icon: Icon(Icons.arrow_downward_outlined),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await showInformationDialog(
                  context: context,
                  id: widget.userModel.id,
                  transactionType: 'Payment',
                  billStatus: 'new',
                  party: widget.userModel.name,
                  amount: '',
                  description: '',
                  state: '');
            },
            label: Text("Payment"),
            icon: Icon(Icons.arrow_upward_outlined),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                height: 15,
                padding: EdgeInsets.all(0),
                child: ListTile(
                  minVerticalPadding: 0,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserReport(
                            id: widget.userModel.id!.toInt(),
                            userType: widget.userModel.type),
                      ),
                    );
                  },
                  dense: true,
                  leading: Icon(Icons.description),
                  title: Text('Report'),
                ),
              ),
            ],
          )
        ],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              CircleAvatar(
                child: Text(widget.userModel.name[0].toUpperCase()),
              ),
            ],
          ),
        ),
        title: Tooltip(
          child: Text(widget.userModel.name),
          message: widget.userModel.name,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            decoration: const BoxDecoration(
              color: Color(0xffF5F0FA),
            ),
            child: Stack(
              children: [
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: chatList.length,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ChatCard(
                            width: width,
                            chatModel: chatList[index],
                            function: showInformationDialog,
                            userModel: widget.userModel,
                            balance: '$total',
                          );
                        })
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CashCard(
                width: width,
                iconData: Icons.arrow_circle_down_rounded,
                amount: receiptSum,
              ),
              CashCard(
                width: width,
                iconData: Icons.arrow_circle_up_rounded,
                amount: paymentSum,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  width: (width - 10),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.swap_vertical_circle_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Balance  :  ₹ ${IndividualPage.currencyFormat.format(total)}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clear() {
    _amount.text = "";
    _state.text = '';
    _description.text = '';
  }
}

// FutureBuilder(
// future: getCustomerChats(1),
// builder: (context, snapshot) {
// if (snapshot.hasData) {
// print("data is found");
// return ListView.builder(
// itemCount: chatListModel.data!.length,
// itemBuilder: (context, index) {
// return ChatCard(
// width: width,
// chatModel: chatListModel.data![index]);
// },
// );
// } else {
// return Center(child: CircularProgressIndicator());
// }
// })
