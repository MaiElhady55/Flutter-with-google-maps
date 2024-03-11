import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationTrackerScreen extends StatefulWidget {
  const LiveLocationTrackerScreen({super.key});

  @override
  State<LiveLocationTrackerScreen> createState() =>
      _LiveLocationTrackerScreenState();
}

class _LiveLocationTrackerScreenState extends State<LiveLocationTrackerScreen> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 12, target: LatLng(31.040848110485165, 31.37790918658407));

    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  //change style of Map
  void initMapStyle() async {
    String nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
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
