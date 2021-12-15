import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

const userTable = 'party';

class UserColumns {
  static const id = 'id';
  static const name = 'name';
  static const phone = 'phone';
  static const address = 'address';
  static const route = 'route';
  static const type = 'type';
  static const closingBal = 'closingBalance';
  static const user = 'user';
  static const createDate = 'createDate';
  static const lastTime = 'lastTime';
  static const lastDate = 'lastDate';
  static const lastStatus = 'lastStatus';
}

@JsonSerializable()
class UserModel {
  final String name;
  final String closingBalance;
  final String lastStatus;
  final String type;
  final int? id;
  final DateTime lastDate;
  final String? phone;
  final String? address;
  final String? route;
  final String? user;
  final DateTime? createDate;
  final String? lastTime;

  UserModel({
    required this.name,
    required this.closingBalance,
    required this.lastStatus,
    required this.type,
    this.id,
    required this.lastDate,
    this.phone,
    this.address,
    this.route,
    this.user,
    this.createDate,
    this.lastTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
