import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added this line
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();
  final _uuid = const Uuid();

  List<Vehicle> _vehicles = [];
  StreamSubscription? _vehicleSubscription;
  bool _isLoading = false;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Subscribes to the vehicle stream for a user.
  void fetchVehicles(String userId) {
    _setLoading(true);
    _vehicleSubscription?.cancel(); // Cancel previous subscription
    _vehicleSubscription = _vehicleService
        .getVehicles(userId)
        .listen(
          (vehicles) {
            _vehicles = vehicles;
            _setLoading(false);
            notifyListeners();
          },
          onError: (error) {
            debugPrint("Error in vehicle stream: $error");
            _setLoading(false);
          },
        );
  }

  /// Adds a new vehicle.
  Future<void> addVehicle({
    required String userId,
    required String brand,
    required String model,
    required int year,
    required String licensePlate,
    String? nickname,
  }) async {
    final newVehicle = Vehicle(
      id: _uuid.v4(),
      userId: userId,
      brand: brand,
      model: model,
      year: year,
      licensePlate: licensePlate,
      nickname: nickname,
      createdAt: Timestamp.now(),
    );
    await _vehicleService.addVehicle(newVehicle);
    // No need to call notifyListeners() here, the stream will do it.
  }

  /// Updates an existing vehicle.
  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleService.updateVehicle(vehicle);
  }

  /// Deletes a vehicle by its ID.
  Future<void> deleteVehicle(String vehicleId) async {
    await _vehicleService.deleteVehicle(vehicleId);
  }

  @override
  void dispose() {
    _vehicleSubscription?.cancel();
    super.dispose();
  }
}
