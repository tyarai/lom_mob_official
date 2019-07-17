import 'package:geolocator/geolocator.dart';

class GPSLocator{

  static const int _gpsCaptureTimeOut = 15; // in seconds

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  static Future<Position> getOneTimeLocation() async {

    GeolocationStatus geolocationStatus = await Geolocator()
        .checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
      case GeolocationStatus.granted:
        {
          return Geolocator().getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
              .timeout(Duration(seconds: _gpsCaptureTimeOut))
              .then((_position) {
            //getting position without problems
            return _position;
          }).catchError((error) {
            return null;
          });
        }
    }
    return null;
  }
}