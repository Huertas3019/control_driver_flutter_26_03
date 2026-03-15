// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  plate: json['plate'] as String,
  initialOdometer: (json['initialOdometer'] as num).toInt(),
  fuelEfficiency: (json['fuelEfficiency'] as num).toDouble(),
  nickname: json['nickname'] as String?,
  createdAt: _timestampFromJson(json['createdAt']),
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'plate': instance.plate,
  'initialOdometer': instance.initialOdometer,
  'fuelEfficiency': instance.fuelEfficiency,
  'nickname': instance.nickname,
  'createdAt': _timestampToJson(instance.createdAt),
};
