
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'income_model.freezed.dart';
part 'income_model.g.dart';

@freezed
abstract class Income with _$Income {
  const factory Income({
    String? id,
    required String vehicleId,
    required String userId,
    required DateTime date,
    required String platform,
    required int initialOdometer,
    required int finalOdometer,
    required double subtotalEarning,
    @Default(0.0) double? extraEarning,
    @Default(0.0) double fuelCostForDay,
    @Default(0) int kilometersDriven,
    @Default(0.0) double totalEarning,
  }) = _Income;

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
}

extension IncomeFirestore on Income {
  static Income fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Income.fromJson(data);
  }
}
