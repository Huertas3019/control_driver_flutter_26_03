import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Vehicle> _vehiclesRef;

  VehicleService() {
    _vehiclesRef = _firestore
        .collection('vehicles')
        .withConverter<Vehicle>(
          fromFirestore: (snapshot, _) => Vehicle.fromJson(snapshot.data()!),
          toFirestore: (vehicle, _) => vehicle.toJson(),
        );
  }

  /// Adds a new vehicle to Firestore.
  /// The vehicle object should have a pre-generated ID.
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _vehiclesRef.doc(vehicle.id).set(vehicle);
    } catch (e) {
      debugPrint('Error adding vehicle: $e');
      rethrow; // Propagate the error to be handled by the UI
    }
  }

  /// Retrieves a real-time stream of vehicles for a given user.
  Stream<List<Vehicle>> getVehicles(String userId) {
    return _vehiclesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
        .handleError((error) {
          debugPrint('Error fetching vehicles: $error');
          return [];
        });
  }

  /// Updates an existing vehicle in Firestore.
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _vehiclesRef.doc(vehicle.id).update(vehicle.toJson());
    } catch (e) {
      debugPrint('Error updating vehicle: $e');
      rethrow;
    }
  }

  /// Deletes a vehicle from Firestore by its ID.
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _vehiclesRef.doc(vehicleId).delete();
    } catch (e) {
      debugPrint('Error deleting vehicle: $e');
      rethrow;
    }
  }
}
