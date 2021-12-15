import 'package:palets_app/models/chat_model.dart';
import 'package:palets_app/models/company_model.dart';
import 'package:palets_app/models/party_model.dart';
import 'package:palets_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB('easycredit.db');
    return _database;
  }

  Future<Database?> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _onOpen(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType250 = 'VARCHAR(250)';
    const textType100 = 'VARCHAR(100)';
    const textType500 = 'VARCHAR(500)';
    const intType = 'INTEGER';
    const doubleType = 'DOUBLE';
    const dateType = 'DATE';
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType250 = 'VARCHAR(250)';
    const textType100 = 'VARCHAR(100)';
    const textType500 = 'VARCHAR(500)';
    const intType = 'INTEGER';
    const doubleType = 'DOUBLE';
    const dateType = 'DATE';
    await db.execute('''CREATE TABLE route (name $textType250)''');
    await db.execute(
        '''CREATE TABLE employee (emp_name $textType250,emp_pass $textType250)''');
    await db.execute(
        '''CREATE TABLE company (name $textType250,address1 $textType250,address2 $textType250,pin $textType100,phone $textType100)''');
    await db.execute(
        '''CREATE TABLE $userTable(${UserColumns.id} $idType,${UserColumns.name} $textType250,${UserColumns.phone} $textType100,${UserColumns.address} $textType500,${UserColumns.route} $textType100,${UserColumns.type} $textType100,${UserColumns.closingBal} $textType100,${UserColumns.user} $textType100,${UserColumns.createDate} $dateType,${UserColumns.lastTime} $textType100,${UserColumns.lastDate} $dateType,${UserColumns.lastStatus} $dateType) ''');
    await db.rawInsert(
        "INSERT INTO route(name) VALUES('Sunday'),('Monday'),('Tuesday'),('Wednesday'),('Thursday'),('Friday'),('Saturday'),('Monthly'),('Suspect')");
    await db.rawInsert(
        "INSERT INTO employee(emp_name,emp_pass) VALUES ('Admin','123')");
    await db.execute(
        '''CREATE TABLE $transactionTable (${TransactionColumns.partyID} $intType,${TransactionColumns.party} $textType100,${TransactionColumns.inv} $idType,${TransactionColumns.user} $textType100,${TransactionColumns.amount} $doubleType,${TransactionColumns.state} $textType100,${TransactionColumns.transactionType} $textType100,${TransactionColumns.description} $textType500,${TransactionColumns.date} $dateType,${TransactionColumns.time} $textType100)''');
  }

  Future<List<Map<String, Object?>>> login(
      String? username, String? password) async {
    final db = await instance.database;
    List<Map<String, Object?>> user = await db!.query('employee',
        columns: ['emp_name', 'emp_pass'],
        where: 'emp_name=? and emp_pass=?',
        whereArgs: [username, password]);
    return user;
  }

  Future<List> getRoutes() async {
    final db = await instance.database;
    List routes = await db!.query("route");
    List data = [];
    for (int i = 0; i < routes.length; i++) {
      data.add(routes[i]['name']);
    }
    return data;
  }

  //Signup
  Future signUp(
      {required CompanyModel companyModel,
      required String userName,
      required String password}) async {
    final db = await instance.database;
    await db!.insert(companyTable, companyModel.toJson());
    await db.insert('employee', {'emp_name': userName, 'emp_pass': password});
  }

  //User Operations
  Future<int> addUser({required UserModel userModel}) async {
    final db = await instance.database;
    int id = await db!.insert(userTable, userModel.toJson());
    return id;
  }

  Future<List<UserModel>> getUser(String userType) async {
    final db = await instance.database;
    final result = await db!.query(
      userTable,
      where: '${UserColumns.type}=?',
      whereArgs: [userType],
      orderBy: '${UserColumns.id} DESC',
    );
    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<int> updateUser({required UserModel userModel}) async {
    final db = await instance.database;
    final i = await db!.update(userTable, userModel.toJson(),
        where: '${UserColumns.id}=?', whereArgs: [userModel.id]);
    return i;
  }

  Future<int> deleteUser({required int id}) async {
    final db = await instance.database;
    final i = await db!
        .delete(userTable, where: '${UserColumns.id}=?', whereArgs: [id]);
    return i;
  }

  //Chat Operation
  Future<int> addChat({required ChatModel chatModel}) async {
    final db = await instance.database;
    int id = await db!.insert(transactionTable, chatModel.toJson());
    return id;
  }

  Future<List<ChatModel>> getChat(int id) async {
    final db = await instance.database;
    final result = await db!.query(transactionTable,
        where: '${TransactionColumns.partyID}=?',
        whereArgs: [id],
        orderBy: '${TransactionColumns.inv} DESC');
    return result.map((json) => ChatModel.fromJson(json)).toList();
  }

  Future<int> updateChat({required ChatModel chatModel}) async {
    final db = await instance.database;
    return await db!.update(transactionTable, chatModel.toJson(),
        where: '${TransactionColumns.inv}=?', whereArgs: [chatModel.inv]);
  }

  Future<int> deleteChat({required int inv}) async {
    final db = await instance.database;
    return await db!.delete(transactionTable,
        where: '${TransactionColumns.inv}=?', whereArgs: [inv]);
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  //Company Operation
  Future<bool> isCompanyNotExist() async {
    final db = await instance.database;
    List<Map> result = await db!.rawQuery('SELECT COUNT(*) as i FROM company');
    if (result[0]['i'] == 0) {
      return true;
    }
    return false;
  }

  Future<List<CompanyModel>> getCompany() async {
    final db = await instance.database;
    final result = await db!.query(companyTable);
    return result.map((json) => CompanyModel.fromJson(json)).toList();
  }

  //Report Operation
  Future getRouteList() async {
    final db = await instance.database;
    final result = await db!.query('route');
    return result;
  }

  Future<List<PartyModel>> getPartyList() async {
    final db = await instance.database;
    final result = await db!.query(
      userTable,
      columns: ['${UserColumns.id},${UserColumns.name}'],
    );
    return result.map((json) => PartyModel.fromJson(json)).toList();
  }

  Future<List<ChatModel>> getReportRouteParty(
      {required String date1,
      required String date2,
      required String route,
      required String partyId,
      required String type}) async {
    final db = await instance.database;
    final result = await db!.rawQuery(
        "SELECT $transactionTable.* FROM $transactionTable,$userTable WHERE $userTable.name=$transactionTable.party AND strftime('%Y-%m-%d',date) BETWEEN '$date1' AND '$date2'  AND transactionType='$type' AND $userTable.route='$route' AND partyID='$partyId'");
    return result.map((json) => ChatModel.fromJson(json)).toList();
  }

  Future<List<ChatModel>> getReportRoute(
      {required String date1,
      required String date2,
      required String route,
      required String type}) async {
    final db = await instance.database;
    final result = await db!.rawQuery(
        "SELECT $transactionTable.* FROM $transactionTable,$userTable WHERE $userTable.name=$transactionTable.party AND strftime('%Y-%m-%d',date) BETWEEN '$date1' AND '$date2'  AND transactionType='$type' AND $userTable.route='$route'");
    return result.map((json) => ChatModel.fromJson(json)).toList();
  }

  Future<List<ChatModel>> getReportParty(
      {required String date1,
      required String date2,
      required String partyId,
      required String type}) async {
    final db = await instance.database;
    final result = await db!.rawQuery(
        "SELECT $transactionTable.* FROM $transactionTable,$userTable WHERE $userTable.name=$transactionTable.party AND strftime('%Y-%m-%d',date) BETWEEN '$date1' AND '$date2'  AND transactionType='$type' AND partyID='$partyId'");
    return result.map((json) => ChatModel.fromJson(json)).toList();
  }

  Future<List<ChatModel>> getReport(
      {required String date1,
      required String date2,
      required String type}) async {
    final db = await instance.database;
    final result = await db!.rawQuery(
        "SELECT $transactionTable.* FROM $transactionTable,$userTable WHERE $userTable.name=$transactionTable.party AND strftime('%Y-%m-%d',date) BETWEEN '$date1' AND '$date2'  AND transactionType='$type'");
    return result.map((json) => ChatModel.fromJson(json)).toList();
  }
}
