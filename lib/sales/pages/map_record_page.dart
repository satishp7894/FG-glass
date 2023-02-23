import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/travel_record.dart';

class MapRecordPage extends StatefulWidget {
  final List<Locations> mapRecord;
  final Locations mark;
  final Locations first;
  final Locations last;

  MapRecordPage(
      {required this.mapRecord,
      required this.mark,
      required this.first,
      required this.last});

  @override
  _MapRecordPageState createState() => _MapRecordPageState();
}

class _MapRecordPageState extends State<MapRecordPage> {
  BitmapDescriptor? _destIcon, _markerIcon, _allIcon;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> _mapPolyLines = {};

  // Roads? _info;
  // List<LatLng> latLogList = <LatLng>[];

  _setMarkers() {
    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: LatLng(
        widget.mapRecord.first.lat!,
        widget.mapRecord.first.lng!,
      ),
      infoWindow: InfoWindow(title: 'Start'),
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers.add(startMarker);

    Marker stopMarker = Marker(
      markerId: MarkerId('stop'),
      position: LatLng(
        widget.mapRecord.last.lat!,
        widget.mapRecord.last.lng!,
      ),
      infoWindow: InfoWindow(title: 'Stop'),
      icon: _destIcon!,
    );
    _markers.add(stopMarker);
  }

  _createPolyLine() async {
    PolylineId id = PolylineId('poly');
    var allPoints = await _createPoints();
    List<LatLng> latLogAllList = <LatLng>[];
    latLogAllList = allPoints;
    print("points returned ${allPoints.length} \n ${allPoints}");
    setState(() {
      Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: latLogAllList
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
          width: 3);
      _mapPolyLines[id] = polyline;
    });

    // setState(() {
    //   latLogList = _createPoints();
    // });
    // String wayPoints="";
    //
    // for (int i = 0; i < latLogList.length; i++) {
    //   wayPoints=wayPoints + latLogList[i].latitude.toString() +","+latLogList[i].longitude.toString() + '|';
    //   // wayPoints=wayPoints + '{"lat":"${latLogList[i].latitude.toString()}","lng":"${latLogList[i].longitude.toString()}"}' + ',';
    // }
    // print("_startPosition ${widget.mapRecord.first.lat} , ${widget.mapRecord.first.lng}");
    // print("endPosition ${widget.mapRecord.last.lat} , ${widget.mapRecord.last.lng}");
    // print("wayPoints $wayPoints");
    // String result = wayPoints.substring(0, wayPoints.length - 1);
    //
    // print("result ${result}");
    //
    // final directions = await DirectionBloc()
    //     .getDirections(origin: LatLng(widget.mapRecord.first.lat, widget.mapRecord.first.lng), destination: LatLng(widget.mapRecord.last.lat, widget.mapRecord.last.lng),waypoints: result);
    // setState(() {
    //   _info = directions;
    // });
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    print("object map record length ${widget.mapRecord.length}");
    for (int i = 0; i < widget.mapRecord.length; i++) {
      points.add(LatLng(widget.mapRecord[i].lat!, widget.mapRecord[i].lng!));
      print("object points $i ---- ${widget.mapRecord[i].lat}");

      Marker allMarker = Marker(
        markerId: MarkerId('${widget.mapRecord[i].lat}'),
        position: LatLng(
          widget.mapRecord[i].lat!,
          widget.mapRecord[i].lng!,
        ),
        infoWindow: InfoWindow(
            title: "${widget.mapRecord[i].lat} : ${widget.mapRecord[i].lng}"),
        icon: _allIcon!,
      );

      _markers.add(allMarker);
    }

    return points;
  }

  // _remapView() {
  //   Position _northeastCoordinates;
  //   Position _southwestCoordinates;
  //
  //   // Calculating to check that the position relative
  //   // to the frame, and pan & zoom the camera accordingly.
  //   double miny = (widget.mapRecord['start']['lat'] <= widget.mapRecord['end']['lat'])
  //       ? widget.mapRecord['start']['lat']
  //       : widget.mapRecord['end']['lat'];
  //   double minx = (widget.mapRecord['start']['long'] <= widget.mapRecord['end']['long'])
  //       ? widget.mapRecord['start']['long']
  //       : widget.mapRecord['end']['long'];
  //   double maxy = (widget.mapRecord['start']['lat'] <= widget.mapRecord['end']['lat'])
  //       ? widget.mapRecord['end']['lat']
  //       : widget.mapRecord['start']['lat'];
  //   double maxx = (widget.mapRecord['start']['long'] <= widget.mapRecord['end']['long'])
  //       ? widget.mapRecord['end']['long']
  //       : widget.mapRecord['start']['long'];
  //
  //   _southwestCoordinates = Position(latitude: miny, longitude: minx);
  //   _northeastCoordinates = Position(latitude: maxy, longitude: maxx);
  //
  //   // Accommodate the two locations within the
  //   // camera view of the map
  //   _mapController.animateCamera(
  //     CameraUpdate.newLatLngBounds(
  //       LatLngBounds(
  //         northeast: LatLng(
  //           _northeastCoordinates.latitude,
  //           _northeastCoordinates.longitude,
  //         ),
  //         southwest: LatLng(
  //           _southwestCoordinates.latitude,
  //           _southwestCoordinates.longitude,
  //         ),
  //       ),
  //       100.0,
  //     ),
  //   );
  // }

  _addMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/dest.png')
        .then((onValue) {
      _destIcon = onValue;
    });
    if (widget.mapRecord.isNotEmpty) {
      _setMarkers();
    }

    _createPolyLine();
  }

  _locationMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/marker.png')
        .then((onValue) {
      _markerIcon = onValue;
    });

    print('lat ${widget.mark.lat} lng ${widget.mark.lng}');
    Marker addonMarker = Marker(
      markerId: MarkerId('mark'),
      position: LatLng(
        widget.mark.lat!,
        widget.mark.lng!,
      ),
      infoWindow: InfoWindow(title: 'Mark'),
      icon: _markerIcon!,
    );
    setState(() {
      _markers.add(addonMarker);
    });
  }

  @override
  void initState() {
    super.initState();
    // print("value of records ${widget.mapRecord.length} ${widget.mapRecord}");
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              devicePixelRatio: 2.5,
            ),
            'assets/images/place.png')
        .then((onValue) {
      _allIcon = onValue;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.mapRecord.isEmpty) {
        _locationMarker();
      } else {
        _addMarker();
      }
    });
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Record'),
      ),
      body: GoogleMap(
        initialCameraPosition: widget.mapRecord.isNotEmpty
            ? CameraPosition(
                target: LatLng(
                    widget.mapRecord.first.lat!, widget.mapRecord.first.lng!),
                zoom: 18)
            : CameraPosition(
                target: LatLng(widget.mark.lat!, widget.mark.lng!), zoom: 18),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        markers: _markers,
        polylines: Set<Polyline>.of(_mapPolyLines.values),
        // polylines: {
        //   if (_info != null)
        //     Polyline(
        //       polylineId: const PolylineId('overview_polyline'),
        //       color: Colors.red,
        //       width: 3,
        //       points: _info.snappedPoints
        //           .map((e) {
        //             // print("e.longitude ---- ${
        //             //     e.longitude
        //             // }");
        //             // print("e.longitude ---- ${
        //             //     e.longitude
        //             // }");
        //          return   LatLng(e.location.latitude, e.location.longitude);
        //       })
        //           .toList(),
        //       // points: polylinePoints
        //       //     .map((e) => LatLng(e.latitude, e.longitude))
        //       //     .toList(),
        //     ),
        // },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
