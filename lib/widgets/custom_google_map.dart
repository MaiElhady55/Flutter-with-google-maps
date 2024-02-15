import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaps_app/models/place_model.dart';
import 'dart:ui' as ui;

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
    initialCameraPosition = const CameraPosition(
        zoom: 12, target: LatLng(31.040848110485165, 31.37790918658407));
    initMarkers();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  void initMapStyle() async {
    String nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
  }

//Change marker size if i get it from api and i can not acces it
  Future<Uint8List> getImageFromRawData(
      {required String image, required double width}) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());
    var imageFrameInfo = await imageCodec.getNextFrame();
    var imageByteData =
        await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByteData!.buffer as Uint8List;
  }

  Set<Marker> markers = {};
  void initMarkers() async {
    // if image size is good and correct
    var customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/marker.png');
    // if i need change marker size by code
    // var customMarkerIcon = BitmapDescriptor.fromBytes(await getImageFromRawData(
    //     image: 'assets/images/marker.png', width: 250));
    var myMarkers = places
        .map((placeModel) => Marker(
            icon: customMarkerIcon,
            infoWindow: InfoWindow(title: placeModel.name),
            position: placeModel.latLng,
            markerId: MarkerId(placeModel.id.toString())))
        .toSet();
    markers.addAll(myMarkers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              googleMapController = controller;
              initMapStyle();
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
                  // googleMapController.animateCamera(
                  //     CameraUpdate.newCameraPosition(newLocation));
                  //OOOOORRRRRR depend on what you need to update
                  googleMapController.animateCamera(CameraUpdate.newLatLng(
                      const LatLng(30.786924930349898, 31.00083304398054)));
                },
                child: const Text('Change Location')))
      ],
    );
  }
}
