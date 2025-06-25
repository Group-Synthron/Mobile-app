class Vessel {
  final BigInt vesselId;
  final String ownerAddress;
  final String vesselName;
  final String registrationNumber;
  final bool isActive;
  final BigInt lastUpdateTime;
  final List<String> licenses;

  Vessel({
    required this.vesselId,
    required this.ownerAddress,
    required this.vesselName,
    required this.registrationNumber,
    required this.isActive,
    required this.lastUpdateTime,
    required this.licenses,
  });
}
