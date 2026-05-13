import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/maintenance_model.dart';

class MaintenanceProvider with ChangeNotifier {
  List<Maintenance> _maintenances = [];
  bool _isLoading = true;
  String? _userId;

  List<Maintenance> get maintenances => _maintenances;
  bool get isLoading => _isLoading;
  String? get userId => _userId;

  MaintenanceProvider(this._userId) {
    if (_userId != null) {
      fetchMaintenances();
    }
  }

  void updateUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
      if (_userId != null) {
        fetchMaintenances();
      } else {
        _maintenances = [];
        notifyListeners();
      }
    }
  }

  Future<void> fetchMaintenances() async {
    if (_userId == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('maintenances')
          .where('userId', isEqualTo: _userId)
          .get();

      _maintenances = snapshot.docs
          .map((doc) => Maintenance.fromMap(doc.data(), doc.id))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addMaintenance(Maintenance maintenance) async {
    try {
      await FirebaseFirestore.instance
          .collection('maintenances')
          .doc(maintenance.id)
          .set(maintenance.toMap());
      _maintenances.add(maintenance);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMaintenance(Maintenance maintenance) async {
    try {
      await FirebaseFirestore.instance
          .collection('maintenances')
          .doc(maintenance.id)
          .update(maintenance.toMap());
      final index = _maintenances.indexWhere((m) => m.id == maintenance.id);
      if (index != -1) {
        _maintenances[index] = maintenance;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMaintenance(String id) async {
    try {
      await FirebaseFirestore.instance.collection('maintenances').doc(id).delete();
      _maintenances.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
