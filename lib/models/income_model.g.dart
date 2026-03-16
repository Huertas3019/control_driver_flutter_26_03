// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Income _$IncomeFromJson(Map<String, dynamic> json) => _Income(
  id: json['id'] as String?,
  vehicleId: json['vehicleId'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  platform: json['platform'] as String,
  initialOdometer: (json['initialOdometer'] as num).toInt(),
  finalOdometer: (json['finalOdometer'] as num?)?.toInt(),
  subtotalEarning: (json['subtotalEarning'] as num?)?.toDouble(),
  extraEarning: (json['extraEarning'] as num?)?.toDouble() ?? 0.0,
  fuelCostForDay: (json['fuelCostForDay'] as num?)?.toDouble() ?? 0.0,
  kilometersDriven: (json['kilometersDriven'] as num?)?.toInt() ?? 0,
  totalEarning: (json['totalEarning'] as num?)?.toDouble() ?? 0.0,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$IncomeToJson(_Income instance) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'platform': instance.platform,
  'initialOdometer': instance.initialOdometer,
  'finalOdometer': instance.finalOdometer,
  'subtotalEarning': instance.subtotalEarning,
  'extraEarning': instance.extraEarning,
  'fuelCostForDay': instance.fuelCostForDay,
  'kilometersDriven': instance.kilometersDriven,
  'totalEarning': instance.totalEarning,
  'isCompleted': instance.isCompleted,
};
