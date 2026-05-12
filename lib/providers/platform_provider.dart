
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/platform_model.dart';
import 'package:myapp/services/firestore_service.dart';
import 'dart:developer' as developer; // Import for logging

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
    developer.log('PlatformProvider initialized with userId: $_userId', name: 'PlatformProvider');
    if (_userId != null) {
      fetchPlatforms();
    }
  }

  void fetchPlatforms() {
    if (_userId == null) {
      developer.log('fetchPlatforms called with null userId. Aborting.', name: 'PlatformProvider');
      return;
    }
    developer.log('Fetching platforms for userId: $_userId', name: 'PlatformProvider');
    _isLoading = true;
    notifyListeners();

    _platformSubscription?.cancel();
    _platformSubscription = _firestoreService
        .collectionStream(
      path: 'platforms',
      builder: (data, documentId) {
        final doc = {
          'id': documentId,
          if (data != null) ...data, // Null-safe spread
        };
        developer.log('Building platform from doc: $doc', name: 'PlatformProvider');
        return Platform.fromJson(doc);
      },
      queryBuilder: (query) => query.where('userId', isEqualTo: _userId).orderBy('name'),
    )
        .listen((platforms) {
      _platforms = platforms;
      _isLoading = false;
      developer.log('Platforms fetched successfully. Count: ${_platforms.length}', name: 'PlatformProvider');
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      developer.log('Error fetching platforms: $error', name: 'PlatformProvider', level: 900);
      notifyListeners();
    });
  }

  Future<void> addPlatform(Platform platform) async {
    developer.log('Adding platform: ${platform.name} for userId: ${platform.userId}', name: 'PlatformProvider');
    await _firestoreService.addDocument('platforms', platform.toJson());
  }

  Future<void> updatePlatform(Platform platform) async {
    developer.log('Updating platform: ${platform.id} - ${platform.name}', name: 'PlatformProvider');
    await _firestoreService.updateDocument('platforms', platform.id!, platform.toJson());
  }

  Future<void> deletePlatform(String platformId) async {
    developer.log('Deleting platform with id: $platformId', name: 'PlatformProvider');
    await _firestoreService.deleteDocument('platforms', platformId);
  }

  @override
  void dispose() {
    _platformSubscription?.cancel();
    super.dispose();
  }
}
