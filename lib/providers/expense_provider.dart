
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/expense_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _expenseSubscription;

  final String? _userId;
  String? get userId => _userId;

  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  ExpenseProvider(this._userId) {
    if (_userId != null) {
      fetchExpenses();
    }
  }

  /// Obtenemos el último gasto de tipo 'nafta' para un vehículo específico
  Expense? getLatestFuelExpense(String vehicleId) {
    try {
      return _expenses.firstWhere(
        (e) => e.vehicleId == vehicleId && e.type == ExpenseType.nafta,
      );
    } catch (_) {
      return null;
    }
  }

  void fetchExpenses() {
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();

    _expenseSubscription?.cancel();
    _expenseSubscription = _firestoreService
        .collectionStream(
      path: 'expenses',
      builder: (data, documentId) {
        final doc = {
          if (data != null) ...data,
          'id': documentId,
        };
        return Expense.fromJson(doc);
      },
      queryBuilder: (query) => query.where('userId', isEqualTo: _userId),
    )
        .listen((expenses) {
      _expenses = expenses..sort((a, b) => b.date.compareTo(a.date));
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addExpense(Expense expense) async {
    final id = expense.id ?? const Uuid().v4();
    await _firestoreService.setDocument('expenses', id, expense.copyWith(id: id).toJson());
  }

  Future<void> updateExpense(Expense expense) async {
    await _firestoreService.updateDocument('expenses', expense.id!, expense.toJson());
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestoreService.deleteDocument('expenses', expenseId);
  }

  @override
  void dispose() {
    _expenseSubscription?.cancel();
    super.dispose();
  }
}
