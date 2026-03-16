
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/income_model.dart';
import 'package:myapp/services/firestore_service.dart';

class IncomeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _incomeSubscription;

  final String? _userId;
  String? get userId => _userId;

  List<Income> _incomes = [];
  bool _isLoading = false;

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;

  IncomeProvider(this._userId) {
    if (_userId != null) {
      fetchIncomes();
    }
  }

  void fetchIncomes() {
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();

    _incomeSubscription?.cancel();
    _incomeSubscription = _firestoreService
        .collectionStream(
      path: 'incomes',
      builder: (data, documentId) {
        final doc = {
          'id': documentId,
          if (data != null) ...data, // Null-safe spread
        };
        return Income.fromJson(doc);
      },
      queryBuilder: (query) => query
          .where('userId', isEqualTo: _userId)
          .orderBy('date', descending: true),
    )
        .listen((incomes) {
      _incomes = incomes;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addIncome(Income income) async {
    // Check if there is already an active session to prevent duplicates
    final hasActive = _incomes.any((i) => !i.isCompleted);
    if (hasActive && !income.isCompleted) {
       throw Exception('Ya tienes una jornada en curso.');
    }
    await _firestoreService.addDocument('incomes', income.toJson());
  }

  Future<void> updateIncome(Income income) async {
    await _firestoreService.updateDocument('incomes', income.id!, income.toJson());
  }

  Future<void> deleteIncome(String incomeId) async {
    await _firestoreService.deleteDocument('incomes', incomeId);
  }

  @override
  void dispose() {
    _incomeSubscription?.cancel();
    super.dispose();
  }
}
