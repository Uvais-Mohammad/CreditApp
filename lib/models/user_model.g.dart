// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      closingBalance: json['closingBalance'] as String,
      lastStatus: json['lastStatus'] as String,
      type: json['type'] as String,
      id: json['id'] as int?,
      lastDate: DateTime.parse(json['lastDate'] as String),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      route: json['route'] as String?,
      user: json['user'] as String?,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      lastTime: json['lastTime'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'closingBalance': instance.closingBalance,
      'lastStatus': instance.lastStatus,
      'type': instance.type,
      'id': instance.id,
      'lastDate': instance.lastDate.toIso8601String(),
      'phone': instance.phone,
      'address': instance.address,
      'route': instance.route,
      'user': instance.user,
      'createDate': instance.createDate?.toIso8601String(),
      'lastTime': instance.lastTime,
    };
