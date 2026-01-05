import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:TourEase/models/hills_model.dart';


class LocationService {
  static const String apiKey = 'AlzaSymk82ZnIMNMwv5vOhnwOtye026nyIMDkPN';

  Future<List<LocationModel>> fetchLocations(List<String> queries) async {
    List<LocationModel> allLocations = [];

    for (var query in queries) {
      final url = Uri.parse(
        'https://maps.gomaps.pro/maps/api/place/textsearch/json?query=$query&type=tourist_attraction&key=$apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        for (var place in results) {
          final detailsUrl = Uri.parse(
            'https://maps.gomaps.pro/maps/api/place/details/json?place_id=${place['place_id']}&fields=name,formatted_address,geometry,photos,editorial_summary&key=$apiKey'
          );

          final detailsResponse = await http.get(detailsUrl);
          final detailsData = json.decode(detailsResponse.body)['result'];

          List<String> photoUrls = [];
          if (detailsData['photos'] != null) {
            photoUrls = (detailsData['photos'] as List).take(3).map((photo) =>
              'https://maps.gomaps.pro/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=$apiKey'
            ).toList();
          }

          allLocations.add(LocationModel(
            id: place['place_id'],
            name: place['name'],
            shortLocation: place['formatted_address'],
            fullAddress: detailsData['formatted_address'] ?? '',
            images: photoUrls,
            features: [
              'Scenic Views',
              'Photography Spot',
              'Nature Exploration'
            ],
            latitude: place['geometry']['location']['lat'],
            longitude: place['geometry']['location']['lng'],
            description: detailsData['editorial_summary']?['overview'] ?? 'A beautiful travel destination.',
          ));
        }
      }
    }
    return allLocations;
  }

  Future<List<LocationModel>> fetchMountainLocations() async {
    return fetchLocations([
      'mountains in India',
      'mountains in Nepal',
      'mountains in Switzerland'
    ]);
  }

  Future<List<LocationModel>> fetchLakeLocations() async {
    return fetchLocations([
      'lakes in India',
      'lakes in Canada',
      'lakes in USA'
    ]);
  }

  Future<List<LocationModel>> fetchCityLocations() async {
    return fetchLocations([
      'popular cities in Europe',
      'famous cities in Asia',
      'tourist cities in the USA'
    ]);
  }

  Future<List<LocationModel>> fetchTrekkingLocations() async {
    return fetchLocations([
      'best trekking spots in India',
      'famous trekking trails in Nepal',
      'hiking trails in Switzerland'
    ]);
  }
}
