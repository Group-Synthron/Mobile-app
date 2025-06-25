class FishInventoryModel {
  final String id;
  final String fishName;
  final double weight;
  final String size;
  final String location;
  final DateTime timestamp;
  final String qrCodeLink;

  FishInventoryModel({
    required this.id,
    required this.fishName,
    required this.weight,
    required this.size,
    required this.location,
    required this.timestamp,
    required this.qrCodeLink,
  });

  factory FishInventoryModel.fromMap(Map<String, dynamic> data) {
    return FishInventoryModel(
      id: data['id'],
      fishName: data['fishName'],
      weight: data['weight'],
      size: data['size'],
      location: data['location'],
      timestamp: DateTime.parse(data['timestamp']),
      qrCodeLink: data['qrCodeLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fishName': fishName,
      'weight': weight,
      'size': size,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'qrCodeLink': qrCodeLink,
    };
  }
}
