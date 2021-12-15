import 'package:json_annotation/json_annotation.dart';
part 'company_model.g.dart';

const companyTable = 'company';

class CompanyColumns {
  static const name = 'name';
  static const address1 = 'address1';
  static const address2 = 'address2';
  static const pin = 'pin';
  static const phone = 'phone';
}

@JsonSerializable()
class CompanyModel {
  final String name;
  final String address1;
  final String address2;
  final String pin;
  final String phone;

  CompanyModel({
    required this.name,
    required this.address1,
    required this.address2,
    required this.pin,
    required this.phone,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
