import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'nearbyHosp.dart';

class MarkerService {
  List<Marker> getMarkers(List<Hospital> hosp) {
    var markers = <Marker>[];

    hosp.forEach((hospital) {
      Marker marker = Marker(
          markerId: MarkerId(hospital.id),
          draggable: false,
          infoWindow: InfoWindow(title: hospital.name, snippet: hospital.addr),
          position: LatLng(hospital.lat, hospital.lon));
      markers.add(marker);
    });
    return markers;
  }
}
