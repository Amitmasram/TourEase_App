import 'package:flutter/material.dart';
import 'package:TourEase/core/helpers/helper.dart';
import '../../../core/constants/colors.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<dynamic> _predictions = [];
  Map<String, dynamic>? _selectedPlace;
  bool _isLoading = false;
  Timer? _debounce;
  final Dio _dio = Dio();

  // API key for GoMaps
  final String _apiKey =
      'AlzaSywfSPfswK8WiaPpKAvzIWGqpm5BDsatBOO'; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _getPlacePredictions(_searchController.text);
    });
  }

  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the GoMaps API autocomplete endpoint
      final response = await _dio.get(
        'https://maps.gomaps.pro/maps/api/place/autocomplete/json?input=<string>&key=$_apiKey',
        queryParameters: {
          'input': input,
          'key': _apiKey,
          'components':
              'country:in', // Focus on India, remove this to search worldwide
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        setState(() {
          _predictions = response.data['predictions'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _predictions = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching predictions: $e');
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _selectPrediction(dynamic prediction) async {
    setState(() {
      _isLoading = true;
      _predictions = []; // Clear predictions once selected
    });

    try {
      // Get place details from GoMaps API
      final detailResponse = await _dio.get(
        'https://maps.gomaps.pro/maps/api/place/details/json?place_id=ChIJLU7jZClu5kcR4PcOOO6p3I0&key=$_apiKey',
        queryParameters: {
          'place_id': prediction['place_id'],
          'key': _apiKey,
        },
      );

      if (detailResponse.statusCode == 200 &&
          detailResponse.data['status'] == 'OK') {
        final placeDetails = detailResponse.data['result'];

        setState(() {
          _selectedPlace = placeDetails;
          _searchController.text = prediction['description'];
          _isLoading = false;
        });

        // Show a snackbar to confirm selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${prediction['description']}')),
        );

        // Optionally navigate to a detail page or update the UI further
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error getting place details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Use text search to find places directly
  Future<void> _searchPlaces() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _predictions = [];
    });

    try {
      final response = await _dio.get(
        'https://maps.gomaps.pro/maps/api/place/textsearch/json?query=<string>&key=$_apiKey',
        queryParameters: {
          'query': _searchController.text,
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final results = response.data['results'];
        if (results.isNotEmpty) {
          // Use the first result as selected place
          final placeId = results[0]['place_id'];

          // Get detailed information
          final detailResponse = await _dio.get(
            '',
            queryParameters: {
              'place_id': placeId,
              'key': _apiKey,
            },
          );

          if (detailResponse.statusCode == 200 &&
              detailResponse.data['status'] == 'OK') {
            setState(() {
              _selectedPlace = detailResponse.data['result'];
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching places: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getPhotoUrl(String photoReference) {
    return 'https://maps.gomaps.pro/maps/api/place/photo?photo_reference=$photoReference&maxwidth=400&key=$_apiKey';
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? AppColors.dark : AppColors.light,
      body: Container(
        color: dark ? AppColors.dark : AppColors.light2,
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(dark),
              _buildFilterChips(dark),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )
              else if (_predictions.isNotEmpty)
                _buildPredictionsList(dark)
              else if (_selectedPlace != null)
                _buildSelectedPlaceDetails(dark)
              else
                Expanded(child: _buildRecentSearches(dark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool dark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withOpacity(0.2)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: dark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search destinations...',
          hintStyle: TextStyle(color: dark ? Colors.white70 : Colors.black45),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear,
                      color: dark ? Colors.white70 : Colors.black45),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions = [];
                      _selectedPlace = null;
                    });
                  },
                ),
              IconButton(
                icon: Icon(Icons.search,
                    color: dark ? Colors.white70 : Colors.black45),
                onPressed: _searchPlaces,
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onSubmitted: (_) => _searchPlaces(),
      ),
    );
  }

  Widget _buildFilterChips(bool dark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Popular', 'Recommended', 'Nearby']
            .map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.8),
                    selectedColor: AppColors.secondary,
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter
                          ? Colors.white
                          : (dark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPredictionsList(bool dark) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _predictions.length,
        itemBuilder: (context, index) {
          final prediction = _predictions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: dark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.location_on,
                color: AppColors.secondary,
              ),
              title: Text(
                prediction['structured_formatting']?['main_text'] ??
                    prediction['description'] ??
                    '',
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                prediction['structured_formatting']?['secondary_text'] ?? '',
                style: TextStyle(color: dark ? Colors.white70 : Colors.black54),
              ),
              onTap: () => _selectPrediction(prediction),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedPlaceDetails(bool dark) {
    final place = _selectedPlace!;
    final photos = place['photos'] ?? [];

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place name
            Text(
              place['name'] ?? 'Unknown place',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Address
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place['formatted_address'] ?? 'No address available',
                    style: TextStyle(
                      color: dark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Photos carousel
            if (photos.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length > 5 ? 5 : photos.length,
                  itemBuilder: (context, index) {
                    final photoRef = photos[index]['photo_reference'];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _getPhotoUrl(photoRef),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(child: Text('No image')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      dark ? Colors.black.withOpacity(0.2) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('No photos available')),
              ),
            const SizedBox(height: 16),

            // Rating
            if (place['rating'] != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${place['rating']} / 5.0',
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${place['user_ratings_total'] ?? 0} reviews)',
                    style: TextStyle(
                      color: dark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Place types
            if (place['types'] != null && (place['types'] as List).isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (place['types'] as List).map<Widget>((type) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type.toString().replaceAll('_', ' '),
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  dark,
                  Icons.directions,
                  'Directions',
                  () {
                    // Handle directions button press
                  },
                ),
                _buildActionButton(
                  dark,
                  Icons.save,
                  'Save',
                  () {
                    // Handle save button press
                  },
                ),
                _buildActionButton(
                  dark,
                  Icons.share,
                  'Share',
                  () {
                    // Handle share button press
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      bool dark, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.secondary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: dark ? Colors.white : Colors.black87,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(bool dark) {
    // Placeholder for recent searches or default content
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: dark
                ? Colors.black.withOpacity(0.2)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/100/100?random=$index',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                    child: const Icon(Icons.image, color: Colors.white),
                  );
                },
              ),
            ),
            title: Text(
              'Recent Destination ${index + 1}',
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Popular destination in India',
              style: TextStyle(color: dark ? Colors.white70 : Colors.black54),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: dark ? Colors.white70 : Colors.black45),
          ),
        );
      },
    );
  }
}
