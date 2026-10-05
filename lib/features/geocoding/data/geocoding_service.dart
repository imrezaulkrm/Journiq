import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

abstract class IGeocodingService {
  Future<String?> reverseGeocode(double latitude, double longitude);
}

class NominatimGeocodingService implements IGeocodingService {
  final http.Client _client;
  final Map<String, String> _memoryCache = {};
  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);

  NominatimGeocodingService([http.Client? client])
    : _client = client ?? http.Client();

  @override
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    // 2-decimal rounded key gives ~1.1 km spatial grid cache
    final cacheKey =
        '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey];
    }

    // Rate-limiting: OSM Nominatim policy requires max 1 request/second
    final now = DateTime.now();
    final elapsed = now.difference(_lastRequestTime).inMilliseconds;
    if (elapsed < 1100) {
      await Future.delayed(Duration(milliseconds: 1100 - elapsed));
    }
    _lastRequestTime = DateTime.now();

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?'
        'lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );

      final response = await _client
          .get(uri, headers: {'User-Agent': AppConstants.userAgent})
          .timeout(const Duration(seconds: 6));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      // Extract meaningful area (neighborhood, suburb, town, city, district)
      final area =
          address['suburb'] ??
          address['neighbourhood'] ??
          address['quarter'] ??
          address['residential'] ??
          address['city_district'] ??
          address['town'] ??
          address['city'] ??
          address['county'] ??
          address['state_district'];

      if (area != null && area is String && area.trim().isNotEmpty) {
        final trimmed = area.trim();
        _memoryCache[cacheKey] = trimmed;
        return trimmed;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
