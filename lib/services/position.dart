// lib/services/position.dart

import 'package:geolocator/geolocator.dart';

class LatLng {
  final double latitude;
  final double longitude;
  const LatLng(this.latitude, this.longitude);
}

Future<LatLng?> getCurrentPosition() async {
  try {
    final bool serviceActif = await Geolocator.isLocationServiceEnabled();
    if (!serviceActif) {
      print('GPS désactivé');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permission GPS refusée');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Permission GPS refusée définitivement');
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Position GPS : ${position.latitude}, ${position.longitude}');
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    print('Erreur GPS : $e');
    return null;
  }
}