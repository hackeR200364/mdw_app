import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<void> requestLocationPermission(BuildContext context) async {
    LocationPermission permission;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable it
      showLocationServiceDialog(context);
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle accordingly
        showPermissionDeniedDialog(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle accordingly
      showPermissionDeniedForeverDialog(context);
      return;
    }

    // When permissions are granted, you can get the location
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // print('Location: ${position.latitude}, ${position.longitude}');
  }

  void showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content:
            const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content:
            const Text('Location permission is required to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void showPermissionDeniedForeverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Permanently Denied'),
        content: const Text(
            'Location permission is permanently denied. Please enable it in the app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
