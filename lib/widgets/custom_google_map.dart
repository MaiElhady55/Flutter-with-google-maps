import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
        zoom: 12, target: LatLng(31.040848110485165, 31.37790918658407));
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
            },
            // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            //     southwest: LatLng(30.81060297231051, 31.006794158157287),
            //     northeast: LatLng(31.22618105153738, 31.6390689658919))),
            initialCameraPosition: initialCameraPosition),
        Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
                onPressed: () {
                  // CameraPosition newLocation = const CameraPosition(
                  //    zoom: 12, target: LatLng(30.786924930349898, 31.00083304398054));
                  googleMapController.animateCamera(
                      CameraUpdate.newLatLng(LatLng(30.786924930349898, 31.00083304398054)));
                },
                child: const Text('Change Location')))
      ],
    );
  }
}
