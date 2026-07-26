class StoreModel {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  double distance;

  StoreModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distance = 0,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final properties = json["properties"];

    return StoreModel(
      name: properties["name"] ?? "Unnamed Store",
      address: properties["formatted"] ?? "",
      latitude: (properties["lat"] as num).toDouble(),
      longitude: (properties["lon"] as num).toDouble(),
    );
  }
}