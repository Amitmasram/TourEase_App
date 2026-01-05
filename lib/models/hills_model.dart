class LocationModel {
  final String id;
  final String name;
  final String shortLocation;
  final String fullAddress;
  final List<String> images;
  final List<String> features;
  final double latitude;
  final double longitude;
  final String description;

  LocationModel({
    required this.id,
    required this.name,
    required this.shortLocation,
    required this.fullAddress,
    required this.images,
    required this.features,
    required this.latitude,
    required this.longitude,
    required this.description,
  });
}
