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

  void fetchVehicles(String userId) {
    _setLoading(true);
    _vehicleSubscription?.cancel(); 
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

  Future<void> addVehicle({
    required String userId,
    required String brand,
    required String model,
    required int year,
    required String licensePlate,
    required double fuelEfficiency,
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
      fuelEfficiency: fuelEfficiency,
      createdAt: Timestamp.now(),
    );
    await _vehicleService.addVehicle(newVehicle);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleService.updateVehicle(vehicle);
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _vehicleService.deleteVehicle(vehicleId);
  }

  @override
  void dispose() {
    _vehicleSubscription?.cancel();
    super.dispose();
  }
}
