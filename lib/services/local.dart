import 'package:geolocator/geolocator.dart';

// obter a localização atual

import 'package:geolocator/geolocator.dart';

Future<String> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return 'Serviço de localização desativado';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return 'Permissão negada pelo usuário';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return 'Permissão permanentemente negada';
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  }

  return 'Permissão de localização não concedida';
}
