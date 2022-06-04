import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_maps_test/my_markers.dart';
import 'package:flutter_maps_test/polydraw.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37, -122),
      zoom: 10,
    );
    return MaterialApp(
      home: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker;
  late Circle circle;
  late BitmapDescriptor customIcon;
  late BitmapDescriptor customIcon2;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/mybitmap.png')
        .then((d) {
      customIcon = d;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), 'assets/mybitmap2.png')
        .then((d) {
      customIcon2 = d;
    });
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.3957642, 6.8588545),
    zoom: 14.55,
  );
  late Marker _origin;

  late Marker _destination;
  late GoogleMapController _googleMapController;
  Set<Polyline> mypolylines = {};
  Set<Circle> mycircles = {};
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        getCurrentLocation();
      }),
      appBar: AppBar(
        title: Text("hello maps"),
        actions: [
          TextButton(
              onPressed: () {
                drawPolyline(mrlist[1], mrlist[3]);
              },
              child: Text("drow"))
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          mapToolbarEnabled: true,
          myLocationEnabled: true,
          onLongPress: (LatLng pos) {},
          onMapCreated: (controller) => _googleMapController = controller,
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          markers: mymarks,
          polylines: mypolylines,
          circles: mycircles,
        ),
      ]),
    );
  }

  Future<void> drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to);

    mypolylines.add(polyline);

    setState(() {});
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      // if (_locationSubscription != null) {
      // _locationSubscription.cancel();
      // }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_googleMapController != null) {
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 0,
                  zoom: 20)));

          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void updateMarkerAndCircle(
      LocationData newLocalData, Uint8List imageData) async {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      marker = Marker(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return MarkerBottomSheet(
                    ctx: context,
                  );
                });
          },
          markerId: MarkerId("home"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          icon: customIcon2);
      mymarks.add(marker);
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
      mycircles.add(circle);
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/mybitmap.png");
    return byteData.buffer.asUint8List();
  }
}

class MarkerBottomSheet extends StatelessWidget {
  const MarkerBottomSheet({Key? key, required this.ctx}) : super(key: key);
  final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(ctx).size;

    return Container(
      height: sizes.height / 2,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: PageView.builder(
                  itemCount: images.length,
                  pageSnapping: true,
                  itemBuilder: (context, pagePosition) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(images[pagePosition]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                    );
                  })),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "la Piscine",
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                Expanded(
                    child: Text(
                  "lorem epsum",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                )),
                Expanded(
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              "Direction",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.directions,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

var images = [
  "https://cdn.narellanpools.com.au/wp-content/uploads/2020/12/5-Benefits-of-Small-Pools.jpg",
  "https://published-assets.ari-build.com/Content/Published/Site/26240/hero/pool6.jpg"
];
