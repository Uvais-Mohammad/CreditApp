import 'package:json_annotation/json_annotation.dart';
part 'party_model.g.dart';

@JsonSerializable()
class PartyModel {
  final int id;
  final String name;
  PartyModel({required this.id, required this.name});

  factory PartyModel.fromJson(Map<String, dynamic> json) =>
      _$PartyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PartyModelToJson(this);
}
