import 'package:geolocator/geolocator.dart';

class GPSLocator{

  static const int _gpsCaptureTimeOut = 15; // in seconds

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  static Future<Position> getOneTimeLocation() async {

    GeolocationStatus geolocationStatus = await Geolocator()
        .checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse);


    switch (geolocationStatus) {
      case GeolocationStatus.granted:
        {
          print("#1");
          return Geolocator().getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
              .timeout(Duration(seconds: _gpsCaptureTimeOut))
              .then((_position) {
                print("Getting location data....");
            //getting position without problems
            return _position;
          }).catchError((error) {
            return null;
          });
        }
      case GeolocationStatus.denied:{
        print("Location denied");
      }
    }
    return null;
  }
}