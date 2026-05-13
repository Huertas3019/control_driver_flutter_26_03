

class Maintenance {
  final String id;
  final String userId;
  final String vehicleId;
  final String description;
  final int lastMaintenanceKm;
  final int intervalKm;

  Maintenance({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.description,
    required this.lastMaintenanceKm,
    required this.intervalKm,
  });

  int get nextDueKm => lastMaintenanceKm + intervalKm;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'description': description,
      'lastMaintenanceKm': lastMaintenanceKm,
      'intervalKm': intervalKm,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map, String documentId) {
    return Maintenance(
      id: documentId,
      userId: map['userId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      description: map['description'] ?? '',
      lastMaintenanceKm: map['lastMaintenanceKm']?.toInt() ?? 0,
      intervalKm: map['intervalKm']?.toInt() ?? 0,
    );
  }
}
