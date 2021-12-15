import 'package:json_annotation/json_annotation.dart';
part 'chat_model.g.dart';

const transactionTable = 'transaction1';
List<String> transactionColumnList = [
  TransactionColumns.partyID,
  TransactionColumns.party,
  TransactionColumns.inv,
  'transaction1.${TransactionColumns.user}',
  TransactionColumns.amount,
  TransactionColumns.state,
  TransactionColumns.transactionType,
  TransactionColumns.description,
  "strftime('%Y-%m-%d',${TransactionColumns.date})",
  TransactionColumns.time
];

class TransactionColumns {
  static const partyID = 'partyID';
  static const party = 'party';
  static const inv = 'inv';
  static const user = 'user';
  static const amount = 'amount';
  static const state = 'state';
  static const transactionType = 'transactionType';
  static const description = 'description';
  static const date = 'date';
  static const time = 'time';
}

@JsonSerializable()
class ChatModel {
  final int? inv;
  final int? partyID;
  final double? amount;
  final String? party;
  final String? transactionType;
  final String? description;
  final String? state;
  final DateTime? date;
  final String? time;
  final String? user;
  ChatModel(
      {this.inv,
      this.partyID,
      this.amount,
      this.transactionType,
      this.description,
      this.state,
      this.date,
      this.time,
      this.party,
      this.user});

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
