import 'package:geolocator/geolocator.dart';

class GPSHelper {
  static const double officeLat = 22.8171345;
  static const double officeLng = 72.473485;
  static const double radius = 100.0; // Allowed radius in meters

  static Future<bool> checkLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return false;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double distance = Geolocator.distanceBetween(
        officeLat, officeLng, position.latitude, position.longitude);

    return distance <= radius;
  }
}
