import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entity/hospital.dart';

class MarkerService {
  List<Marker> getMarkers(List<Hospital> hospitalList) {
    var markers = <Marker>[];

    for (var hospital in hospitalList) {
      Marker marker = Marker(
          markerId: MarkerId(hospital.id),
          draggable: false,
          infoWindow: InfoWindow(
              title: hospital.name, snippet: hospital.freeformAddress),
          position: LatLng(hospital.lat, hospital.lng));
      markers.add(marker);
    }
    return markers;
  }
}