import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaps_app/utils/location_service.dart';
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
  //late Location location;
  late LocationService locationService;
  bool isFirstCall = true;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 1, target: LatLng(31.040848110485165, 31.37790918658407));
    //location = Location();
    locationService = LocationService();
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

//get Location Data
  // void getLocationData() {
  //   location.onLocationChanged.listen((locationData) {
  //     print('Location Data $locationData');
  //     location.changeSettings(distanceFilter: 2);
  //     CameraPosition cameraPosition = CameraPosition(
  //         target: LatLng(locationData.latitude!, locationData.longitude!),
  //         zoom: 12);
  //     Marker myLocationMarker = Marker(
  //         markerId: const MarkerId('1'),
  //         position: LatLng(locationData.latitude!, locationData.longitude!));
  //     markers.add(myLocationMarker);
  //     setState(() {});
  //     googleMapController
  //         ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   });
  // }

// Init / Set / Update  My Location combine 3 method
  void initMyLocation() async {
    await locationService.checkAndRequestLocationService();
    bool hasPermission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPermission) {
      locationService.getRealTimeLocationData((locationData) {
        locationService.location.changeSettings(distanceFilter: 2);
        setMyCameraPosition(locationData);
        setMyLocationMarker(locationData);
      });
    } else {
      //TDOD :what i do if i have't the permission
    }
  }

  void setMyCameraPosition(LocationData locationData) {
    if (isFirstCall) {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 12);
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      isFirstCall = false;
    } else {
      googleMapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!)));
    }
  }

  void setMyLocationMarker(LocationData locationData) {
    Marker myLocationMarker = Marker(
        markerId: const MarkerId('1'),
        position: LatLng(locationData.latitude!, locationData.longitude!));
    markers.add(myLocationMarker);
    setState(() {});
  }

//Markers
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          zoomControlsEnabled: false, //to hide buttons + or -
          mapType: MapType.normal,
          markers: markers,
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
