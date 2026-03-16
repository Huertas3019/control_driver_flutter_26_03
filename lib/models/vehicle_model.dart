
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

// Helper functions for Firestore Timestamp conversion
Timestamp _timestampFromJson(dynamic json) {
  if (json is Timestamp) return json;
  if (json is String) return Timestamp.fromDate(DateTime.parse(json));
  return Timestamp.now();
}

Timestamp _timestampToJson(Timestamp timestamp) => timestamp;

@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    String? id,
    required String userId,
    required String brand,
    required String model,
    required int year,
    required String plate,
    required int initialOdometer,
    required double fuelEfficiency, // In km per liter
    String? nickname,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required Timestamp createdAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}

extension VehicleFirestore on Vehicle {
  static Vehicle fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Vehicle.fromJson(data);
  }
}
