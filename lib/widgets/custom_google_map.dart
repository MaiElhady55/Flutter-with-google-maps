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
    initPolylines();
    initPolygons();
    initCircles();
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

//********************************************** */
  Set<Polyline> polylines = {};
  void initPolylines() {
    Polyline polyline = const Polyline(
        polylineId: PolylineId('1'),
        points: [
          LatLng(31.03751258256957, 31.402736503836568),
          LatLng(31.109379649336407, 31.30261269990944),
          LatLng(31.062240642241903, 31.399094208169885)
        ],
        color: Colors.red,
        zIndex: 2,
        startCap: Cap.roundCap,
        width: 5);
    Polyline polyline2 = const Polyline(
        polylineId: PolylineId('2'),
        points: [
          LatLng(31.062310963505734, 31.308072742075833),
          LatLng(31.11072439864407, 31.36359918911516),
        ],
        color: Colors.black,
        zIndex: 1,
        patterns: [PatternItem.dot],
        geodesic: true,
        startCap: Cap.roundCap,
        width: 5);

    polylines.add(polyline);
    polylines.add(polyline2);
  }

//********************************************** */
  Set<Polygon> polygons = {};
  void initPolygons() {
    Polygon polygon = Polygon(
        polygonId: const PolygonId('1'),
        points: const [
          LatLng(31.09626842897352, 31.29828230546987),
          LatLng(31.0627112841415, 31.308209478768074),
          LatLng(31.058655461629243, 31.240412349630695),
          LatLng(31.09626842897352, 31.29828230546987),
        ],
        fillColor: Colors.black.withOpacity(0.5),
        strokeWidth: 3,
        holes: const [
          [
            LatLng(31.07358695835032, 31.28535878902533),
            LatLng(31.063618834103806, 31.281980762474404),
            LatLng(31.066867616872553, 31.249198004346063),
          ]
        ]);
    polygons.add(polygon);
  }


//********************************************** */
  Set<Circle> circles = {};
  void initCircles() {
    Circle circle =Circle(circleId: CircleId('1'),
    center: LatLng(31.040446979157814, 31.341544230648935),
    radius: 1000,
fillColor: Colors.red,
strokeWidth: 3
    );

  circles.add(circle);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            zoomControlsEnabled: false, //to hide buttons + or -
            markers: markers,
            polylines: polylines,
            polygons: polygons,
            circles: circles,
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
