import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveLocationTrackerScreen extends StatefulWidget {
  const LiveLocationTrackerScreen({super.key});

  @override
  State<LiveLocationTrackerScreen> createState() =>
      _LiveLocationTrackerScreenState();
}

class _LiveLocationTrackerScreenState extends State<LiveLocationTrackerScreen> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late Location location;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 12, target: LatLng(31.040848110485165, 31.37790918658407));
    location = Location();
    initMyLocation();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }

//change style of Map
  void initMapStyle() async {
    String nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController!.setMapStyle(nightMapStyle);
  }

//Check and Request Location Service
  Future<void> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        //TODO: for EX Show Error Bar
      }
    }
    checkAndRequestLocationPermission();
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

//get Location Data
  void getLocationData() {
    location.onLocationChanged.listen((locationData) {
      print('Location Data $locationData');
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 12);
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

// Init / Set / Update  My Location combine 3 method
  void initMyLocation() async {
    await checkAndRequestLocationService();
    bool hasPermission = await checkAndRequestLocationPermission();
    if (hasPermission) {
      getLocationData();
    } else {
      //TDOD :what i do if i have't the permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          zoomControlsEnabled: false, //to hide buttons + or -
          mapType: MapType.normal,
          onMapCreated: (controller) {
            googleMapController = controller;
            initMapStyle();
          },
          // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          //     southwest: LatLng(30.81060297231051, 31.006794158157287),
          //     northeast: LatLng(31.22618105153738, 31.6390689658919))),
          initialCameraPosition: initialCameraPosition),
    );
  }
}
