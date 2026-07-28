import 'dart:convert';
import 'package:http/http.dart' as http;


class NominatimRepository {
  static const String _baseUrl = "https://nominatim.openstreetmap.org/reverse";

  Future<NominatimAddress> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      "$_baseUrl?format=jsonv2&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1",
    );

    final response = await http.get(
      uri,
      headers: {
       
        "User-Agent": "recipe_app_flutter_assignment/1.0",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Reverse geocoding failed (${response.statusCode})");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return NominatimAddress.fromJson(data);
  }
}

class NominatimAddress {
  final String displayName;
  final String city;
  final String state;
  final String country;

  NominatimAddress({
    required this.displayName,
    required this.city,
    required this.state,
    required this.country,
  });

  factory NominatimAddress.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};

   
    final city = address['city'] ??
        address['town'] ??
        address['village'] ??
        address['suburb'] ??
        address['county'] ??
        '';

    return NominatimAddress(
      displayName: json['display_name'] as String? ?? 'Unknown location',
      city: city as String,
      state: address['state'] as String? ?? '',
      country: address['country'] as String? ?? '',
    );
  }
}