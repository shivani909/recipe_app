import 'dart:convert';
import 'package:http/http.dart' as http;

/// Talks to Nominatim (OpenStreetMap's free reverse-geocoding service).
/// Docs: https://nominatim.org/release-docs/latest/api/Reverse/
///
/// Deliberately uses the plain `http` package here instead of the app's
/// shared Dio client, since Nominatim's usage policy requires a custom
/// User-Agent header identifying the app (not tied to a base API config).
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
        // Nominatim's usage policy requires a descriptive User-Agent.
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

    // Nominatim doesn't always populate "city" - fall back through the
    // other locality-ish fields it commonly returns instead.
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