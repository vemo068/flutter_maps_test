import 'package:flutter_maps_test/main.dart';
import 'package:flutter_maps_test/polydraw.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<Marker> mymarks = {
  Marker(
    
      markerId: MarkerId("ikama1"),
      position: LatLng(33.391, 6.8546921),
      onTap: () {
        drwp(LatLng(33.3946401, 6.8546921));
      },
      draggable: false,
      zIndex: 2,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
  Marker(
      markerId: MarkerId("ikama2"),
      position: LatLng(33.3947561, 6.8546597),
      onTap: () {
        drwp(LatLng(33.3947561, 6.8546597));
      },
      draggable: false,
      zIndex: 2,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
  Marker(
      markerId: MarkerId("fac1"),
      position: LatLng(33.3948541, 6.8549375),
      onTap: () {
        drwp(LatLng(33.3948541, 6.8549375));
      },
      draggable: false,
      zIndex: 2,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
  Marker(
      markerId: MarkerId("ticno"),
      position: LatLng(33.39516, 6.8547279),
      onTap: () {
        drwp(LatLng(33.39516, 6.8547279));
      },
      draggable: false,
      zIndex: 2,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
};

List<LatLng> mrlist = [];

void drwp(LatLng pos) {
  mrlist.add(pos);
  if (mrlist.length == 2) {
    
    PolylineService poly = PolylineService();
    poly.drawPolyline(mrlist[0], pos);
  }
}

