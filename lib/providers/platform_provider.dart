
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/platform_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class PlatformProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _platformSubscription;

  final String? _userId;
  String? get userId => _userId;

  List<Platform> _platforms = [];
  bool _isLoading = false;

  List<Platform> get platforms => _platforms;
  bool get isLoading => _isLoading;

  PlatformProvider(this._userId) {
    if (_userId != null) {
      fetchPlatforms();
    }
  }

  void fetchPlatforms() {
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();

    _platformSubscription?.cancel();
    _platformSubscription = _firestoreService
        .collectionStream(
      path: 'platforms',
      builder: (data, documentId) {
        final doc = {
          if (data != null) ...data,
          'id': documentId,
        };
        return Platform.fromJson(doc);
      },
      queryBuilder: (query) => query.where('userId', isEqualTo: _userId),
    )
        .listen((platforms) {
      _platforms = platforms..sort((a, b) => a.name.compareTo(b.name));
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addPlatform(Platform platform) async {
    final id = platform.id ?? const Uuid().v4();
    await _firestoreService.setDocument('platforms', id, platform.copyWith(id: id).toJson());
  }

  Future<void> updatePlatform(Platform platform) async {
    await _firestoreService.updateDocument('platforms', platform.id!, platform.toJson());
  }

  Future<void> deletePlatform(String platformId) async {
    await _firestoreService.deleteDocument('platforms', platformId);
  }

  @override
  void dispose() {
    _platformSubscription?.cancel();
    super.dispose();
  }
}
