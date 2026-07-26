import 'package:dio/dio.dart';

import '../models/store_model.dart';

class MapRepository {
  static const apiKey =
      "6d307da6682442bfbf093f777655b089";

  final Dio dio = Dio();

  Future<List<StoreModel>> getNearbyStores(
      double lat,
      double lon,
      ) async {

    final response = await dio.get(
      "https://api.geoapify.com/v2/places",
      queryParameters: {
        "categories":
        "commercial.supermarket,commercial.convenience",
        "filter":
        "circle:$lon,$lat,3000",
        "bias":
        "proximity:$lon,$lat",
        "limit": 20,
        "apiKey": apiKey,
      },
    );

    final List features =
        response.data["features"] ?? [];

    return features
        .map((e) => StoreModel.fromJson(e))
        .toList();
  }
}