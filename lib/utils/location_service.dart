import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  //Check and Request Location Service
  Future<bool> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        //TODO: for EX Show Error Bar
        return false;
      }
    }
    return true;
  }

  //Check and Request Location Permission
  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
        //TODO: for EX Show Error Bar
      }
    }
    // mean that the permisssion in the began is allaow (granted)
    return true;
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.onLocationChanged.listen(onData);
  }
}
