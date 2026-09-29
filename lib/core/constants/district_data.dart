class DistrictDefinition {
  final String id;
  final String name;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final int minZoom;
  final int maxZoom;

  const DistrictDefinition({
    required this.id,
    required this.name,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    this.minZoom = 11,
    this.maxZoom = 14,
  });

  bool contains(double lat, double lng) {
    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }
}

class DistrictData {
  static const List<DistrictDefinition> districts = [
    DistrictDefinition(
      id: 'dhaka_district',
      name: 'Dhaka District',
      minLat: 23.68,
      maxLat: 23.90,
      minLng: 90.30,
      maxLng: 90.52,
      minZoom: 11,
      maxZoom: 14,
    ),
    DistrictDefinition(
      id: 'chittagong_district',
      name: 'Chittagong District',
      minLat: 22.25,
      maxLat: 22.45,
      minLng: 91.75,
      maxLng: 91.90,
      minZoom: 11,
      maxZoom: 14,
    ),
    DistrictDefinition(
      id: 'sylhet_district',
      name: 'Sylhet District',
      minLat: 24.85,
      maxLat: 24.95,
      minLng: 91.80,
      maxLng: 91.95,
      minZoom: 11,
      maxZoom: 14,
    ),
    DistrictDefinition(
      id: 'rajshahi_district',
      name: 'Rajshahi District',
      minLat: 24.30,
      maxLat: 24.42,
      minLng: 88.55,
      maxLng: 88.65,
      minZoom: 11,
      maxZoom: 14,
    ),
  ];

  static DistrictDefinition? detectDistrict(double lat, double lng) {
    for (final d in districts) {
      if (d.contains(lat, lng)) return d;
    }
    return null;
  }
}
