// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      name: json['name'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String,
      pin: json['pin'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address1': instance.address1,
      'address2': instance.address2,
      'pin': instance.pin,
      'phone': instance.phone,
    };
