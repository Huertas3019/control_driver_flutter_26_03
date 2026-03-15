import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

// Helper functions for Firestore Timestamp conversion
Timestamp _timestampFromJson(dynamic json) {
  if (json is Timestamp) return json;
  if (json is Map<String, dynamic>) {
    return Timestamp(json['_seconds'], json['_nanoseconds']);
  }
  return Timestamp.now();
}

String _timestampToJson(Timestamp timestamp) => timestamp.toDate().toIso8601String();

@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    @JsonKey(includeIfNull: false) String? id,
    required String userId,
    required String brand,
    required String model,
    required int year,
    required String licensePlate,
    required double fuelEfficiency,
    String? nickname,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required Timestamp createdAt,
  }) = _Vehicle;

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Vehicle.fromJson(data).copyWith(id: doc.id);
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}
