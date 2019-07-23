import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSLocator{

  static const int _gpsCaptureTimeOut = 15; // in seconds

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator().isLocationServiceEnabled();
  }

  static Future<GeolocationStatus> checkPermission() async {
    GeolocationStatus geolocationStatus = await Geolocator()
        .checkGeolocationPermissionStatus();
    return geolocationStatus;
  }

  static Future<Position> getOneTimeLocation() async {

    //GeolocationStatus geolocationStatus = await Geolocator()
        //.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.location);

    GeolocationStatus geolocationStatus = await GPSLocator.checkPermission();


    switch (geolocationStatus) {
      case GeolocationStatus.granted:
        {

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
      /*case GeolocationStatus.denied:{

           return _askPermission();

      }*/
    }
    return null;
  }


  static askPermission() async {
    //PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]).then(GPSLocator._onStatusRequest);
    await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
  }

  static _onStatusRequest(Map<PermissionGroup,PermissionStatus> statuses){
    final status = statuses[PermissionGroup.locationWhenInUse];

    if(status != PermissionStatus.granted){
      PermissionHandler().openAppSettings();
    }
  }

}