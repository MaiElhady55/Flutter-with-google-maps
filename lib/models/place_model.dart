import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(
      id: 1,
      name: 'ستاد المنصورة',
      latLng: const LatLng(31.03751258256957, 31.402736503836568)),
  PlaceModel(
      id: 2,
      name: 'مستشفي نبروه',
      latLng: const LatLng(31.109379649336407, 31.30261269990944)),
  PlaceModel(
      id: 3,
      name: 'Metro Market',
      latLng: const LatLng(31.062240642241903, 31.399094208169885))
];
