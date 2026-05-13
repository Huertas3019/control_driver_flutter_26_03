
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/income_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class IncomeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _incomeSubscription;

  final String? _userId;
  String? get userId => _userId;

  List<Income> _incomes = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;

  List<Income> get filteredIncomes {
    return _incomes.where((income) {
      return income.date.month == _selectedDate.month &&
          income.date.year == _selectedDate.year;
    }).toList();
  }

  IncomeProvider(this._userId) {
    if (_userId != null) {
      fetchIncomes();
    }
  }

  void updateFilter(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
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
          if (data != null) ...data,
          'id': documentId,
        };
        return Income.fromJson(doc);
      },
      queryBuilder: (query) => query.where('userId', isEqualTo: _userId),
    )
        .listen((incomes) {
      _incomes = incomes..sort((a, b) => b.date.compareTo(a.date));
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
    final id = income.id ?? const Uuid().v4();
    await _firestoreService.setDocument('incomes', id, income.copyWith(id: id).toJson());
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
