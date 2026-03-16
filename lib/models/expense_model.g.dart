// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String?,
  vehicleId: json['vehicleId'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$ExpenseTypeEnumMap, json['type']),
  amount: (json['amount'] as num).toDouble(),
  odometer: (json['odometer'] as num).toInt(),
  description: json['description'] as String?,
  liters: (json['liters'] as num?)?.toDouble() ?? 0.0,
  pricePerLiter: (json['pricePerLiter'] as num?)?.toDouble() ?? 0.0,
  isCash: json['isCash'] as bool? ?? false,
  category: json['category'] as String,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'type': _$ExpenseTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'odometer': instance.odometer,
  'description': instance.description,
  'liters': instance.liters,
  'pricePerLiter': instance.pricePerLiter,
  'isCash': instance.isCash,
  'category': instance.category,
};

const _$ExpenseTypeEnumMap = {
  ExpenseType.nafta: 'nafta',
  ExpenseType.mantenimiento: 'mantenimiento',
  ExpenseType.seguro: 'seguro',
  ExpenseType.impuestos: 'impuestos',
  ExpenseType.otros: 'otros',
};
