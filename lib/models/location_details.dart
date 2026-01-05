class LocationDetails {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final List<String> types;
  final double? rating;
  final List<String> photos;
  final String? googleMapsUrl;

  LocationDetails({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.types = const [],
    this.rating,
    this.photos = const [],
    this.googleMapsUrl,
  });
}
