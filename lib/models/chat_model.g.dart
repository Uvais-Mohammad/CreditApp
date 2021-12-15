// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      inv: json['inv'] as int?,
      partyID: json['partyID'] as int?,
      amount: (json['amount'] as num?)?.toDouble(),
      transactionType: json['transactionType'] as String?,
      description: json['description'] as String?,
      state: json['state'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      time: json['time'] as String?,
      party: json['party'] as String?,
      user: json['user'] as String?,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'inv': instance.inv,
      'partyID': instance.partyID,
      'amount': instance.amount,
      'party': instance.party,
      'transactionType': instance.transactionType,
      'description': instance.description,
      'state': instance.state,
      'date': instance.date?.toIso8601String(),
      'time': instance.time,
      'user': instance.user,
    };
