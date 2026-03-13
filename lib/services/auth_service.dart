import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    notifyListeners();
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
