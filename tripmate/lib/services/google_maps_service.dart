import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/activity.dart';

class GoogleMapsService {
  static GoogleMapController? _controller;
  static const String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with actual API key

  // Initialize map controller
  static void setController(GoogleMapController controller) {
    _controller = controller;
  }

  // Default camera position (San Francisco)
  static const CameraPosition defaultPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12.0,
  );

  // Create markers from activities
  static Set<Marker> createMarkersFromActivities(List<Activity> activities) {
    Set<Marker> markers = {};

    for (Activity activity in activities) {
      if (activity.hasCoordinates) {
        markers.add(
          Marker(
            markerId: MarkerId(activity.id),
            position: LatLng(activity.latitude!, activity.longitude!),
            infoWindow: InfoWindow(
              title: activity.title,
              snippet: '${activity.location} • ${activity.formattedDuration}',
            ),
            icon: _getMarkerIcon(activity.category),
          ),
        );
      }
    }

    return markers;
  }

  // Get marker icon based on activity category (using default markers for now)
  static BitmapDescriptor _getMarkerIcon(String category) {
    // Since we can't use custom icons without additional setup,
    // we'll use different colored default markers
    switch (category.toLowerCase()) {
      case 'food':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'sightseeing':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'adventure':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'shopping':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
      case 'entertainment':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case 'transport':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case 'accommodation':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  // Move camera to specific location
  static Future<void> moveToLocation(LatLng location, {double zoom = 15.0}) async {
    if (_controller != null) {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: zoom),
        ),
      );
    }
  }

  // Move camera to show all activities
  static Future<void> showAllActivities(List<Activity> activities) async {
    if (_controller == null || activities.isEmpty) return;

    List<Activity> activitiesWithCoordinates = activities
        .where((activity) => activity.hasCoordinates)
        .toList();

    if (activitiesWithCoordinates.isEmpty) return;

    if (activitiesWithCoordinates.length == 1) {
      await moveToLocation(
        LatLng(
          activitiesWithCoordinates.first.latitude!,
          activitiesWithCoordinates.first.longitude!,
        ),
      );
      return;
    }

    // Calculate bounds to show all activities
    double minLat = activitiesWithCoordinates.first.latitude!;
    double maxLat = activitiesWithCoordinates.first.latitude!;
    double minLng = activitiesWithCoordinates.first.longitude!;
    double maxLng = activitiesWithCoordinates.first.longitude!;

    for (Activity activity in activitiesWithCoordinates) {
      minLat = minLat < activity.latitude! ? minLat : activity.latitude!;
      maxLat = maxLat > activity.latitude! ? maxLat : activity.latitude!;
      minLng = minLng < activity.longitude! ? minLng : activity.longitude!;
      maxLng = maxLng > activity.longitude! ? maxLng : activity.longitude!;
    }

    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  // Search for places (mock implementation)
  static Future<List<PlaceSearchResult>> searchPlaces(String query) async {
    // Mock search results for demo purposes
    await Future.delayed(const Duration(seconds: 1));

    return [
      PlaceSearchResult(
        name: 'Golden Gate Bridge',
        address: 'Golden Gate Bridge, San Francisco, CA',
        latitude: 37.8199,
        longitude: -122.4783,
        placeId: 'mock_place_1',
      ),
      PlaceSearchResult(
        name: 'Fisherman\'s Wharf',
        address: 'Fisherman\'s Wharf, San Francisco, CA',
        latitude: 37.8080,
        longitude: -122.4177,
        placeId: 'mock_place_2',
      ),
      PlaceSearchResult(
        name: 'Alcatraz Island',
        address: 'Alcatraz Island, San Francisco, CA',
        latitude: 37.8267,
        longitude: -122.4233,
        placeId: 'mock_place_3',
      ),
    ];
  }

  // Get place details (mock implementation)
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock place details
    switch (placeId) {
      case 'mock_place_1':
        return PlaceDetails(
          name: 'Golden Gate Bridge',
          address: 'Golden Gate Bridge, San Francisco, CA',
          latitude: 37.8199,
          longitude: -122.4783,
          placeId: placeId,
          rating: 4.7,
          phoneNumber: null,
          website: 'https://www.goldengate.org/',
          openingHours: ['Open 24 hours'],
        );
      case 'mock_place_2':
        return PlaceDetails(
          name: 'Fisherman\'s Wharf',
          address: 'Fisherman\'s Wharf, San Francisco, CA',
          latitude: 37.8080,
          longitude: -122.4177,
          placeId: placeId,
          rating: 4.2,
          phoneNumber: '+1 415-674-7503',
          website: 'https://www.fishermanswharf.org/',
          openingHours: ['6:00 AM – 10:00 PM'],
        );
      default:
        return null;
    }
  }

  // Calculate distance between two points (Haversine formula)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = (dLat / 2) * (dLat / 2) +
        _degreesToRadians(lat1) *
            _degreesToRadians(lat2) *
            (dLon / 2) *
            (dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Get current location (mock implementation)
  static Future<LatLng?> getCurrentLocation() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock current location (San Francisco)
      return const LatLng(37.7749, -122.4194);
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Dispose resources
  static void dispose() {
    _controller = null;
  }
}

// Place search result model
class PlaceSearchResult {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;

  PlaceSearchResult({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });
}

// Place details model
class PlaceDetails {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;
  final double? rating;
  final String? phoneNumber;
  final String? website;
  final List<String>? openingHours;

  PlaceDetails({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.rating,
    this.phoneNumber,
    this.website,
    this.openingHours,
  });
}

// Import required for calculations
import 'dart:math' show atan2, sqrt, pi;
