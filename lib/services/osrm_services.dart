import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OsrmServices {
  final Dio _dio = Dio();

  Future<List<LatLng>> getRouts(LatLng start, LatLng end) async {
    List<LatLng> routesPoint = [];

    try {
      final response = await _dio.get(
        "http://router.project-osrm.org/route/v1/driving/"
        "${start.longitude},${start.latitude};${end.longitude},${end.latitude}"
        "?geometries=geojson&overview=full",
      );

      if (response.statusCode == 200 && response.data["routes"] != null && response.data["routes"].isNotEmpty) {
        final route = response.data["routes"][0];
        final geometry = route["geometry"]["coordinates"] as List;

        routesPoint = geometry
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      } else {
        print("⚠️ No valid route found between these points.");
      }
    } catch (e) {
      print("❌ Error fetching route: $e");
    }

    return routesPoint;
  }
}
