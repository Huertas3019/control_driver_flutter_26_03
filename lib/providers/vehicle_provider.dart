
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/vehicle_model.dart';
import 'package:myapp/services/firestore_service.dart';

class VehicleProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _vehicleSubscription;

  final String? _userId;
  String? get userId => _userId;

  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;

  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;

  VehicleProvider(this._userId) {
    if (_userId != null && _userId.isNotEmpty) {
      fetchVehicles();
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void fetchVehicles() {
    if (_userId == null) return;
    _setLoading(true);
    _vehicleSubscription?.cancel();
    _vehicleSubscription = _firestoreService
        .collectionStream(
      path: 'vehicles',
      builder: (data, documentId) {
        final doc = {
          'id': documentId,
          if (data != null) ...data,
        };
        return Vehicle.fromJson(doc);
      },
      queryBuilder: (query) => query.where('userId', isEqualTo: _userId),
    )
        .listen((vehicles) {
      _vehicles = vehicles;
      if (_vehicles.isNotEmpty && _selectedVehicle == null) {
        _selectedVehicle = _vehicles.first;
      }
      _setLoading(false);
      notifyListeners();
    }, onError: (error) {
      _setLoading(false);
      notifyListeners();
    });
  }

  void setSelectedVehicleId(String vehicleId) {
    try {
      _selectedVehicle = _vehicles.firstWhere((v) => v.id == vehicleId);
    } catch (e) {
      _selectedVehicle = null;
    }
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await _firestoreService.setDocument('vehicles', vehicle.id!, vehicle.toJson());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _firestoreService.updateDocument('vehicles', vehicle.id!, vehicle.toJson());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _firestoreService.deleteDocument('vehicles', vehicleId);
  }

  void clear() {
    _vehicleSubscription?.cancel();
    _vehicles = [];
    _selectedVehicle = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _vehicleSubscription?.cancel();
    super.dispose();
  }
}
