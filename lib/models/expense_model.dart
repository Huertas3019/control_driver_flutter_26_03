
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

enum ExpenseType {
  nafta,
  mantenimiento,
  seguro,
  impuestos,
  otros,
}

@freezed
class Expense with _$Expense {
  const factory Expense({
    String? id,
    required String vehicleId,
    required String userId,
    required DateTime date,
    required ExpenseType type,
    required double amount,
    required int odometer,
    String? description,
    @Default(0.0) double? liters,
    @Default(0.0) double? pricePerLiter,
    required String category,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Expense.fromJson(data);
  }
}
