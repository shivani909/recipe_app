class StoreModel {
  final double latitude;
  final double longitude;
  final String address; // full display address
  final String city;
  final String state;
  final String country;
  final double distanceInMeters;

  StoreModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.distanceInMeters,
  });

  String get distanceLabel {
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m away";
    }
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} km away";
  }
}