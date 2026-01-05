import 'package:TourEase/models/hills_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/helpers/helper.dart';
import 'package:TourEase/models/hills_model.dart';

import 'details_screens/hills_location.dart';


class LakesScreen extends StatefulWidget {
  const LakesScreen({super.key});

  @override
  _LakesScreenState createState() => _LakesScreenState();
}

class _LakesScreenState extends State<LakesScreen> {
  List<LocationModel> _locations = [];
  bool _isLoading = true;
  final LocationService _locationsService = LocationService();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final locations = await _locationsService.fetchLakeLocations();
      setState(() {
        _locations = locations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load locations: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? AppColors.dark : AppColors.light,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final location = _locations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HillsDetailsScreen(location: location)));
                    },
                    child: _buildLocationCard(location, dark),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildLocationCard(LocationModel location, bool dark) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: dark ? Colors.grey[800] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              location.images.isNotEmpty ? location.images.first : '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  location.name,
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: dark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location.shortLocation.split(' ').take(2).join(' '),
                  style: TextStyle(
                  fontSize: 14,
                  color: dark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
