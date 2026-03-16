
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'platform_model.freezed.dart';
part 'platform_model.g.dart';

@freezed
abstract class Platform with _$Platform {
  const factory Platform({
    String? id,
    required String userId,
    required String name,
  }) = _Platform;

  factory Platform.fromJson(Map<String, dynamic> json) => _$PlatformFromJson(json);
}

extension PlatformFirestore on Platform {
  static Platform fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Platform.fromJson(data);
  }
}
