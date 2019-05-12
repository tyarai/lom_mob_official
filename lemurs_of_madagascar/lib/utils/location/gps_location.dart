import 'package:location/location.dart';

class GPSLocation {

  static Future<LocationData> getOneTimeLocation() async {

    var currentLocation;
    var location = new Location();

    try{
      currentLocation = await location.getLocation();
    } catch(e){
      print("LOCATION CLASS ERROR:" + e.toString());
      currentLocation = null;
    }

    return currentLocation;
  }

}