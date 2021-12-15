import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palets_app/components/scrollable_widget.dart';
import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/models/party_model.dart';
import 'package:palets_app/services/database_helper.dart';
import '../constants.dart';
import '../main.dart';

class DateWiseReport extends StatefulWidget {
  const DateWiseReport({Key? key}) : super(key: key);
  @override
  _DateWiseReportState createState() => _DateWiseReportState();
}

class _DateWiseReportState extends State<DateWiseReport> {
  double mainBalance = 0.0;
  bool isTableLoading = true;
  bool isLoading = true;
  final TextEditingController _date1 = TextEditingController();
  final TextEditingController _date2 = TextEditingController();
  var now = DateTime.now();
  var formatter = DateFormat('dd/MM/yyyy');
  var formatterSQl = DateFormat('yyyy-MM-dd');
  static var formattedSql1;
  static var formattedSql2;
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final _formatter = DateFormat('dd-MM-yyyy');
  final columns = ['SI No', 'Date', 'Inv No', 'Party', 'Amount'];
  String? routeDropdownValue;
  String? partyDropdownValue;
  List routeList = [];
  List<PartyModel> partyList = [];
  List<ChatModel> chatList = [];
  int serialNumber = 0;
  String val = 'transaction';

  Future<void> _selectDate(
      {required BuildContext context,
      required TextEditingController dateController,
      required DateTime selectedDate,
      required String flag}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        flag == '1'
            ? formattedSql1 = formatterSQl.format(selectedDate)
            : formattedSql2 = formatterSQl.format(selectedDate);
        dateController.text = _formatter.format(selectedDate);
      });
    }
  }

  void getCustomerChats({required String date1, required String date2}) async {
    setState(() {
      mainBalance = 0.0;
    });
    if (routeDropdownValue != null && partyDropdownValue != null) {
      chatList = await DatabaseHelper.instance.getReportRouteParty(
          date1: formattedSql1,
          date2: formattedSql2,
          route: routeDropdownValue.toString(),
          partyId: partyDropdownValue.toString(),
          type: val);
    } else if (routeDropdownValue != null) {
      chatList = await DatabaseHelper.instance.getReportRoute(
          date1: formattedSql1,
          date2: formattedSql2,
          route: routeDropdownValue.toString(),
          type: val);
    } else if (partyDropdownValue != null) {
      chatList = await DatabaseHelper.instance.getReportParty(
          date1: formattedSql1,
          date2: formattedSql2,
          partyId: partyDropdownValue.toString(),
          type: val);
    } else {
      chatList = await DatabaseHelper.instance
          .getReport(date1: formattedSql1, date2: formattedSql2, type: val);
    }
    setState(() {
      isTableLoading = false;
      isTableLoading = false;
    });
  }

  void getRouteList() async {
    routeList = await DatabaseHelper.instance.getRoutes();
  }

  void getPartyList() async {
    partyList = await DatabaseHelper.instance.getPartyList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    val = 'Receipt';
    _date1.text = _formatter.format(selectedDate1);
    _date2.text = _formatter.format(selectedDate2);
    formattedSql1 = formatterSQl.format(selectedDate1);
    formattedSql2 = formatterSQl.format(selectedDate2);
    getRouteList();
    getPartyList();
    getCustomerChats(date1: formattedSql1, date2: formattedSql2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DateWiseReport()));
            },
            tooltip: 'Reset',
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: TextFormField(
                textAlign: TextAlign.center,
                onTap: () async {
                  await _selectDate(
                      context: context,
                      dateController: _date1,
                      flag: '1',
                      selectedDate: selectedDate1);
                  print(formattedSql1);
                  print(formattedSql2);
                  setState(() {
                    isTableLoading = true;
                  });
                  getCustomerChats(date1: formattedSql1, date2: formattedSql2);
                },
                controller: _date1,
                showCursor: false,
                readOnly: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Select Date',
                  border: InputBorder.none,
                ),
              ),
            ),
            Text("-"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: TextFormField(
                textAlign: TextAlign.center,
                onTap: () async {
                  await _selectDate(
                      context: context,
                      flag: '2',
                      dateController: _date2,
                      selectedDate: selectedDate2);
                  print(formattedSql1);
                  print(formattedSql2);
                  setState(() {
                    isTableLoading = true;
                  });
                  getCustomerChats(date1: formattedSql1, date2: formattedSql2);
                },
                controller: _date2,
                showCursor: false,
                readOnly: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Select Date',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 'Receipt',
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value.toString();
                                serialNumber = 0;
                                isTableLoading = true;
                                getCustomerChats(
                                    date1: formattedSql1, date2: formattedSql2);
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text("Receipt"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Payment',
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                serialNumber = 0;
                                val = value.toString();
                                isTableLoading = true;
                                getCustomerChats(
                                    date1: formattedSql1, date2: formattedSql2);
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text("Payment"),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Container(
                            color: Colors.grey.shade300,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  onTap: () {},
                                  value: routeDropdownValue,
                                  hint: Text('Select route'),
                                  onChanged: (value) {
                                    setState(() {
                                      routeDropdownValue = value;
                                      isTableLoading = true;
                                      getCustomerChats(
                                          date1: formattedSql1,
                                          date2: formattedSql2);
                                    });
                                  },
                                  icon: (null),
                                  iconSize: 30,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  items: routeList
                                      .map<DropdownMenuItem<String>>(
                                          (dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Container(
                            color: Colors.grey.shade300,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  onTap: () {},
                                  value: partyDropdownValue,
                                  hint: Text(
                                    'Select party',
                                    maxLines: 1,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      partyDropdownValue = value;
                                      isTableLoading = true;
                                      getCustomerChats(
                                          date1: formattedSql1,
                                          date2: formattedSql2);
                                    });
                                  },
                                  icon: (null),
                                  iconSize: 30,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                  items: partyList
                                      .map<DropdownMenuItem<String>>(
                                          (PartyModel value) {
                                    return DropdownMenuItem<String>(
                                      value: value.id.toString(),
                                      child: Text(
                                        '${value.name} (${value.id})',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isTableLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: MediaQuery.of(context).size.height - 250,
                          child: ScrollableWidget(
                            child: DataTable(
                              // headingRowColor: MaterialStateProperty.resolveWith(getColor),
                              columnSpacing: 20,
                              columns: getColumns(columns),
                              rows: getRows(chatList),
                            ),
                          ),
                        ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isTableLoading
                          ? const Text('')
                          : Text(
                              "Total : $mainBalance",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                    ],
                  ),
                ),
              )
            ]),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();

  List<DataRow> getRows(List<ChatModel> chatModelList) => chatModelList
      .map(
        (ChatModel chatModel) => DataRow(cells: [
          DataCell(Text(serialNo())),
          DataCell(
            Text(
              MyHomePage.dateFormatter
                  .format(DateTime.parse(chatModel.date.toString())),
            ),
          ),
          DataCell(Text(chatModel.inv.toString())),
          DataCell(Text(chatModel.party.toString())),
          DataCell(Text(getAmountAndBalance(chatModel))),
        ]),
      )
      .toList();
  String serialNo() {
    serialNumber++;
    return '$serialNumber';
  }

  String getAmountAndBalance(ChatModel chatModel) {
    mainBalance += double.parse(chatModel.amount.toString());
    return chatModel.amount.toString();
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty('formattedSql1', formattedSql1));
  //   properties.add(DiagnosticsProperty('formattedSql1', formattedSql1));
  // }
}
