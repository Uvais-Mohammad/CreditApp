import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palets_app/components/user_tile.dart';
import 'package:palets_app/models/user_model.dart';
import 'package:palets_app/services/database_helper.dart';
import '../main.dart';
import 'home.dart';

class UserTab extends StatefulWidget {
  final String tabType;
  const UserTab({Key? key, required this.tabType}) : super(key: key);
  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  bool circular = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _route = TextEditingController();
  var now = DateTime.now();
  String formattedDateSql = DateFormat("yyyy-MM-dd").format(DateTime.now());
  Color? color;
  String? routeDropdownValue;
  List routeList = [];
  List<UserModel> customerList = [];
  List<UserModel> supplierList = [];
  bool isRouteLoading = true;

  void getRoutes() async {
    routeList = await DatabaseHelper.instance.getRoutes();
    setState(() {
      isRouteLoading = false;
    });
  }

  void getCustomerList() async {
    customerList = await DatabaseHelper.instance.getUser('CUSTOMER');
  }

  void getSupplierList() async {
    supplierList = await DatabaseHelper.instance.getUser('SUPPLIER');
    setState(() {
      circular = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRoutes();
    getCustomerList();
    getSupplierList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: circular
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.tabType == 'CUSTOMER'
                  ? customerList.length
                  : supplierList.length,
              itemBuilder: (context, index) => UserTile(
                userModel: widget.tabType == 'CUSTOMER'
                    ? customerList[index]
                    : supplierList[index],
                isMainPage: true,
                function: showInformationDialog,
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showInformationDialog(
              context: context,
              name: '',
              address: '',
              route: '',
              phone: '',
              status: '',
              id: 0);
        },
        icon: const Icon(Icons.person_add),
        label: widget.tabType == 'CUSTOMER'
            ? const Text('Add Customer')
            : const Text('Add Supplier'),
      ),
    );
  }

  void clear() {
    _name.text = "";
    _phone.text = "";
    _address.text = "";
    routeDropdownValue = null;
  }

  Future<void> showInformationDialog(
      {required BuildContext context,
      required String status,
      required String name,
      required String phone,
      required String address,
      required String route,
      required int id}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            if (status == 'Edit') {
              setState(() {
                _name.text = name;
                _phone.text = phone;
                _address.text = address;
                routeDropdownValue = route;
              });
            }
            return AlertDialog(
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _name,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Enter customer name";
                        },
                        decoration: const InputDecoration(hintText: "Name"),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Enter phone number";
                        },
                        decoration:
                            const InputDecoration(hintText: "Phone Number"),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        controller: _address,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter address";
                        },
                        decoration: const InputDecoration(hintText: "Address"),
                        textInputAction: TextInputAction.next,
                      ),
                      isRouteLoading
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField<String>(
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : "Select route";
                              },
                              onTap: () {},
                              isExpanded: true,
                              value: routeDropdownValue,
                              hint: const Text(
                                'Select route',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  routeDropdownValue = value;
                                  color = Colors.black;
                                });
                              },
                              icon: (null),
                              iconSize: 30,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              items: routeList.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
              title: Text('Add ${widget.tabType}'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text(' Cancel '),
                  onPressed: () {
                    Navigator.of(context).pop();
                    clear();
                  },
                ),
                ElevatedButton(
                    child: const Text(' Submit '),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Do something like updating SharedPreferences or User Settings etc.
                        UserModel userModel = status == 'Edit'
                            ? UserModel(
                                id: id,
                                lastDate: DateTime.parse(formattedDateSql),
                                name: _name.text,
                                type: widget.tabType,
                                closingBalance: "0",
                                lastStatus: '',
                                user: 'Admin',
                                address: _address.text.toString(),
                                phone: _phone.text,
                                route: routeDropdownValue,
                                createDate: DateTime.parse(MyHomePage
                                    .dateFormatterSql
                                    .format(DateTime.now())),
                                lastTime: MyHomePage.timeFormatter
                                    .format(DateTime.now()))
                            : UserModel(
                                name: _name.text,
                                type: widget.tabType,
                                closingBalance: "0",
                                lastStatus: '',
                                user: 'Admin',
                                address: _address.text.toString(),
                                phone: _phone.text,
                                route: routeDropdownValue,
                                createDate: DateTime.parse(MyHomePage
                                    .dateFormatterSql
                                    .format(DateTime.now())),
                                lastTime: MyHomePage.timeFormatter
                                    .format(DateTime.now()),
                                lastDate: DateTime.parse((formattedDateSql)));
                        status == 'Edit'
                            ? await DatabaseHelper.instance.updateUser(
                                userModel: userModel,
                              )
                            : await DatabaseHelper.instance
                                .addUser(userModel: userModel);
                        if (widget.tabType == "CUSTOMER") {
                          Navigator.pop(context);
                          clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home(
                                      index: 1,
                                    )),
                          );
                        } else {
                          Navigator.pop(context);
                          clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home(
                                      index: 2,
                                    )),
                          );
                        }
                        status == 'Edit'
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Updated party successfully"),
                                ),
                              )
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added party successfully"),
                                ),
                              );
                      }
                    }),
              ],
            );
          });
        });
  }
}
