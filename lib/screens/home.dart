import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palets_app/components/user_tile.dart';
import 'package:palets_app/main.dart';
import 'package:palets_app/models/user_model.dart';
import 'package:palets_app/screens/user_tab.dart';
import 'package:palets_app/services/database_helper.dart';
import 'package:palets_app/services/user_simple_preferences.dart';

import 'date_wise_report.dart';

class Home extends StatefulWidget {
  final int index;
  const Home({Key? key, required this.index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  List<UserModel> customerList = [];
  List<UserModel> supplierList = [];

  void getCustomerList() async {
    customerList = await DatabaseHelper.instance.getUser('CUSTOMER');
  }

  void getSupplierList() async {
    supplierList = await DatabaseHelper.instance.getUser('SUPPLIER');
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          IconButton(
            onPressed: () async {
              _tabController.index == 2 ? getSupplierList() : getCustomerList();
              showSearch(
                context: context,
                delegate: UserSearch(
                    dataList: _tabController.index == 2
                        ? supplierList
                        : customerList),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DateWiseReport()));
            },
            icon: Icon(Icons.description),
            tooltip: 'Date Wise Report',
          ),
          IconButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
                await UserSimplePreferences.setLoggedOut();
              },
              icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            text: "Home",
          ),
          Tab(
            text: "Customer",
          ),
          Tab(
            text: "Supplier",
          ),
          Tab(
            text: "Expense",
          ),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: const [
        Center(child: Text("Home")),
        UserTab(
          tabType: 'CUSTOMER',
        ),
        UserTab(
          tabType: 'SUPPLIER',
        ),
        Center(child: Text("hai")),
      ]),
    );
  }
}

class UserSearch extends SearchDelegate {
  final List dataList;
  UserSearch({required this.dataList});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final list = query.isEmpty
        ? dataList
        : dataList
            .where((element) => element.name.toLowerCase().contains(query))
            .toList();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => UserTile(
        userModel: list[index],
        isMainPage: false,
      ),
    );
  }
}
