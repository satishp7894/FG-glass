import 'package:background_location/background_location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/sales/pages/sales_person_view_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:http/http.dart' as http;
import 'package:search_map_location/utils/google_search/place.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../../bloc/direction_bloc.dart';
import '../../login.dart';
import '../../models/directions_model.dart';
import '../../utils/alerts.dart';
import '../../utils/connections.dart';
import '../../utils/dialogs.dart';
import '../../utils/progress_dialog.dart';
import '../../utils/stop_watch_timer.dart';
import 'home_page.dart';
import 'location_search_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class MapPage extends StatefulWidget {


  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool? serviceEnabled;
  LocationPermission? permission;
  DateTime? _startTime, _endTime;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  GoogleMapController? _mapController;
  bool recordStarted = false;
  Position? _startPosition;
  Position? _endPosition;
  Position? _startPositionUpdated;
  BitmapDescriptor? _destIcon, _markerIcon, _allIcon;
  Set<Marker>? _markers = {};
  Map<PolylineId, Polyline> _mapPolyLines = {};
  Directions? _info;
  Timer? _timer;
  String totalDuration = "";

  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  DateTime currentDate =  DateTime.now();
  var newFormat = DateFormat("dd-MMM-yyyy hh:mm:ss");
  var monthFormat = DateFormat("MMM");

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  disposeWatch() async {
    await _stopWatchTimer.dispose();
  }

  _getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Alerts.showAlert(context, 'Permission Denied', 'Please allow app to access location.');
        return;
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      Alerts.showAlert(context, 'Location Disabled', 'Please enable location service.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    print('location lat ${position.latitude} lng ${position.longitude}');
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18),
      ),
    ).catchError((e) {
      print('Error in animating map $e');
    });
    setState(() {
      _startPosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        speed: position.speed,
        heading: position.heading,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speedAccuracy: position.speedAccuracy,
      );
    });
  }

  _addMark() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Alerts.showAlert(context, 'Permission Denied', 'Please allow app to access location.');
        return;
      }
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      Alerts.showAlert(context, 'Location Disabled', 'Please enable location service.');
      return;
    }

    Dialogs.showLoadingDialog(context, _keyLoader);
    Position markPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    print('mark location lat ${markPosition.latitude} lng ${markPosition.longitude}');
    String location = await _getSingleGeocoding(markPosition.latitude, markPosition.longitude);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("_prefs.getInt('UserID') ${
        _prefs.getInt('UserID')
    }");
    var response = await http.post(Uri.parse(Connections.addMark), body: {
      'Location': '$location',
      'Latitude': '${markPosition.latitude}',
      'Longitude': '${markPosition.longitude}',
      'UserID': '${_prefs.getInt('UserID')}',
      // 'UserID': '2',
    });
    var results = json.decode(response.body);
    print('mark results $results');

    print('loction for visit $location');
    String strCurrentDate = newFormat.format(currentDate);

    print("_prefs.getInt('UserID') ${
        _prefs.getInt('UserID')
    }");
    var response2 = await http.post(Uri.parse(Connections.addVisit), body: {
      'Location': '$location',
      'AddedBy' : '${_prefs.getInt('UserID')}',
      // 'AddedBy' : '2',
      'VerticalID': "0",
      "DailyVisitDate": strCurrentDate,
      'NextActionDate':strCurrentDate
    });
    var results2 = json.decode(response2.body);
    print('mark results for visit $results2');

    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    if (results['status'] == true) {
      Marker addonMarker = Marker(
        markerId: MarkerId('$markPosition'),
        position: LatLng(
          markPosition.latitude,
          markPosition.longitude,
        ),
        infoWindow: const InfoWindow(title: 'Mark'),
        icon: _markerIcon!,
      );
      setState(() {
        _markers!.add(addonMarker);
        Fluttertoast.showToast(
          msg: 'Marked Location Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to mark location',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    }

  }
//=============================================================

  // _startRecording() async {
  //   print("object recording start clicked");
  //   _markers.clear();
  //   _mapPolyLines.clear();
  //   _startTime = DateTime.now();
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   print('location on start clicked lat ${position.latitude} lng ${position.longitude}');
  //   setState(() {
  //     _startPosition = Position(
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //       timestamp: DateTime.now(),
  //       speed: position.speed,
  //       heading: position.heading,
  //       accuracy: position.accuracy,
  //       altitude: position.altitude,
  //       speedAccuracy: position.speedAccuracy,
  //     );
  //     _startPositionUpdated = Position(
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //       timestamp: DateTime.now(),
  //       speed: position.speed,
  //       heading: position.heading,
  //       accuracy: position.accuracy,
  //       altitude: position.altitude,
  //       speedAccuracy: position.speedAccuracy,
  //     );
  //     _mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18),
  //       ),
  //     ).catchError((e) {
  //       print('Error in animating map $e');
  //     });
  //   });
  //
  //   lastLat = _startPosition.latitude;
  //   lastLong = _startPosition.longitude;
  //
  //   Marker startMarker = Marker(
  //     markerId: MarkerId('$_startPosition'),
  //     position: LatLng(
  //       _startPosition.latitude,
  //       _startPosition.longitude,
  //     ),
  //     infoWindow: const InfoWindow(title: 'Start'),
  //     icon: BitmapDescriptor.defaultMarker,
  //   );
  //   _markers.add(startMarker);
  //   Fluttertoast.showToast(
  //     msg: 'Recording Started',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.black87,
  //     textColor: Colors.white,
  //     fontSize: 16,
  //   );
  //   await BackgroundLocation.setAndroidNotification(
  //     title: "Infinity",
  //     message: "Location tracking in progress",
  //     icon: "@mipmap/ic_launcher",
  //   );
  //   BackgroundLocation.setAndroidConfiguration(100);
  //   await BackgroundLocation.startLocationService();
  //   var box = await Hive.openBox(Connections.locations);
  //   var multiLocations = await Hive.openBox(Connections.multiLocations);
  //   var lastLocationList = await Hive.openBox(Connections.lastLocationList);
  //   var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
  //   var temp = await Hive.openBox(Connections.temp);
  //   if (temp.length > 0) {
  //     print("temp if");
  //     temp.deleteFromDisk();
  //   }else{
  //     print("temp else");
  //   }
  //   box.add({'lat': _startPosition.latitude, 'long': _startPosition.longitude});
  //
  //
  //   BackgroundLocation.getLocationUpdates((location) async {
  //     // print('background location later on count is lat ${location.latitude} long ${location.longitude}');
  //     _mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(target: LatLng(location.latitude, location.longitude), zoom: 18),
  //       ),
  //     );
  //     // box.add({'lat': location.latitude, 'long': location.longitude});
  //     // print("object box values start ${box.length}");
  //   });
  //   int wPoints = 0;
  //   String wayPoints="";
  //
  //
  //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
  //     // setState(() {
  //
  //     // });
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  //     // print('background location later on count is lat ${position.latitude} long ${position.longitude}');
  //     print("DateTime.now() ---${DateTime.now()}");
  //     // box.add({'lat': position.latitude, 'long': position.longitude});
  //     // print("object box values start ${box.length}");
  //
  //
  //
  //
  //     wayPoints=wayPoints + position.latitude.toString() +","+ position.longitude.toString() + '|';
  //     currentAllLocations.add(
  //         {'lat': position.latitude, 'lng': position.longitude});
  //     //
  //
  //
  //     if(wPoints == 99){
  //
  //       print("wPoints ============ ${wPoints}");
  //       // for (int i = 0; i < latLogList.length; i++) {
  //
  //
  //         // wayPoints=wayPoints + '{"lat":"${latLogList[i].latitude.toString()}","lng":"${latLogList[i].longitude.toString()}"}' + ',';
  //       // }20.3658692
  //
  //       print("_startPositionUpdated ${_startPosition.latitude} , ${_startPosition.longitude}");
  //       print("endPosition ${position.latitude} , ${position.longitude}");
  //       print("wayPoints $wayPoints");
  //       String result = wayPoints.substring(0, wayPoints.length - 1);
  //       print("result -- $result");
  //       wPoints = 0;
  //       wayPoints = "";
  //       lastLocationList.clear();
  //       Roads directions = (await DirectionBloc()
  //           .getDirections(origin: LatLng(_startPosition.latitude, _startPosition.longitude), destination: LatLng(position.latitude, position.longitude),waypoints: result)) as Roads;
  //       //
  //       // _startPositionUpdated = Position(
  //       //   latitude: directions.polylinePoints.last.latitude,
  //       //   longitude: directions.polylinePoints.last.longitude,
  //       //   timestamp: DateTime.now(),
  //       //   speed: position.speed,
  //       //   heading: position.heading,
  //       //   accuracy: position.accuracy,
  //       //   altitude: position.altitude,
  //       //   speedAccuracy: position.speedAccuracy,
  //       // );
  //
  //
  //       // Road Api Respone
  //       //
  //       for(int i =0;i<directions.snappedPoints.length;i++) {
  //         multiLocations.add(
  //             {'lat': directions.snappedPoints[i].location.latitude, 'lng': directions.snappedPoints[i].location.longitude});
  //       }
  //
  //       // Direction Api Respone
  //
  //       // for(int i =0;i<directions.polylinePoints.length;i++) {
  //       //   multiLocations.add(
  //       //       {'lat': directions.polylinePoints[i].latitude, 'lng': directions.polylinePoints[i].longitude});
  //       // }
  //
  //
  //
  //
  //
  //
  //     }else{
  //       print("wPoints $wPoints");
  //       lastLocationList.add({'lat': position.latitude, 'lng': position.longitude});
  //
  //
  //     }
  //
  //     wPoints = wPoints + 1;
  //   });
  // }
  //
  // _stopRecording() async {
  //   await BackgroundLocation.stopLocationService();
  //   lastLat = 0;
  //   lastLong = 0;
  //   _timer.cancel();
  //   Position endPosition = await Geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   print('location on end clicked lat ${endPosition.latitude} lng ${endPosition.longitude}');
  //   Marker stopMarker = Marker(
  //     markerId: MarkerId('$endPosition'),
  //     position: LatLng(endPosition.latitude, endPosition.longitude),
  //     infoWindow: const InfoWindow(title: 'Stop'),
  //     icon: _destIcon,
  //   );
  //   _markers.add(stopMarker);
  //   var box = await Hive.openBox(Connections.locations);
  //   box.add({'lat': endPosition.latitude, 'long': endPosition.longitude});
  //   // print("object box values on stop ${box.length}");
  //   _createPolyLines(endPosition);
  //
  //
  // }

  // ==========================================================





  _startRecording() async {
    print("object recording start clicked");
    _markers!.clear();
    _mapPolyLines.clear();
    _startTime = DateTime.now();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    print('location on start clicked lat ${position.latitude} lng ${position.longitude}');
    setState(() {
      _startPosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        speed: position.speed,
        heading: position.heading,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speedAccuracy: position.speedAccuracy,
      );
      _startPositionUpdated = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        speed: position.speed,
        heading: position.heading,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speedAccuracy: position.speedAccuracy,
      );
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18),
        ),
      ).catchError((e) {
        print('Error in animating map $e');
      });
    });

    lastLat = _startPosition!.latitude;
    lastLong = _startPosition!.longitude;

    Marker startMarker = Marker(
      markerId: MarkerId('$_startPosition'),
      position: LatLng(
        _startPosition!.latitude,
        _startPosition!.longitude,
      ),
      infoWindow: const InfoWindow(title: 'Start'),
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers!.add(startMarker);
    Fluttertoast.showToast(
      msg: 'Recording Started',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16,
    );
    _showNotification();
    await BackgroundLocation.setAndroidNotification(
      title: "Infinity",
      message: "Location tracking in progress",
      icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.setAndroidConfiguration(100);
    // await BackgroundLocation.startLocationService(distanceFilter: 20,forceAndroidLocationManager: true);
    var box = await Hive.openBox(Connections.locations);
    var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
    currentAllLocations.add({'lat': _startPosition!.latitude, 'lng': _startPosition!.longitude});
    var temp = await Hive.openBox(Connections.temp);
    if (temp.length > 0) {
      print("temp if");
      temp.deleteFromDisk();
    }else{
      print("temp else");
    }

    var records = await Hive.openBox(Connections.records);
    if (records.length > 0) {
      print("records if");
      temp.deleteFromDisk();
    }else{
      print("records else");
    }
    box.add({'lat': _startPosition!.latitude, 'long': _startPosition!.longitude});




    BackgroundLocation.getLocationUpdates((location) async {
      // print('background location later on count is lat ${location.latitude} long ${location.longitude}');
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(location.latitude!, location.longitude!), zoom: 18),
        ),
      );
      // box.add({'lat': location.latitude, 'long': location.longitude});
      // print("object box values start ${box.length}");
    });

    // bg.BackgroundGeolocation.onLocation((bg.Location location) {
    //   print('[location] - $location');
    //   // _mapController!.animateCamera(
    //   //   CameraUpdate.newCameraPosition(
    //   //     CameraPosition(target: LatLng(location.latitude, location.longitude), zoom: 18),
    //   //   ),
    //   // );
    // });
    //
    // // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    // bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
    //   print('[motionchange] - $location');
    // });
    //
    // // Fired whenever the state of location-services changes.  Always fired at boot
    // bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
    //   print('[providerchange] - $event');
    // });
    //
    // ////
    // // 2.  Configure the plugin
    // //
    // bg.BackgroundGeolocation.ready(bg.Config(
    //     desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    //     distanceFilter: 10.0,
    //     stopOnTerminate: false,
    //     startOnBoot: true,
    //     debug: true,
    //     logLevel: bg.Config.LOG_LEVEL_VERBOSE
    // )).then((bg.State state) {
    //   if (!state.enabled) {
    //     ////
    //     // 3.  Start the plugin.
    //     //
    //     bg.BackgroundGeolocation.start();
    //   }
    // });



    // int wPoints = 0;
    // String wayPoints="";


    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // setState(() {

      // });
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      // print('background location later on count is lat ${position.latitude} long ${position.longitude}');
      // print("DateTime.now() ---${DateTime.now()}");
      // box.add({'lat': position.latitude, 'long': position.longitude});
      // print("object box values start ${box.length}");


      // _startPosition22 = Position(
      //   latitude: position.latitude,
      //   longitude: position.longitude,
      //   timestamp: DateTime.now(),
      //   speed: position.speed,
      //   heading: position.heading,
      //   accuracy: position.accuracy,
      //   altitude: position.altitude,
      //   speedAccuracy: position.speedAccuracy,
      // );

      currentAllLocations.add({'lat': position.latitude, 'lng': position.longitude});


      Marker allMarker = Marker(
        markerId: MarkerId('${position.latitude}'),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        infoWindow: const InfoWindow(title: 'Start'),
        icon: _allIcon!,
      );

      _markers!.add(allMarker);

      setState(() {

      });

      // latLogAllList.add(LatLng(_startPosition22.latitude, _startPosition22.longitude));
      //
      // setState(() {
      //   PolylineId id = const PolylineId('poly');
      //   Polyline polyline = Polyline(
      //     polylineId: id,
      //     color: Colors.red,
      //     // points: _info.data.paths[0].polylinePoints
      //     //     .map((e) => LatLng(e.longitude, e.longitude))
      //     //     .toList()
      //
      //
      //     points: latLogAllList
      //         .map((e) => LatLng(e.latitude, e.longitude))
      //         .toList(),
      //     width: 3,
      //   );
      //   // setState(() {
      //   //
      //   // });
      //   _mapPolyLines[id] = polyline;
      // });





      // latLogAllList.clear();
      //
      // _startPosition22 = Position(
      //   latitude: position.latitude,
      //   longitude: position.longitude,
      //   timestamp: DateTime.now(),
      //   speed: position.speed,
      //   heading: position.heading,
      //   accuracy: position.accuracy,
      //   altitude: position.altitude,
      //   speedAccuracy: position.speedAccuracy,
      // );
      //
      // latLogAllList.add(LatLng(_startPosition22.latitude, _startPosition22.longitude));


      // wayPoints=wayPoints + position.latitude.toString() +","+ position.longitude.toString() + '|';
      // currentAllLocations.add(
      //     {'lat': position.latitude, 'lng': position.longitude});
      // //
      //
      //
      // if(wPoints == 99){
      //
      //   print("wPoints ============ ${wPoints}");
      //   // for (int i = 0; i < latLogList.length; i++) {
      //
      //
      //   // wayPoints=wayPoints + '{"lat":"${latLogList[i].latitude.toString()}","lng":"${latLogList[i].longitude.toString()}"}' + ',';
      //   // }20.3658692
      //
      //   print("_startPositionUpdated ${_startPosition.latitude} , ${_startPosition.longitude}");
      //   print("endPosition ${position.latitude} , ${position.longitude}");
      //   print("wayPoints $wayPoints");
      //   String result = wayPoints.substring(0, wayPoints.length - 1);
      //   print("result -- $result");
      //   wPoints = 0;
      //   wayPoints = "";
      //   lastLocationList.clear();
      //   Roads directions = (await DirectionBloc()
      //       .getDirections(origin: LatLng(_startPosition.latitude, _startPosition.longitude), destination: LatLng(position.latitude, position.longitude),waypoints: result)) as Roads;
      //   //
      //   // _startPositionUpdated = Position(
      //   //   latitude: directions.polylinePoints.last.latitude,
      //   //   longitude: directions.polylinePoints.last.longitude,
      //   //   timestamp: DateTime.now(),
      //   //   speed: position.speed,
      //   //   heading: position.heading,
      //   //   accuracy: position.accuracy,
      //   //   altitude: position.altitude,
      //   //   speedAccuracy: position.speedAccuracy,
      //   // );
      //
      //
      //   // Road Api Respone
      //   //
      //   for(int i =0;i<directions.snappedPoints.length;i++) {
      //     multiLocations.add(
      //         {'lat': directions.snappedPoints[i].location.latitude, 'lng': directions.snappedPoints[i].location.longitude});
      //   }
      //
      //   // Direction Api Respone
      //
      //   // for(int i =0;i<directions.polylinePoints.length;i++) {
      //   //   multiLocations.add(
      //   //       {'lat': directions.polylinePoints[i].latitude, 'lng': directions.polylinePoints[i].longitude});
      //   // }
      //
      //
      //
      //
      //
      //
      // }else{
      //   print("wPoints $wPoints");
      //   lastLocationList.add({'lat': position.latitude, 'lng': position.longitude});
      //
      //
      // }
      //
      // wPoints = wPoints + 1;
    });


  }

  _stopRecording() async {
    flutterLocalNotificationsPlugin!.cancel(0);
    // await BackgroundLocation.stopLocationService();
    lastLat = 0;
    lastLong = 0;
    _timer!.cancel();
    // var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
    // currentAllLocations.add({'lat': _endPosition.latitude, 'lng': _endPosition.longitude});
    // Position endPosition = await Geolocator
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    print('location on end clicked lat ${_endPosition!.latitude} lng ${_endPosition!.longitude}');
    Marker stopMarker = Marker(
      markerId: MarkerId('$_endPosition'),
      position: LatLng(_endPosition!.latitude, _endPosition!.longitude),
      infoWindow: const InfoWindow(title: 'Stop'),
      icon: _destIcon!,
    );
    _markers!.add(stopMarker);
    var box = await Hive.openBox(Connections.locations);
    box.add({'lat': _endPosition!.latitude, 'long': _endPosition!.longitude});
    // print("object box values on stop ${box.length}");
    _createPolyLines(_endPosition!);



  }

  _addRoute(Position endPosition, locations, distance) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('storing offline');
      var recordBox = await Hive.openBox(Connections.records);
      Map<String, dynamic> record = {
        'start': {'lat': _startPosition!.latitude, 'long': _startPosition!.longitude},
        'end': {'lat': endPosition.latitude, 'long': endPosition.longitude},
        'path': locations,
        'distance': distance,
        'dateTime': DateTime.now().toString(),
        'startTime': _startTime.toString(),
        'endTime': _endTime.toString(),
      };
      recordBox.add(record);
      Fluttertoast.showToast(
        msg: 'Recording Saved Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      print('storing server');
      // Dialogs.showLoadingDialog(context, _keyLoader).then((_) {
      //   if (mounted) {
      //     Future.delayed(Duration(minutes: 1), () {
      //       //Navigator.of(context, rootNavigator: true).pop();
      //       Navigator.of(context).pop();
      //     });
      //   }
      // });

      try{
        ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
          isDismissible: false,);
        pr.style(message: 'Please wait...',
          progressWidget: const Center(child: CircularProgressIndicator()),);
        pr.show();
        List<String> addresses = await _getReverseGeocoding(_startPosition!.latitude,
            _startPosition!.longitude, endPosition.latitude, endPosition.longitude);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        var params = {
          'userID': '${_prefs.getInt('UserID')}',
          // 'userID': '2',
          'start': '${addresses[0]}',
          'end': '${addresses[1]}',
          "startCoords": {
            "lat": '${_startPosition!.latitude}',
            "lng": '${_startPosition!.longitude}',
          },
          "endCoords": {
            "lat": '${endPosition.latitude}',
            "lng": '${endPosition.longitude}',
          },
          'distance': '$distance',
          'unit': 'kms',
          "path": locations ?? [],
          "ID": 6,
          "dateTime": DateTime.now().toString(),
          "startTime": '${_startTime.toString()}',
          'endTime': '${_endTime.toString()}',
        };
        var response = await http.post(Uri.parse(Connections.addRoute),
            headers: {'Content-type': 'application/json'},
            body: json.encode(params));
        // print('params  ==== ${params}');
        var result = json.decode(response.body);
        pr.hide();
        //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        // print('add route result $result');
        if (result['status'] == true) {
          Fluttertoast.showToast(
            msg: 'Recording Saved Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16,
          );
        } else {
          Alerts.showAlert(context, 'Failed to store record', 'Please try again later.');
          print('Failed to store record');

        }


      }catch(e){

        Fluttertoast.showToast(
          msg: "storing catch ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16,
        );
      }


    }
  }

  _showNotification() async {
     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse

    );

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('0', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        autoCancel: false,
        ongoing:true


    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
        0, "Infinity", "Location tracking in progress", notificationDetails,
        // payload: message.data["page"]
    );



  }

  // final directions = await DirectionBloc()
  //     .getDirections(origin: LatLng(_startPosition.latitude, _startPosition.longitude), destination: LatLng(endPosition.latitude, endPosition.longitude));
  // setState(() => _info = directions);

  _uploadOfflineRecords() async {
    var box = await Hive.openBox(Connections.records);
    print("object box open or close $box ${box.isOpen} ${box.length}");
    for (int i=0; i<box.length; i++) {
      bool result = await _addOfflineRoute(box.getAt(i));
      print('result stored is $result');
    }
    await box.deleteFromDisk();


    var temp = await Hive.openBox(Connections.temp);
    print("object temp open or close $box ${temp.isOpen} ${temp.length}");
    for (int i=0; i<temp.length; i++) {
      //${currentAllLocations.getAt(i)['lat']}\n
      // print('const LatLng(${temp.getAt(i)['lat']}, ${temp.getAt(i)['lng']}),\n');
      print('{"lat": ${temp.getAt(i)['lat']}, "lng": ${temp.getAt(i)['lng']}},\n');
    }
    // await temp.deleteFromDisk();
  }

  Future<bool> _addOfflineRoute(box) async {
    print("box values ${box['start']['lat']} ${box['start']['long']}  ${box['end']['lat']} ${box['end']['long']}");
    List<String> addresses = await _getReverseGeocoding(box['start']['lat'],
        box['start']['long'], box['end']['lat'], box['end']['long']);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("List of address ${addresses.length} ${addresses[0]} ${addresses[1]} ${box['distance']} ${box['path']}");
    var params = {
      'userID': '${_prefs.getInt('UserID')}',
      'start': '${addresses[0]}',
      'end': '${addresses[1]}',
      "startCoords": {
        "lat": box['start']['lat'],
        "lng": box['start']['long'],
      },
      "endCoords": {
        "lat": box['end']['lat'],
        "lng": box['end']['long'],
      },
      'distance': '${box['distance']}',
      'unit': 'kms',
      "path": box['path'],
      "ID": 6,
      "dateTime": box['dateTime'],
      "startTime": box['startTime'],
      'endTime': box['endTime'],
    };
    var response = await http.post(Uri.parse(Connections.addRoute),
        headers: {'Content-type':'application/json'},
        body: json.encode(params));
    var result = json.decode(response.body);
    if (result['status'] == true) {
      Fluttertoast.showToast(
        msg: 'offline record saved successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to store offline record',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
    print("object response generated ${response.body}");
    return result['status'] ?? false;
  }

  Future<String> _getSingleGeocoding(lat, long) async {
    var response = await http.get(Uri.parse('${Connections.geocoding}$lat,$long'));
    var result = json.decode(response.body);
    print("response single geocoding ${response.body}");
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return result['results'][0]['formatted_address'];
    } else {
      return 'Meeting Marked';
    }
  }

  Future<List<String>> _getReverseGeocoding(startLat, startLong, endLat, endLong) async {
    String startAdd = 'Not Available';
    String endAdd = 'Not Available';
    var response1 = await http.get(Uri.parse('${Connections.geocoding}$startLat,$startLong'));
    var result1 = json.decode(response1.body);
    if (response1.statusCode >= 200 && response1.statusCode <= 299) {
      startAdd = result1['results'][0]['formatted_address'];
    } else {
      startAdd = 'Start Location';
    }
    var response2 = await http.get(Uri.parse('${Connections.geocoding}$endLat,$endLong'));
    var result2 = json.decode(response2.body);
    if (response2.statusCode >= 200 && response2.statusCode <= 299) {
      endAdd = result2['results'][0]['formatted_address'];
    } else {
      endAdd = 'End Location';
    }
    return [startAdd, endAdd];
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/place.png').then((onValue) {
      _allIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/dest.png').then((onValue) {
      _destIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/marker.png').then((onValue) {
      _markerIcon = onValue;
    });
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.none) {
        _uploadOfflineRecords();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocation();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription!.cancel();
    _mapController!.dispose();
    //Hive.close();
    super.dispose();
    disposeWatch();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Align(alignment: Alignment.center,
            child: const Text(' v1.0.4', style: const TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500),)),
        centerTitle: true, elevation: 2,
        title: Image.asset('assets/images/infinity.jpg', height: 36, fit: BoxFit.contain,),
        actions: [
          InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => SalesPersonViewScreen( )));
              },
              child: Icon(Icons.menu)),

          _logoutPopup(),
        ],
      ),
       body: Stack(
         children: [
           _mapView(),
           _timerView(),
            Padding(padding: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
              child: Align(alignment: Alignment.bottomCenter,
                child: recordStarted ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.5)
                          // gradient: LinearGradient(
                          //     colors: [Colors.redAccent, Colors.orange],
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight)
                        ),
                        height: 50,
                        child: Center(child: Text("Total Distance : $totalDuration",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      ),
                      SizedBox(height: 14,),
                      SizedBox(width: double.infinity,
                        child: CupertinoButton(color: Colors.blue,
                          child: const Text('Stop'),
                          onPressed: () async {

                            serviceEnabled = await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled!) {
                              Alerts.showAlert(context, 'Location Disabled',
                                  'Please enable location service.');
                              return;
                            }
                            permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.deniedForever) {
                              Alerts.showAlertSettings(context, () {
                                Geolocator.openLocationSettings();
                              });
                              return;
                            }
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission != LocationPermission.whileInUse &&
                                  permission != LocationPermission.always) {
                                Alerts.showAlert(context, 'Permission Denied',
                                    'Please allow app to access location.');
                                return;
                              }
                            }
                            Alerts.showRecordStopAlert(context, () async {
                              setState(() {
                                recordStarted = false;
                                endLocationController.clear();
                              });
                              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                              _stopRecording();
                             // await Future.delayed(const Duration(seconds: 5), () {
                             //   _stopRecording();
                             //  });

                            });
                          }),
                      ),
                    ],
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: TextFormField(
                          readOnly: true,
                          // focusNode: myFocusNode,
                          textAlign: TextAlign.start,
                          // keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onTap: () async {
                            Place result = await  Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  const LocationSearchScreen()),
                            );
                            if(result != null){
                              FocusManager.instance.primaryFocus?.unfocus();
                              final geolocation = await result.geolocation;
                              final latLng = LatLng(geolocation?.coordinates?.latitude,geolocation?.coordinates?.longitude);
                              //
                              // print("_startPosition ========> ${_startPosition.latitude}");
                              // print("_startPosition ========> ${_startPosition.longitude}");
                              //
                              print("end latitude ========> ${latLng.latitude}");
                              print("end longitude ========> ${latLng.longitude}");
                              endLocationController.text = result.description;

                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _endPosition = Position(
                                  latitude: latLng.latitude,
                                  longitude: latLng.longitude,
                                  timestamp: DateTime.now(),
                                  speed: 0,
                                  heading: 0,
                                  accuracy: 0,
                                  altitude: 0,
                                  speedAccuracy: 0,
                                );

                              });

                            }

                          },

                          controller: endLocationController,
                          // obscureText: controller.showPassword.value,
                          // style: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 14,color: AppColors.black)),
                          // cursorColor: AppColors.appText1,
                          decoration: InputDecoration(
                            // labelStyle : GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 12)),
                            // labelStyle: TextStyle(
                            //     color: myFocusNode.hasFocus ? Colors.purple : AppColors.appText1
                            // ),
                            contentPadding: EdgeInsets.only(left:18,bottom: 18,top: 18,right: 16),

                            // suffixIcon: IconButton(
                            //     onPressed: () {
                            //       controller.toggleShowPassword();
                            //     },
                            //     icon: controller.showPassword.value
                            //         ? Icon(Icons.visibility_off)
                            //         : Icon(Icons.visibility)),

                            // hintStyle: GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 12)),


                            hintText: 'Enter Stop Location',
                            // labelText: 'End Location',
                            filled: true,

                            fillColor: Colors.grey.shade200,
                            // enabledBorder:OutlineInputBorder(
                            //   borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                            //   borderRadius: BorderRadius.circular(2.0),
                            //
                            // ),
                            // focusedBorder:OutlineInputBorder(
                            //   borderSide: const BorderSide(color: AppColors.appText1, width: 1.0),
                            //   borderRadius: BorderRadius.circular(2.0),
                            // ),
                            // labelStyle:  GoogleFonts.inriaSans(textStyle: TextStyle(fontSize: 15))

                            border: OutlineInputBorder(),

                          ),
                        ),
                      ),
                      SizedBox(height: 14,),
                      SizedBox(width: double.infinity,
                        child: CupertinoButton(color: Colors.blue,
                            child: const Text('Start'),
                            onPressed: () async {

                          if(endLocationController.text == ""){
                            Alerts.showAlert(context, 'Stop Location', 'Please enter stop location');
                          }else{
                            serviceEnabled = await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled!) {
                              Alerts.showAlert(context, 'Location Disabled',
                                  'Please enable location service.');
                              return;
                            }
                            permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.deniedForever) {
                              Alerts.showAlertSettings(context, () {
                                Geolocator.openLocationSettings();
                              });
                              return;
                            }
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission != LocationPermission.whileInUse &&
                                  permission != LocationPermission.always) {
                                Alerts.showAlert(context, 'Permission Denied',
                                    'Please allow app to access location.');
                                return;
                              }
                            }

                            print("_startPosition ========> ${_startPosition!.latitude}");
                            print("_startPosition ========> ${_startPosition!.longitude}");

                            print("_endPosition ========> ${_endPosition!.latitude}");
                            print("_endPosition ========> ${_endPosition!.longitude}");

                            final directions = (await DirectionBloc()
                                .getDirections(origin: LatLng(_startPosition!.latitude, _startPosition!.longitude), destination: LatLng(_endPosition!.latitude, _endPosition!.longitude),waypoints: "result"));
                            print("directions ==============> ${directions.totalDistance}");


                            setState(() {
                              _info = directions;
                              recordStarted = true;
                              totalDuration = directions.totalDistance.toString();
                            });


                            _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                            _startRecording();
                          }

                            }),
                      ),
                    ],
                  ),
              ),
            ),
         ],
       ),
    );
  }

  Widget _timerView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, right: 12),
        child: Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [
              recordStarted ?
              StreamBuilder<int>(initialData: 0,
                stream: _stopWatchTimer.rawTime,
                builder: (c, s) {
                  final value = s.data;
                  final displayTime = StopWatchTimer.getDisplayTime(value!);
                  return Container(width: 118,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(65),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: Colors.red, radius: 10,),
                        //SizedBox(width: 6,),
                        Text(displayTime.substring(0, displayTime.length - 3),
                          style: const TextStyle(fontSize: 18,),
                        ),
                      ],
                    ),
                  );
                }
              ) : const SizedBox(),
              const SizedBox(height: 5,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // background
                  onPrimary: Colors.black87, // foreground
                ),
                icon: const Icon(Icons.location_on_outlined, size: 30,
                  color: Colors.red,),
                label: const Text('Mark', style: const TextStyle(fontSize: 18),),
                onPressed: () {
                  _addMark();
                },
              ),
            ],
          ),
        ),
      ),
    );
     // if (recordStarted) {
     //   return SafeArea(
     //     child: Padding(
     //       padding: const EdgeInsets.only(top: 12, right: 12),
     //       child: Align(
     //         alignment: Alignment.topRight,
     //         child: StreamBuilder<int>(initialData: 0,
     //            stream: _stopWatchTimer.rawTime,
     //            builder: (c, s) {
     //              final value = s.data;
     //              final displayTime = StopWatchTimer.getDisplayTime(value);
     //              return Container(width: 118,
     //                padding: const EdgeInsets.all(8),
     //                decoration: BoxDecoration(
     //                  color: Colors.grey[300],
     //                  borderRadius: BorderRadius.circular(65),
     //                ),
     //                child: Row(
     //                  children: [
     //                    CircleAvatar(backgroundColor: Colors.red, radius: 10,),
     //                    SizedBox(width: 6,),
     //                    Text(displayTime.substring(0, displayTime.length - 3),
     //                      style: TextStyle(fontSize: 18,),
     //                    ),
     //                  ],
     //                ),
     //              );
     //            }),
     //       ),
     //     ),
     //   );
     // } else {
     //   return SizedBox();
     // }
  }

  Widget _mapView() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: const LatLng(0.0, 0.0)),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      markers: _markers! ,
      polylines: Set<Polyline>.of(_mapPolyLines.values),
      // polylines: {
      //   if (_info != null)
      //     Polyline(
      //       polylineId: const PolylineId('overview_polyline'),
      //       color: Colors.red,
      //       width: 5,
      //       points: _info.polylinePoints
      //           .map((e) => LatLng(e.latitude, e.longitude))
      //           .toList(),
      //       // points: polylinePoints
      //       //     .map((e) => LatLng(e.latitude, e.longitude))
      //       //     .toList(),
      //     ),
      // },
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
    );
  }

  // Create the polyLines to show the route between two places
  // _createPolyLines(Position endPosition) async {
  //   // var points = await _createPoints();
  //
  //   var allPoints = await _createAllPoints();
  //   List<LatLng> latLogList = <LatLng>[];
  //   List<LatLng> latLogAllList = <LatLng>[];
  //   // double totalDistance = 0.0;
  //   List<Map<String, double>> polylineList = [];
  //   print("points returned ${allPoints.length} \n ${allPoints[0]} \n ${allPoints[1]} \n ${allPoints[2]} \n ${allPoints[3]  } } ");
  //
  //   // setState(() {
  //   // totalDistance = allPoints[3];
  //   latLogList = allPoints[2];
  //   latLogAllList = allPoints[0];
  //
  //   polylineList  = allPoints[1];
  //   print("allPoints[1] polylineList ===========${polylineList.length}");
  //   // });
  //   // setState(() {
  //   //   _mapPolyLines[id] = polyline;
  //   //   _endTime = DateTime.now();
  //   // });
  //
  //   if(latLogList.isNotEmpty){
  //     String wayPoints="";
  //
  //     for (int i = 0; i < latLogList.length; i++) {
  //       wayPoints=wayPoints + latLogList[i].latitude.toString() +","+latLogList[i].longitude.toString() + '|';
  //
  //       // wayPoints=wayPoints + '{"lat":"${latLogList[i].latitude.toString()}","lng":"${latLogList[i].longitude.toString()}"}' + ',';
  //     }
  //
  //     print("Last _startPositionUpdated ${_startPositionUpdated.latitude} , ${_startPositionUpdated.longitude}");
  //     print("Last endPosition ${endPosition.latitude} , ${endPosition.longitude}");
  //     print("Last wayPoints $wayPoints");
  //     String result = wayPoints.substring(0, wayPoints.length - 1);
  //
  //     print("Last result ${result}");
  //     Roads directions = (await DirectionBloc()
  //         .getDirections(origin: LatLng(_startPositionUpdated.latitude, _startPositionUpdated.longitude), destination: LatLng(endPosition.latitude, endPosition.longitude),waypoints: result)) as Roads;
  //
  //    // Road API Response
  //     for (int i = 0; i < directions.snappedPoints.length; i++) {
  //       latLogAllList.add(LatLng(directions.snappedPoints[i].location.latitude, directions.snappedPoints[i].location.longitude));
  //       Map<String, double> p = {
  //         'lat': directions.snappedPoints[i].location.latitude,
  //         'lng': directions.snappedPoints[i].location.longitude
  //       };
  //       polylineList.add(p);
  //     }
  //
  //     // Direction API Response
  //     // for (int i = 0; i < directions.polylinePoints.length; i++) {
  //     //   latLogAllList.add(LatLng(directions.polylinePoints[i].latitude, directions.polylinePoints[i].longitude));
  //     //   Map<String, double> p = {
  //     //     'lat': directions.polylinePoints[i].latitude,
  //     //     'lng': directions.polylinePoints[i].longitude
  //     //   };
  //     //   polylineList.add(p);
  //     // }
  //   }
  //
  //   var temp = await Hive.openBox(Connections.temp);
  //
  //
  //   setState(() {
  //     // _info = directions;
  //
  //
  //
  //     print("final LatLog List ${latLogAllList.length}");
  //
  //     print("final polylineList List ${polylineList.length}");
  //
  //     for (int i = 0; i < polylineList.length; i++) {
  //       print("polylineList lat  $i -- ${polylineList[i]['lat'] }\n");
  //       print("polylineList lng  $i -- ${polylineList[i]['lng'] }\n");
  //       temp.add({'lat': polylineList[i]['lat'], 'lng': polylineList[i]['lng']});
  //     }
  //
  //     print("final totalDistance ${allPoints[3]}");
  //
  //     _endTime = DateTime.now();
  //     PolylineId id = const PolylineId('poly');
  //     Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: Colors.red,
  //       // points: _info.data.paths[0].polylinePoints
  //       //     .map((e) => LatLng(e.longitude, e.longitude))
  //       //     .toList()
  //
  //
  //         points: latLogAllList
  //         .map((e) => LatLng(e.latitude, e.longitude))
  //         .toList(),
  //       width: 3,
  //     );
  //
  //       _mapPolyLines[id] = polyline;
  //     _addRoute(endPosition, polylineList, allPoints[3]);
  //   });
  //
  //
  //     print("_addRoute");
  //   // _addRoute(endPosition, points[1], points[2]);
  // }

  // Future<List> _createPoints() async {
  //   double totalDistance = 0.0;
  //   final List<LatLng> points = <LatLng>[];
  //   List<Map<String, double>> polyPoints = [];
  //   var box = await Hive.openBox(Connections.locations);
  //   print("object length of box ${box.length}");
  //   for (int i=0; i<box.length; i++) {
  //     print("object length of box ${box.getAt(i)['lat']}\n");
  //     points.add(LatLng(box.getAt(i)['lat'], box.getAt(i)['long']));
  //     Map<String, double> p = {'lat': box.getAt(i)['lat'], 'lng': box.getAt(i)['long']};
  //     totalDistance += _coordinateDistance(box.getAt(i)['lat'], box.getAt(i)['long'],
  //         box.getAt(box.length - 1 == i ? i : i + 1)['lat'],
  //         box.getAt(box.length - 1 == i ? i : i + 1)['long']);
  //     polyPoints.add(p);
  //   }
  //   print("poly points ${polyPoints.length}");
  //   await box.deleteFromDisk();
  //   return [points, polyPoints, totalDistance.toStringAsFixed(2)];
  // }

  //================================================

  _createPolyLines(Position endPosition) async {

    var allPoints = await _createAllPoints();
    List<LatLng> latLogAllList = <LatLng>[];
    // print("points returned ${allPoints.length} \n ${allPoints[0]} \n ${allPoints[1]} \n ${allPoints[2]}   ");
    latLogAllList = allPoints[2];
    setState(() {

      _endTime = DateTime.now();
      PolylineId id = const PolylineId('overview_polyline');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: _info!.polylinePoints
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
        width: 3,
      );

      //   PolylineId id = const PolylineId('poly');
      // Polyline polyline = Polyline(
      // polylineId: id,
      // color: Colors.red,
      // points: latLogAllList
      //     .map((e) => LatLng(e.latitude, e.longitude))
      //     .toList(),
      // width: 3,
      // );

      _mapPolyLines[id] = polyline;
      _addRoute(endPosition, allPoints[0], allPoints[1]);
    });

    print("_addRoute");
    // _addRoute(endPosition, points[1], points[2]);
  }


  double lastLat = 0, lastLong = 0;

  Future<List> _createPoints() async {
    double totalDistance = 0.0;
    final List<LatLng> points = <LatLng>[];
    List<Map<String, double>> polyPoints = [];
    var box = await Hive.openBox(Connections.locations);
    print("object length of box ${box.length}");

    if (box.length > 0) {
      dynamic item = box.getAt(0);
      lastLat = item['lat'];
      lastLong = item['long'];
    }

    for (int i = 0; i < box.length; i++) {
      print("object length of box ${box.getAt(i)['lat']}\n");
      points.add(LatLng(box.getAt(i)['lat'], box.getAt(i)['long']));
      Map<String, double> p = {
        'lat': box.getAt(i)['lat'],
        'lng': box.getAt(i)['long']
      };

      double distance = _coordinateDistance(
          lastLat,
          lastLong,
          box.getAt(box.length - 1 == i ? i : i + 1)['lat'],
          box.getAt(box.length - 1 == i ? i : i + 1)['long']);

      // double distance = _coordinateDistance(
      //     box.getAt(i)['lat'],
      //     box.getAt(i)['long'],
      //     box.getAt(box.length - 1 == i ? i : i + 1)['lat'],
      //     box.getAt(box.length - 1 == i ? i : i + 1)['long']);

      if (distance < 1) {
        totalDistance += distance;
        lastLat = box.getAt(box.length - 1 == i ? i : i + 1)['lat'];
        lastLong = box.getAt(box.length - 1 == i ? i : i + 1)['long'];
        polyPoints.add(p);
      }
    }
    print("poly points ${polyPoints.length}");
    await box.deleteFromDisk();
    return [points, polyPoints, totalDistance.toStringAsFixed(2)];
  }

  // Future<List> _createAllPoints() async {
  //   double totalDistance = 0.0;
  //   final List<LatLng> points = <LatLng>[];
  //
  //   final List<LatLng> currentAllLocationsList = <LatLng>[];
  //   final List<LatLng> lastPoints = <LatLng>[];
  //   List<Map<String, double>> polyPoints = [];
  //   var multiLocations = await Hive.openBox(Connections.multiLocations);
  //   var lastLocationList = await Hive.openBox(Connections.lastLocationList);
  //   // final List<LatLng> testLocationList = <LatLng>[const LatLng(20.365749032416183, 72.92380924497297),
  //   //   const LatLng(20.365748945251145, 72.9238092146211),
  //   //   const LatLng(20.365748314607195, 72.92380899502349),
  //   //   const LatLng(20.365746741322532, 72.92380844718737),
  //   //   const LatLng(20.365742557036096, 72.92380699016994),
  //   //   const LatLng(20.36574245268598, 72.92380695383402),
  //   //   const LatLng(20.365739915684436, 72.92380607042047),
  //   //   const LatLng(20.36573709427527, 72.92380508797291),
  //   //   const LatLng(20.365735963870183, 72.9238046943527),
  //   //   const LatLng(20.365728809114977, 72.92380220298375),
  //   //   const LatLng(20.36572101280408, 72.92379948821794),
  //   //   const LatLng(20.36571381791215, 72.92379698287343),
  //   //   const LatLng(20.365708463152398, 72.92379511828437),
  //   //   const LatLng(20.365658560708617, 72.92377774168484),
  //   //   const LatLng(20.365637668943805, 72.92377046693781),
  //   //   const LatLng(20.365746418859015, 72.92380833490179),
  //   //   const LatLng(20.3661455, 72.9239473),
  //   //   const LatLng(20.3661455, 72.9239473),
  //   //   const LatLng(20.366195332120896, 72.92384785590063),
  //   //   const LatLng(20.366216316259717, 72.92380598027141),
  //   //   const LatLng(20.366223548376425, 72.92379154796171),
  //   //   const LatLng(20.36623093870968, 72.92377679991345),
  //   //   const LatLng(20.366257585779884, 72.92372362335139),
  //   //   const LatLng(20.36631140381468, 72.92361622459613),
  //   //   const LatLng(20.3663639900877, 72.92351128373393),
  //   //   const LatLng(20.366394899999996, 72.92344960000001),
  //   //   const LatLng(20.366394899999996, 72.92344960000001),
  //   //   const LatLng(20.366395472034565, 72.9234483483014),
  //   //   const LatLng(20.366428688703376, 72.92337566512987),
  //   //   const LatLng(20.36647486765094, 72.92327461834081),
  //   //   const LatLng(20.366499599999997, 72.9232205),
  //   //   const LatLng(20.3665004, 72.9231985),
  //   //   const LatLng(20.3664988, 72.9231732),
  //   //   const LatLng(20.366494310374556, 72.9231597943567),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366489260651626, 72.92314915887619),
  //   //   const LatLng(20.366485716871583, 72.92314503141436),
  //   //   const LatLng(20.366474699999998, 72.9231322),
  //   //   const LatLng(20.366474699999998, 72.9231322),
  //   //   const LatLng(20.366379050626175, 72.92307961786375),
  //   //   const LatLng(20.366215175411767, 72.92298952953287),
  //   //   const LatLng(20.366051136699603, 72.92289935153819),
  //   //   const LatLng(20.365969816544297, 72.92285464699724),
  //   //   const LatLng(20.36592939613173, 72.9228324264989),
  //   //   const LatLng(20.365930567846824, 72.92283307063103),
  //   //   const LatLng(20.365959394284598, 72.92284891751946),
  //   //   const LatLng(20.366001342340024, 72.9228719778263),
  //   //   const LatLng(20.366146575619787, 72.92295181772735),
  //   //   const LatLng(20.366331131078354, 72.92305327467469),
  //   //   const LatLng(20.366474699999998, 72.9231322),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.366491699999997, 72.923152),
  //   //   const LatLng(20.3664988, 72.9231732),
  //   //   const LatLng(20.3665004, 72.9231985),
  //   //   const LatLng(20.366499599999997, 72.9232205),
  //   //   const LatLng(20.366394899999996, 72.92344960000001),
  //   //   const LatLng(20.366394899999996, 72.92344960000001),
  //   //   const LatLng(20.366861999999998, 72.9235254),
  //   //   const LatLng(20.366861999999998, 72.9235254),
  //   //   const LatLng(20.3668434, 72.9237263),
  //   //   const LatLng(20.3668074, 72.9241741),
  //   //   const LatLng(20.3668074, 72.9241741),
  //   //   const LatLng(20.367128786506626, 72.92428424848026),
  //   //   const LatLng(20.3672544, 72.9243273),
  //   //   const LatLng(20.3672544, 72.9243273),
  //   //   const LatLng(20.3672696, 72.9242287),
  //   //   const LatLng(20.367279999999997, 72.9242012),
  //   //   const LatLng(20.367295, 72.924182),
  //   //   const LatLng(20.367314699999994, 72.9241669),
  //   //   const LatLng(20.367352800000003, 72.92414269999999),
  //   //   const LatLng(20.367564299999998, 72.9240786),
  //   //   const LatLng(20.367564299999998, 72.9240786),
  //   //   const LatLng(20.36789927107084, 72.92405675530978),
  //   //   const LatLng(20.367978101249573, 72.92405161449133),
  //   //   const LatLng(20.36802530317798, 72.92404853626994),
  //   //   const LatLng(20.368164053352526, 72.92403948782031),
  //   //   const LatLng(20.3681654, 72.9240394),
  //   //   const LatLng(20.3681654, 72.9240394),
  //   //   const LatLng(20.36826861139695, 72.92403264688504),
  //   //   const LatLng(20.368347015170766, 72.92402751692516),
  //   //   const LatLng(20.368399644345242, 72.92402407339472),
  //   //   const LatLng(20.3684619, 72.92402),
  //   //   const LatLng(20.368519799999998, 72.9240185),
  //   //   const LatLng(20.3685522, 72.92402349999999),
  //   //   const LatLng(20.368574499999998, 72.92403159999999),
  //   //   const LatLng(20.368597099999995, 72.9240489),
  //   //   const LatLng(20.3686194, 72.9240712),
  //   //   const LatLng(20.368824699999998, 72.92441149999999),
  //   //   const LatLng(20.368824699999998, 72.92441149999999),
  //   //   const LatLng(20.3689818, 72.924432),
  //   //   const LatLng(20.369051699999996, 72.9243291),
  //   //   const LatLng(20.369278299999998, 72.9242015),
  //   //   const LatLng(20.369428999999997, 72.9242082),
  //   //   const LatLng(20.369581699999998, 72.92433969999999),
  //   //   const LatLng(20.369581699999998, 72.92433969999999),
  //   //   const LatLng(20.369647200000003, 72.9242934),
  //   //   const LatLng(20.369647200000003, 72.9242934),
  //   //   const LatLng(20.3699561, 72.9240748),
  //   //   const LatLng(20.3699561, 72.9240748),
  //   //   const LatLng(20.370481899999994, 72.92372189999999),
  //   //   const LatLng(20.370481899999994, 72.92372189999999),
  //   //   const LatLng(20.3706641, 72.9235906),
  //   //   const LatLng(20.3706641, 72.9235906),
  //   //   const LatLng(20.3712001, 72.9232256),
  //   //   const LatLng(20.3712001, 72.9232256),
  //   //   const LatLng(20.371073699999997, 72.9230181),
  //   //   const LatLng(20.3709309, 72.92275),
  //   //   const LatLng(20.3709309, 72.92275),
  //   //   const LatLng(20.3709746, 72.9227008),
  //   //   const LatLng(20.3712962, 72.9224596),
  //   //   const LatLng(20.3712962, 72.9224596),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.370900300000002, 72.9218751),
  //   //   const LatLng(20.372028877753113, 72.92082230499824),
  //   //   const LatLng(20.372287300000004, 72.92064669999999),
  //   //   const LatLng(20.372362703132733, 72.92058940304456),
  //   //   const LatLng(20.372578400000002, 72.9204255),
  //   //   const LatLng(20.372700356888316, 72.92034179086086),
  //   //   const LatLng(20.37305547557888, 72.92009804250655),
  //   //   const LatLng(20.373178499999998, 72.92001359999999),
  //   //   const LatLng(20.373407705751486, 72.91985478568557),
  //   //   const LatLng(20.37375125705427, 72.91961674144126),
  //   //   const LatLng(20.3737581, 72.919612),
  //   //   const LatLng(20.37409511821682, 72.91937581835694),
  //   //   const LatLng(20.374246399999997, 72.9192698),
  //   //   const LatLng(20.374246399999997, 72.9192698),
  //   //   const LatLng(20.374426945254385, 72.91914610940546),
  //   //   const LatLng(20.374555700000002, 72.9190579),
  //   //   const LatLng(20.3746346, 72.918998),
  //   //   const LatLng(20.3746346, 72.918998),
  //   //   const LatLng(20.3747041, 72.91894529999999),
  //   //   const LatLng(20.3747041, 72.91894529999999),
  //   //   const LatLng(20.37472049764668, 72.91893374002679),
  //   //   const LatLng(20.375031690473715, 72.91871435549471),
  //   //   const LatLng(20.37534925635694, 72.9184904769776),
  //   //   const LatLng(20.3756654, 72.9182676),
  //   //   const LatLng(20.37567821577878, 72.91825891955475),
  //   //   const LatLng(20.37600855271347, 72.91803517354671),
  //   //   const LatLng(20.376156299999998, 72.9179351),
  //   //   const LatLng(20.376336282384734, 72.91780985617135),
  //   //   const LatLng(20.376638, 72.9175999),
  //   //   const LatLng(20.37665916581806, 72.91758534669121),
  //   //   const LatLng(20.376982800554845, 72.91736281955056),
  //   //   const LatLng(20.37732775159382, 72.91712563434928),
  //   //   const LatLng(20.3774728, 72.9170259),
  //   //   const LatLng(20.377687536013244, 72.91688454331161),
  //   //   const LatLng(20.3778465, 72.9167799),
  //   //   const LatLng(20.3778465, 72.9167799),
  //   //   const LatLng(20.37806379843806, 72.91662385231726),
  //   //   const LatLng(20.378263, 72.9164808),
  //   //   const LatLng(20.378427809067478, 72.91635938153115),
  //   //   const LatLng(20.378707400000003, 72.9161534),
  //   //   const LatLng(20.378770952958234, 72.91610815956481),
  //   //   const LatLng(20.379057754823535, 72.91590399790817),
  //   //   const LatLng(20.379113099999998, 72.91586459999999),
  //   //   const LatLng(20.379113099999998, 72.91586459999999),
  //   //   const LatLng(20.379346189440827, 72.91570291438035),
  //   //   const LatLng(20.37965374587263, 72.91548957282683),
  //   //   const LatLng(20.379719299999998, 72.9154441),
  //   //   const LatLng(20.379962678371843, 72.91527761505336),
  //   //   const LatLng(20.380274259902027, 72.9150644742592),
  //   //   const LatLng(20.38059245329721, 72.91484680947403),
  //   //   const LatLng(20.380675500000002, 72.91479),
  //   //   const LatLng(20.3809293828514, 72.91460595242455),
  //   //   const LatLng(20.3809667, 72.9145789),
  //   //   const LatLng(20.381110900000003, 72.9144788),
  //   //   const LatLng(20.381110900000003, 72.9144788),
  //   //   const LatLng(20.381248947891354, 72.91438249254058),
  //   //   const LatLng(20.38157723269081, 72.9141534677381),
  //   //   const LatLng(20.3819214818815, 72.91391330425694),
  //   //   const LatLng(20.3819718, 72.9138782),
  //   //   const LatLng(20.382284660576744, 72.91367740170985),
  //   //   const LatLng(20.38265734687388, 72.9134382051805),
  //   //   const LatLng(20.3828437, 72.9133186),
  //   //   const LatLng(20.383036272222117, 72.91318077421799),
  //   //   const LatLng(20.383405621271528, 72.91291642638916),
  //   //   const LatLng(20.383454699999998, 72.9128813),
  //   //   const LatLng(20.383772788966308, 72.91265647714256),
  //   //   const LatLng(20.38415355872745, 72.91238735048957),
  //   //   const LatLng(20.384650316379673, 72.91203624158919),
  //   //   const LatLng(20.38488, 72.9118739),
  //   //   const LatLng(20.38488, 72.9118739),
  //   //   const LatLng(20.385013288537706, 72.91178277091697),
  //   //   const LatLng(20.385312499999998, 72.9115782),
  //   //   const LatLng(20.385312499999998, 72.9115782),
  //   //   const LatLng(20.385384707936385, 72.9115283371318),
  //   //   const LatLng(20.3856489, 72.9113459),
  //   //   const LatLng(20.38576672648621, 72.91127622815618),
  //   //   const LatLng(20.3858307, 72.9112384),
  //   //   const LatLng(20.3861034, 72.9110953),
  //   //   const LatLng(20.38616398958893, 72.91106823249115),
  //   //   const LatLng(20.3861907, 72.9110563),
  //   //   const LatLng(20.3863481, 72.9110019),
  //   //   const LatLng(20.3865134, 72.9109577),
  //   //   const LatLng(20.386534973253, 72.91095287901274),
  //   //   const LatLng(20.3865935, 72.9109398),
  //   //   const LatLng(20.3868589, 72.9109024),
  //   //   const LatLng(20.386901998208582, 72.91089939167719),
  //   //   const LatLng(20.386995, 72.9108929),
  //   //   const LatLng(20.3871456, 72.9108907),
  //   //   const LatLng(20.38730167161925, 72.9109027799927),
  //   //   const LatLng(20.387451799999997, 72.9109144),
  //   //   const LatLng(20.3877594, 72.9109685),
  //   //   const LatLng(20.387856543227418, 72.91098127598981),
  //   //   const LatLng(20.388113784450557, 72.91101510767265),
  //   //   const LatLng(20.388401899999998, 72.911053),
  //   //   const LatLng(20.388401899999998, 72.911053),
  //   //   const LatLng(20.388503680007208, 72.91106866915966),
  //   //   const LatLng(20.38909727856785, 72.91116005481848),
  //   //   const LatLng(20.389521593132542, 72.91122537931103),
  //   //   const LatLng(20.389632799999994, 72.9112425),
  //   //   const LatLng(20.38995922676124, 72.91129151851568),
  //   //   const LatLng(20.390407003175014, 72.91135876008134),
  //   //   const LatLng(20.3904985, 72.9113725),
  //   //   const LatLng(20.3904985, 72.9113725),
  //   //   const LatLng(20.390847701780913, 72.91142790013156),
  //   //   const LatLng(20.391285322168912, 72.91149732804834),
  //   //   const LatLng(20.391724841076595, 72.91156705756407),
  //   //   const LatLng(20.3917478, 72.9115707),
  //   //   const LatLng(20.39217024272603, 72.91164454035763),
  //   //   const LatLng(20.3923302, 72.9116725),
  //   //   const LatLng(20.392608825457906, 72.91174408359164),
  //   //   const LatLng(20.3926591, 72.911757),
  //   //   const LatLng(20.3929881, 72.9118439),
  //   //   const LatLng(20.393020474607614, 72.91185464376825),
  //   //   const LatLng(20.393259300000004, 72.9119339),
  //   //   const LatLng(20.393424247014206, 72.91199620568881),
  //   //   const LatLng(20.3937488, 72.9121188),
  //   //   const LatLng(20.393845945904236, 72.91215201412626),
  //   //   const LatLng(20.394252194133223, 72.91229091062847),
  //   //   const LatLng(20.394534699999998, 72.9123875),
  //   //   const LatLng(20.394673703838365, 72.91243333827332),
  //   //   const LatLng(20.395062741181647, 72.91256162871699),
  //   //   const LatLng(20.3953659, 72.91266159999999),
  //   //   const LatLng(20.39540209313503, 72.91267112163739),
  //   //   const LatLng(20.395673256176394, 72.91274245896297),
  //   //   const LatLng(20.395944742905545, 72.91281388170322),
  //   //   const LatLng(20.3960387, 72.9128386),
  //   //   const LatLng(20.396271811707116, 72.91289506452055),
  //   //   const LatLng(20.396626769557418, 72.9129810430565),
  //   //   const LatLng(20.3966815, 72.9129943),
  //   //   const LatLng(20.3966815, 72.9129943),
  //   //   const LatLng(20.39701969112005, 72.91307329256945),
  //   //   const LatLng(20.397262899999998, 72.9131301),
  //   //   const LatLng(20.397412743744095, 72.9131679628901),
  //   //   const LatLng(20.3976729, 72.91323369999999),
  //   //   const LatLng(20.39780938843435, 72.91327659634372),
  //   //   const LatLng(20.3978829, 72.9132997),
  //   //   const LatLng(20.398175391945525, 72.91340184560704),
  //   //   const LatLng(20.398522513861753, 72.91352306991587),
  //   //   const LatLng(20.398855399439174, 72.91363932305286),
  //   //   const LatLng(20.3990154, 72.91369519999999),
  //   //   const LatLng(20.39914915098098, 72.91373740235798),
  //   //   const LatLng(20.39939548685096, 72.91381512875115),
  //   //   const LatLng(20.39965614150552, 72.91389737343503),
  //   //   const LatLng(20.399726899999997, 72.9139197),
  //   //   const LatLng(20.399726899999997, 72.9139197),
  //   //   const LatLng(20.399814600000003, 72.9139509),
  //   //   const LatLng(20.399874188367253, 72.91396889839628),
  //   //   const LatLng(20.400132564663, 72.91404693995298),
  //   //   const LatLng(20.4002642, 72.9140867),
  //   //   const LatLng(20.4002642, 72.9140867),
  //   //   const LatLng(20.400427314715884, 72.91413370757658),
  //   //   const LatLng(20.4007533737232, 72.91422767392483),
  //   //   const LatLng(20.4010033, 72.9142997),
  //   //   const LatLng(20.4010033, 72.9142997),
  //   //   const LatLng(20.40118219710107, 72.91435236991242),
  //   //   const LatLng(20.401390527460766, 72.91441370556495),
  //   //   const LatLng(20.401822722425887, 72.91454095093937),
  //   //   const LatLng(20.402027699999998, 72.9146013),
  //   //   const LatLng(20.402191321556273, 72.91465016173946),
  //   //   const LatLng(20.402575031838815, 72.91476474823712),
  //   //   const LatLng(20.40295040856037, 72.91487684667715),
  //   //   const LatLng(20.403325931115145, 72.9149889892353),
  //   //   const LatLng(20.40372447757938, 72.91510800806086),
  //   //   const LatLng(20.4039036, 72.9151615),
  //   //   const LatLng(20.404102852240037, 72.91522286210132),
  //   //   const LatLng(20.40447431767783, 72.91533725975025),
  //   //   const LatLng(20.40480911430598, 72.91544036525123),
  //   //   const LatLng(20.4050086, 72.9155018),
  //   //   const LatLng(20.4050086, 72.9155018),
  //   //   const LatLng(20.405127840931485, 72.91553339822019),
  //   //   const LatLng(20.405541262827114, 72.91564295324044),
  //   //   const LatLng(20.4055671, 72.9156498),
  //   //   const LatLng(20.405711099999998, 72.915685),
  //   //   const LatLng(20.405885259348455, 72.91571048216198),
  //   //   const LatLng(20.405897000000003, 72.9157122),
  //   //   const LatLng(20.405897000000003, 72.9157122),
  //   //   const LatLng(20.406209300000004, 72.9157658),
  //   //   const LatLng(20.406209300000004, 72.9157658),
  //   //   const LatLng(20.40622217706559, 72.91576804876522),
  //   //   const LatLng(20.406366200000004, 72.9157932),
  //   //   const LatLng(20.40657337085847, 72.9158248662071),
  //   //   const LatLng(20.40693138562561, 72.91587958921149),
  //   //   const LatLng(20.4069537, 72.915883),
  //   //   const LatLng(20.407301844730075, 72.91592890995555),
  //   //   const LatLng(20.407683026239667, 72.91599240041556),
  //   //   const LatLng(20.4077979, 72.9160101),
  //   //   const LatLng(20.407994300000002, 72.9160503),
  //   //   const LatLng(20.408060392306503, 72.9160658120711),
  //   //   const LatLng(20.4081038, 72.91607599999999),
  //   //   const LatLng(20.4081038, 72.91607599999999),
  //   //   const LatLng(20.408141699999995, 72.9160875),
  //   //   const LatLng(20.408267699999996, 72.9161307),
  //   //   const LatLng(20.40840997753881, 72.9161857611261),
  //   //   const LatLng(20.408496899999996, 72.9162194),
  //   //   const LatLng(20.4087285, 72.9163275),
  //   //   const LatLng(20.408788885958383, 72.91635401700712),
  //   //   const LatLng(20.40917407974781, 72.91652316590847),
  //   //   const LatLng(20.409181900000004, 72.9165266),
  //   //   const LatLng(20.409338, 72.9165897),
  //   //   const LatLng(20.4095294, 72.9166506),
  //   //   const LatLng(20.409559758226667, 72.9166576798067),
  //   //   const LatLng(20.4096366, 72.91667559999999),
  //   //   const LatLng(20.4096366, 72.91667559999999),
  //   //   const LatLng(20.4097458, 72.91669619999999),
  //   //   const LatLng(20.409871199999998, 72.9167174),
  //   //   const LatLng(20.409911319386865, 72.91672323783402),
  //   //   const LatLng(20.4101887, 72.9167636),
  //   //   const LatLng(20.410252694465303, 72.91676723930009),
  //   //   const LatLng(20.41062114597961, 72.91678819282157),
  //   //   const LatLng(20.410679299999998, 72.9167915),
  //   //   const LatLng(20.41100246027524, 72.9168038740202),
  //   //   const LatLng(20.41137017709634, 72.91681795420317),
  //   //   const LatLng(20.411761040324038, 72.91683292075507),
  //   //   const LatLng(20.4121714877553, 72.91684863728797),
  //   //   const LatLng(20.412416, 72.91685799999999),
  //   //   const LatLng(20.412416, 72.91685799999999),
  //   //   const LatLng(20.412562676965585, 72.91686762365005),
  //   //   const LatLng(20.412896099999998, 72.9168895),
  //   //   const LatLng(20.412951902433345, 72.91689021096823),
  //   //   const LatLng(20.413217899999996, 72.9168936),
  //   //   const LatLng(20.4135019, 72.9168916),
  //   //   const LatLng(20.41351102229758, 72.91689109916315),
  //   //   const LatLng(20.41395020672222, 72.91686698677451),
  //   //   const LatLng(20.414046499999998, 72.9168617),
  //   //   const LatLng(20.414046499999998, 72.9168617),
  //   //   const LatLng(20.414090100000003, 72.9168595),
  //   //   const LatLng(20.41440101369601, 72.91682974197916),
  //   //   const LatLng(20.4145728, 72.9168133),
  //   //   const LatLng(20.41484136048432, 72.91679245392604),
  //   //   const LatLng(20.4150353, 72.9167774),
  //   //   const LatLng(20.4150353, 72.9167774),
  //   //   const LatLng(20.415273082572444, 72.91675648555238),
  //   //   const LatLng(20.415309299999997, 72.9167533),
  //   //   const LatLng(20.4156487, 72.91672919999999),
  //   //   const LatLng(20.415699903911058, 72.91672043145383),
  //   //   const LatLng(20.416012500000004, 72.9166669),
  //   //   const LatLng(20.416012500000004, 72.9166669),
  //   //   const LatLng(20.416091482822996, 72.9166536965566),
  //   //   const LatLng(20.4162117, 72.9166336),
  //   //   const LatLng(20.4163651, 72.9165962),
  //   //   const LatLng(20.416453900278917, 72.91656793579347),
  //   //   const LatLng(20.4165335, 72.9165426),
  //   //   const LatLng(20.4167019, 72.9164868),
  //   //   const LatLng(20.41680322190348, 72.91644181784383),
  //   //   const LatLng(20.416950800000002, 72.9163763),
  //   //   const LatLng(20.417061399999994, 72.9163221),
  //   //   const LatLng(20.417116293102318, 72.91629252291597),
  //   //   const LatLng(20.4172147, 72.9162395),
  //   //   const LatLng(20.417384666362707, 72.91613541332771),
  //   //   const LatLng(20.4174309, 72.91610709999999),
  //   //   const LatLng(20.417671590086638, 72.91596392175072),
  //   //   const LatLng(20.4176802, 72.9159588),
  //   //   const LatLng(20.4176802, 72.9159588),
  //   //   const LatLng(20.4179739089909, 72.91578479445097),
  //   //   const LatLng(20.418175100000003, 72.9156656),
  //   //   const LatLng(20.418276930206275, 72.91561000031626),
  //   //   const LatLng(20.418324000000002, 72.91558429999999),
  //   //   const LatLng(20.418454200000003, 72.91551969999999),
  //   //   const LatLng(20.418624199999996, 72.9154409),
  //   //   const LatLng(20.418799000000003, 72.915394),
  //   //   const LatLng(20.418988982885942, 72.91534988378706),
  //   //   const LatLng(20.419007000000004, 72.9153457),
  //   //   const LatLng(20.4191704, 72.91532370000002),
  //   //   const LatLng(20.4191704, 72.91532370000002),
  //   //   const LatLng(20.41932507656744, 72.91532230985719),
  //   //   const LatLng(20.4193373, 72.91532219999999),
  //   //   const LatLng(20.419510499999998, 72.9153228),
  //   //   const LatLng(20.419583585148814, 72.91533013415547),
  //   //   const LatLng(20.419652999999997, 72.9153371),
  //   //   const LatLng(20.41979904583713, 72.91536305509491),
  //   //   const LatLng(20.4198038, 72.91536390000002),
  //   //   const LatLng(20.4198038, 72.91536390000002),
  //   //   const LatLng(20.4198314, 72.9152539),
  //   //   const LatLng(20.4198314, 72.9152539),
  //   //   const LatLng(20.420088962613026, 72.91533302360921),
  //   //   const LatLng(20.420207700000002, 72.91536950000001),
  //   //   const LatLng(20.4203688, 72.9154284),
  //   //   const LatLng(20.42039021476671, 72.91543732502761),
  //   //   const LatLng(20.4205298, 72.91549549999999),
  //   //   const LatLng(20.420674705511377, 72.91557361539316),
  //   //   const LatLng(20.4206795, 72.91557619999999),
  //   //   const LatLng(20.4208011, 72.9156471),
  //   //   const LatLng(20.420915, 72.9157207),
  //   //   const LatLng(20.420946686493394, 72.91574438927913),
  //   //   const LatLng(20.4210303, 72.91580689999999),
  //   //   const LatLng(20.421181999999998, 72.9159329),
  //   //   const LatLng(20.421181999999998, 72.9159329),
  //   //   const LatLng(20.421225171941085, 72.91595903700104),
  //   //   const LatLng(20.42151057130923, 72.91613182288661),
  //   //   const LatLng(20.421606499999996, 72.91618989999999),
  //   //   const LatLng(20.421606499999996, 72.91618989999999),
  //   //   const LatLng(20.421741045345243, 72.91630311082609),
  //   //   const LatLng(20.42196548893591, 72.91649196553504),
  //   //   const LatLng(20.42219852587588, 72.91668805175368),
  //   //   const LatLng(20.42242148604853, 72.91687565972262),
  //   //   const LatLng(20.4225216, 72.9169599),
  //   //   const LatLng(20.4225216, 72.9169599),
  //   //   const LatLng(20.42263891598163, 72.9170630576188),
  //   //   const LatLng(20.422837299999998, 72.9172375),
  //   //   const LatLng(20.422874828745307, 72.91726685816012),
  //   //   const LatLng(20.4229852, 72.9173532),
  //   //   const LatLng(20.4231037, 72.9174366),
  //   //   const LatLng(20.423223900000004, 72.91751579999999),
  //   //   const LatLng(20.423255794246938, 72.91753448369705),
  //   //   const LatLng(20.423402799999998, 72.91762059999999),
  //   //   const LatLng(20.423593341257412, 72.91770752444008),
  //   //   const LatLng(20.423677899999998, 72.91774610000002),
  //   //   const LatLng(20.423951199999998, 72.91783509999999),
  //   //   const LatLng(20.423956016583908, 72.91783628171868),
  //   //   const LatLng(20.4241982, 72.9178957),
  //   //   const LatLng(20.424333614851975, 72.91792391710928),
  //   //   const LatLng(20.4243964, 72.917937),
  //   //   const LatLng(20.4244724, 72.9179556),
  //   //   const LatLng(20.424523600000004, 72.91798720000001),
  //   //   const LatLng(20.4245688, 72.9180338),
  //   //   const LatLng(20.4245688, 72.9180338),
  //   //   const LatLng(20.424652216495478, 72.91803519317642),
  //   //   const LatLng(20.424760399999997, 72.918037),
  //   //   const LatLng(20.424760399999997, 72.918037),
  //   //   const LatLng(20.424981974382867, 72.91801762580694),
  //   //   const LatLng(20.425066899999997, 72.9180102),
  //   //   const LatLng(20.425066899999997, 72.9180102),
  //   //   const LatLng(20.425167700000003, 72.917997),
  //   //   const LatLng(20.425302499999997, 72.9179624),
  //   //   const LatLng(20.42532172398092, 72.91795715709992),
  //   //   const LatLng(20.4254301, 72.9179276),
  //   //   const LatLng(20.4255358, 72.9178921),
  //   //   const LatLng(20.425676600000003, 72.9178413),
  //   //   const LatLng(20.425681521327185, 72.9178396837143),
  //   //   const LatLng(20.425832800000002, 72.91779),
  //   //   const LatLng(20.425969299999995, 72.91774749999999),
  //   //   const LatLng(20.4260607970973, 72.91771223428995),
  //   //   const LatLng(20.426412700000004, 72.91757659999999),
  //   //   const LatLng(20.426431329434006, 72.91756966311702),
  //   //   const LatLng(20.426706499999998, 72.91746719999999),
  //   //   const LatLng(20.42681257259424, 72.91742614261156),
  //   //   const LatLng(20.42719039629004, 72.91727989836869),
  //   //   const LatLng(20.4273113, 72.91723309999999),
  //   //   const LatLng(20.427558611827955, 72.9171342236139),
  //   //   const LatLng(20.427824800000003, 72.9170278),
  //   //   const LatLng(20.427950863599726, 72.91697969264345),
  //   //   const LatLng(20.428063, 72.9169369),
  //   //   const LatLng(20.428443799999997, 72.9167872),
  //   //   const LatLng(20.4284669, 72.9167794),
  //   //   const LatLng(20.4284669, 72.9167794),
  //   //   const LatLng(20.428476470276934, 72.91677693984624),
  //   //   const LatLng(20.428608499999996, 72.916743),
  //   //   const LatLng(20.42885779817258, 72.91668597230142),
  //   //   const LatLng(20.428860300000004, 72.91668539999999),
  //   //   const LatLng(20.428928799999998, 72.9166704),
  //   //   const LatLng(20.428928799999998, 72.9166704),
  //   //   const LatLng(20.4290365, 72.9166437),
  //   //   const LatLng(20.4291346, 72.9166261),
  //   //   const LatLng(20.429185366952563, 72.91661840803826),
  //   //   const LatLng(20.429200599999998, 72.9166161),
  //   //   const LatLng(20.4293425, 72.9166048),
  //   //   const LatLng(20.4295276, 72.916608),
  //   //   const LatLng(20.429536799269172, 72.91660843998655),
  //   //   const LatLng(20.429709499999998, 72.91661669999999),
  //   //   const LatLng(20.429918337910262, 72.91663047821746),
  //   //   const LatLng(20.4301051, 72.91664279999999),
  //   //   const LatLng(20.430313644780362, 72.91665425491801),
  //   //   const LatLng(20.430701309084828, 72.91667554857042),
  //   //   const LatLng(20.431065861568648, 72.91669557283316),
  //   //   const LatLng(20.431079099999994, 72.9166963),
  //   //   const LatLng(20.43141154886345, 72.91670383785669),
  //   //   const LatLng(20.431418699999995, 72.916704),
  //   //   const LatLng(20.43170544293606, 72.91671791116988),
  //   //   const LatLng(20.4319667334054, 72.91673058757308),
  //   //   const LatLng(20.4320515, 72.91673469999999),
  //   //   const LatLng(20.432101684577358, 72.91673845270972),
  //   //   const LatLng(20.4322093, 72.9167465),
  //   //   const LatLng(20.432251272303493, 72.91675044489094),
  //   //   const LatLng(20.43242853981808, 72.91676710592579),
  //   //   const LatLng(20.432527349532066, 72.91677639287866),
  //   //   const LatLng(20.432563599999998, 72.9167798),
  //   //   const LatLng(20.432563599999998, 72.9167798),
  //   //   const LatLng(20.432641913394203, 72.91678771205638),
  //   //   const LatLng(20.432809761689846, 72.91680466991299),
  //   //   const LatLng(20.433000099999997, 72.9168239),
  //   //   const LatLng(20.433109891165063, 72.91683435675455),
  //   //   const LatLng(20.43347492958726, 72.9168691239329),
  //   //   const LatLng(20.433799775041784, 72.91690006317117),
  //   //   const LatLng(20.434015400000003, 72.9169206),
  //   //   const LatLng(20.434028777189937, 72.91692226925218),
  //   //   const LatLng(20.434186904053632, 72.91694200089321),
  //   //   const LatLng(20.43430317962161, 72.91695651020451),
  //   //   const LatLng(20.4344201, 72.9169711),
  //   //   const LatLng(20.4344201, 72.9169711),
  //   //   const LatLng(20.434428848976037, 72.9169722582348),
  //   //   const LatLng(20.43456030608726, 72.91698966122458),
  //   //   const LatLng(20.434741606307764, 72.91701366275878),
  //   //   const LatLng(20.43491047380945, 72.91703601843165),
  //   //   const LatLng(20.435004, 72.9170484),
  //   //   const LatLng(20.435004, 72.9170484),
  //   //   const LatLng(20.435059037758844, 72.91705646736521),
  //   //   const LatLng(20.435283860437217, 72.91708942165013),
  //   //   const LatLng(20.4355989, 72.9171356),
  //   //   const LatLng(20.4355989, 72.9171356),
  //   //   const LatLng(20.435718078368165, 72.91715306577441),
  //   //   const LatLng(20.4359005, 72.9171798),
  //   //   const LatLng(20.435952995431027, 72.9171867155894),
  //   //   const LatLng(20.43630716639996, 72.9172333731265),
  //   //   const LatLng(20.4365313, 72.9172629),
  //   //   const LatLng(20.436680708342333, 72.91727795476672),
  //   //   const LatLng(20.437071597560166, 72.91731734190309),
  //   //   const LatLng(20.437160499999997, 72.9173263),
  //   //   const LatLng(20.437160499999997, 72.9173263),
  //   //   const LatLng(20.4373805, 72.9173533),
  //   //   const LatLng(20.43759362410655, 72.91737702593925),
  //   //   const LatLng(20.437900600000003, 72.9174112),
  //   //   const LatLng(20.43800734392965, 72.91742480862331),
  //   //   const LatLng(20.438186899999998, 72.9174477),
  //   //   const LatLng(20.438416857751044, 72.91747263962802),
  //   //   const LatLng(20.4386802, 72.9175012),
  //   //   const LatLng(20.4386802, 72.9175012),
  //   //   const LatLng(20.438837550270954, 72.91751428433392),
  //   //   const LatLng(20.439261713310426, 72.91754955540056),
  //   //   const LatLng(20.439693002107106, 72.91759328363516),
  //   //   const LatLng(20.4399721, 72.9176225),
  //   //   const LatLng(20.440137902786198, 72.91764375464574),
  //   //   const LatLng(20.4403793, 72.91767469999999),
  //   //   const LatLng(20.440585050169695, 72.91770506726937),
  //   //   const LatLng(20.441021367316942, 72.91776946486493),
  //   //   const LatLng(20.44147735611491, 72.91783676626359),
  //   //   const LatLng(20.44193834534013, 72.91790480610713),
  //   //   const LatLng(20.442098200000004, 72.9179284),
  //   //   const LatLng(20.442540893248953, 72.91798386579006),
  //   //   const LatLng(20.44284550498391, 72.91802203129923),
  //   //   const LatLng(20.443082300000004, 72.91805169999999),
  //   //   const LatLng(20.44331325800893, 72.9180750170802),
  //   //   const LatLng(20.44377193327317, 72.91812132426897),
  //   //   const LatLng(20.444230189010064, 72.9181675893801),
  //   //   const LatLng(20.444542300000002, 72.9181991),
  //   //   const LatLng(20.444826895737364, 72.91823034422308),
  //   //   const LatLng(20.445088102827548, 72.91825902083576),
  //   //   const LatLng(20.4450952, 72.9182598),
  //   //   const LatLng(20.445515824083213, 72.91829894941678),
  //   //   const LatLng(20.4456829, 72.9183145),
  //   //   const LatLng(20.4456829, 72.9183145),
  //   //   const LatLng(20.4457391, 72.9183223),
  //   //   const LatLng(20.446097357743238, 72.91836208098135),
  //   //   const LatLng(20.446518816044502, 72.91840887999872),
  //   //   const LatLng(20.4466838, 72.9184272),
  //   //   const LatLng(20.446971705818118, 72.91846186785853),
  //   //   const LatLng(20.4472344, 72.9184935),
  //   //   const LatLng(20.447437486671166, 72.91852217228572),
  //   //   const LatLng(20.447789, 72.9185718),
  //   //   const LatLng(20.447900656646418, 72.91858856994084),
  //   //   const LatLng(20.448353717472802, 72.91865661632853),
  //   //   const LatLng(20.4486965, 72.9187081),
  //   //   const LatLng(20.4486965, 72.9187081),
  //   //   const LatLng(20.44882580010463, 72.91872902851131),
  //   //   const LatLng(20.4489739, 72.918753),
  //   //   const LatLng(20.4489739, 72.918753),
  //   //   const LatLng(20.449303701017215, 72.91880544153138),
  //   //   const LatLng(20.449762671184136, 72.91887842257775),
  //   //   const LatLng(20.4498751, 72.9188963),
  //   //   const LatLng(20.450229306283095, 72.9189540466904),
  //   //   const LatLng(20.450693872427934, 72.9190297858945),
  //   //   const LatLng(20.45114764346467, 72.91910376559655),
  //   //   const LatLng(20.45172505559204, 72.91919790352894),
  //   //   const LatLng(20.452108999999997, 72.9192605),
  //   //   const LatLng(20.452108999999997, 72.9192605),
  //   //   const LatLng(20.452147972647904, 72.91926682272008),
  //   //   const LatLng(20.452552800000003, 72.9193325),
  //   //   const LatLng(20.452552800000003, 72.9193325),
  //   //   const LatLng(20.452561459224057, 72.91933378151981),
  //   //   const LatLng(20.45298274934913, 72.91939613042769),
  //   //   const LatLng(20.45339104750062, 72.91945655691555),
  //   //   const LatLng(20.4537204, 72.9195053),
  //   //   const LatLng(20.45382282818086, 72.91951810973715),
  //   //   const LatLng(20.454251450620873, 72.9195717137342),
  //   //   const LatLng(20.454674132257548, 72.91962457506276),
  //   //   const LatLng(20.4549382, 72.9196576),
  //   //   const LatLng(20.4549382, 72.9196576),
  //   //   const LatLng(20.455116517250566, 72.91968827745654),
  //   //   const LatLng(20.4554811, 72.91975099999999),
  //   //   const LatLng(20.45554490854452, 72.91975956948177),
  //   //   const LatLng(20.455997712419133, 72.91982038120754),
  //   //   const LatLng(20.456452799999997, 72.9198815),
  //   //   const LatLng(20.456452799999997, 72.9198815),
  //   //   const LatLng(20.45645765388981, 72.91988214118444),
  //   //   const LatLng(20.456918705434358, 72.91994304491224),
  //   //   const LatLng(20.457377802832937, 72.92000369086846),
  //   //   const LatLng(20.4573809, 72.92000410000001),
  //   //   const LatLng(20.45785207612356, 72.92006153664273),
  //   //   const LatLng(20.458300040652727, 72.92011614410757),
  //   //   const LatLng(20.458703833362936, 72.92016536724438),
  //   //   const LatLng(20.459106005503834, 72.92021439308951),
  //   //   const LatLng(20.459521079087928, 72.92026499192562),
  //   //   const LatLng(20.4597131, 72.92028839999999),
  //   //   const LatLng(20.4598865, 72.9203072),
  //   //   const LatLng(20.459925125055985, 72.9203082507561),
  //   //   const LatLng(20.460085, 72.9203126),
  //   //   const LatLng(20.46034143645836, 72.92029697230772),
  //   //   const LatLng(20.4604821, 72.92028839999999),
  //   //   const LatLng(20.460753378198632, 72.92026284375945),
  //   //   const LatLng(20.4608515, 72.9202536),
  //   //   const LatLng(20.4610324, 72.9202348),
  //   //   const LatLng(20.461185699999998, 72.9202241),
  //   //   const LatLng(20.461191431351853, 72.9202238632037),
  //   //   const LatLng(20.4613164, 72.92021869999999),
  //   //   const LatLng(20.4615097, 72.9202258),
  //   //   const LatLng(20.461617900000004, 72.92023209999999),
  //   //   const LatLng(20.461731000000004, 72.92024280000001),
  //   //   const LatLng(20.461731000000004, 72.92024280000001),
  //   //   const LatLng(20.46174612310879, 72.92024453728811),
  //   //   const LatLng(20.4619051, 72.9202628),
  //   //   const LatLng(20.462008388303335, 72.92028251317389),
  //   //   const LatLng(20.462093199999998, 72.9202987),
  //   //   const LatLng(20.462196799999994, 72.9203256),
  //   //   const LatLng(20.462314, 72.9203501),
  //   //   const LatLng(20.462387993003638, 72.9203693145823),
  //   //   const LatLng(20.4624018, 72.92037289999999),
  //   //   const LatLng(20.4624018, 72.92037289999999),
  //   //   const LatLng(20.462525499999998, 72.9204048),
  //   //   const LatLng(20.4627117, 72.9204664),
  //   //   const LatLng(20.462723871100987, 72.92047165584658),
  //   //   const LatLng(20.4628958, 72.9205459),
  //   //   const LatLng(20.463034650701736, 72.92061557383059),
  //   //   const LatLng(20.4630355, 72.920616),
  //   //   const LatLng(20.463192699999997, 72.9207025),
  //   //   const LatLng(20.46332068503175, 72.92078312087817),
  //   //   const LatLng(20.4634186, 72.9208448),
  //   //   const LatLng(20.463551, 72.9209333),
  //   //   const LatLng(20.463561607371137, 72.920941606969),
  //   //   const LatLng(20.4636838, 72.9210373),
  //   //   const LatLng(20.46378271247519, 72.92111232026072),
  //   //   const LatLng(20.4638672, 72.9211764),
  //   //   const LatLng(20.4638672, 72.9211764),
  //   //   const LatLng(20.464000553485516, 72.92127786169202),
  //   //   const LatLng(20.46407, 72.9213307),
  //   //   const LatLng(20.464197700000003, 72.9214348),
  //   //   const LatLng(20.464197700000003, 72.9214348),
  //   //   const LatLng(20.464255672453913, 72.92148460586169),
  //   //   const LatLng(20.464499399999998, 72.921694),
  //   //   const LatLng(20.46454112808342, 72.92172728441138),
  //   //   const LatLng(20.464891299999998, 72.9220066),
  //   //   const LatLng(20.464950722090855, 72.92205803982857),
  //   //   const LatLng(20.465150891031293, 72.92223132015195),
  //   //   const LatLng(20.465461954533495, 72.92250059980468),
  //   //   const LatLng(20.4656432, 72.9226575),
  //   //   const LatLng(20.46579239113815, 72.92279008340468),
  //   //   const LatLng(20.465804, 72.9228004),
  //   //   const LatLng(20.465804, 72.9228004),
  //   //   const LatLng(20.46613029633, 72.92308293103476),
  //   //   const LatLng(20.466459120038802, 72.92336765207219),
  //   //   const LatLng(20.466528699999998, 72.9234279),
  //   //   const LatLng(20.466602899999998, 72.9234937),
  //   //   const LatLng(20.466602899999998, 72.9234937),
  //   //   const LatLng(20.466890052407777, 72.92372485316885),
  //   //   const LatLng(20.467229910176382, 72.92399843475881),
  //   //   const LatLng(20.467575550705217, 72.92427667299997),
  //   //   const LatLng(20.4677972, 72.9244551),
  //   //   const LatLng(20.4677972, 72.9244551),
  //   //   const LatLng(20.467911564454184, 72.92454923793422),
  //   //   const LatLng(20.468249839688056, 72.9248276868086),
  //   //   const LatLng(20.468529999999998, 72.9250583),
  //   //   const LatLng(20.468587352860904, 72.92510678117168),
  //   //   const LatLng(20.46891832709211, 72.92538655922624),
  //   //   const LatLng(20.469236333468942, 72.92565537682947),
  //   //   const LatLng(20.469294800000004, 72.9257048),
  //   //   const LatLng(20.469534557180303, 72.92590520204378),
  //   //   const LatLng(20.46979819044106, 72.92612556195373),
  //   //   const LatLng(20.4698035, 72.92613),
  //   //   const LatLng(20.4698035, 72.92613),
  //   //   const LatLng(20.469983799999998, 72.9262832),
  //   //   const LatLng(20.470055864513544, 72.9263425106912),
  //   //   const LatLng(20.470227899999998, 72.9264841),
  //   //   const LatLng(20.470227899999998, 72.9264841),
  //   //   const LatLng(20.470323291456932, 72.92656258900145),
  //   //   const LatLng(20.4704734, 72.9266861),
  //   //   const LatLng(20.4704734, 72.9266861),
  //   //   const LatLng(20.470603820610254, 72.9267967354108),
  //   //   const LatLng(20.4706349, 72.9268231),
  //   //   const LatLng(20.470716600000003, 72.92689510000001),
  //   //   const LatLng(20.470716600000003, 72.92689510000001),
  //   //   const LatLng(20.470884245044974, 72.92702841041113),
  //   //   const LatLng(20.470891399999996, 72.9270341),
  //   //   const LatLng(20.470891399999996, 72.9270341),
  //   //   const LatLng(20.471203773684657, 72.92729794311025),
  //   //   const LatLng(20.471389600000002, 72.92745490000001),
  //   //   const LatLng(20.471568251570172, 72.92759998291258),
  //   //   const LatLng(20.471981528309012, 72.92793560655751),
  //   //   const LatLng(20.4720192, 72.9279662),
  //   //   const LatLng(20.4720192, 72.9279662),
  //   //   const LatLng(20.47237931948985, 72.92826338047193),
  //   //   const LatLng(20.472576500000002, 72.9284261),
  //   //   const LatLng(20.47274147494991, 72.92856001872774),
  //   //   const LatLng(20.4731109157986, 72.92885991438202),
  //   //   const LatLng(20.473171999999995, 72.9289095),
  //   //   const LatLng(20.473505954809415, 72.92918634193391),
  //   //   const LatLng(20.473639199999997, 72.9292968),
  //   //   const LatLng(20.47389406165338, 72.92950517653256),
  //   //   const LatLng(20.474266483071887, 72.92980967229754),
  //   //   const LatLng(20.4742741, 72.9298159),
  //   //   const LatLng(20.4746404483008, 72.93011260180666),
  //   //   const LatLng(20.474992245241555, 72.93039752033026),
  //   //   const LatLng(20.47536020501809, 72.93069553085118),
  //   //   const LatLng(20.4755655, 72.9308618),
  //   //   const LatLng(20.4755655, 72.9308618),
  //   //   const LatLng(20.475678300000002, 72.930954),
  //   //   const LatLng(20.475678300000002, 72.930954),
  //   //   const LatLng(20.475748989747355, 72.93101120975112),
  //   //   const LatLng(20.4760564, 72.93126),
  //   //   const LatLng(20.4760564, 72.93126),
  //   //   const LatLng(20.476144318812562, 72.93133115263757),
  //   //   const LatLng(20.476290799999997, 72.9314497),
  //   //   const LatLng(20.476511189940606, 72.93163342472552),
  //   //   const LatLng(20.4767308, 72.9318165),
  //   //   const LatLng(20.47684530928967, 72.93191013300654),
  //   //   const LatLng(20.476896999999997, 72.9319524),
  //   //   const LatLng(20.476896999999997, 72.9319524),
  //   //   const LatLng(20.477150089466758, 72.93215923129539),
  //   //   const LatLng(20.4772778, 72.9322636),
  //   //   const LatLng(20.477439272756026, 72.9323939189366),
  //   //   const LatLng(20.4777448751205, 72.9326405607357),
  //   //   const LatLng(20.478045094465827, 72.93288331668788),
  //   //   const LatLng(20.478315703468727, 72.93310244587218),
  //   //   const LatLng(20.4783543, 72.9331337),
  //   //   const LatLng(20.4783543, 72.9331337),
  //   //   const LatLng(20.47858656667947, 72.93331751726569),
  //   //   const LatLng(20.47886566723483, 72.93353840008473),
  //   //   const LatLng(20.479083, 72.9337104),
  //   //   const LatLng(20.479239683240422, 72.93383779664946),
  //   //   const LatLng(20.479467698757983, 72.9340231930381),
  //   //   const LatLng(20.4795415, 72.9340832),
  //   //   const LatLng(20.47967158461381, 72.93418416192998),
  //   //   const LatLng(20.479776899999997, 72.9342659),
  //   //   const LatLng(20.479776899999997, 72.9342659),
  //   //   const LatLng(20.479776899999997, 72.9342659),
  //   //   const LatLng(20.479923799999998, 72.9343758),
  //   //   const LatLng(20.479943714300394, 72.93439165351091),
  //   //   const LatLng(20.48008868810426, 72.93450706539545),
  //   //   const LatLng(20.4801641, 72.9345671),
  //   //   const LatLng(20.480272791888904, 72.93465565309235),
  //   //   const LatLng(20.4803924, 72.9347531),
  //   //   const LatLng(20.480519343596026, 72.93484516359578),
  //   //   const LatLng(20.480575100000003, 72.9348856),
  //   //   const LatLng(20.480712476339402, 72.93497436481299),
  //   //   const LatLng(20.4807229, 72.9349811),
  //   //   const LatLng(20.480838199999997, 72.93504999999999),
  //   //   const LatLng(20.4811265, 72.935182),
  //   //   const LatLng(20.48114371380442, 72.93518782728133),
  //   //   const LatLng(20.4812742, 72.93523200000001),
  //   //   const LatLng(20.481437199999995, 72.9352658),
  //   //   const LatLng(20.48147531153238, 72.93527156701863),
  //   //   const LatLng(20.481607699999994, 72.9352916),
  //   //   const LatLng(20.4817982, 72.93530919999999),
  //   //   const LatLng(20.48180056709575, 72.93530931825522),
  //   //   const LatLng(20.4820364, 72.9353211),
  //   //   const LatLng(20.4820990097888, 72.93532291238667),
  //   //   const LatLng(20.482264400000002, 72.9353277),
  //   //   const LatLng(20.482264400000002, 72.9353277),
  //   //   const LatLng(20.48232747446411, 72.93532937188577),
  //   //   const LatLng(20.482499096659847, 72.93533392100323),
  //   //   const LatLng(20.482692466091038, 72.93533904657774),
  //   //   const LatLng(20.482950407159404, 72.9353458837497),
  //   //   const LatLng(20.4830227, 72.9353478),
  //   //   const LatLng(20.483288195351943, 72.93535670832671),
  //   //   const LatLng(20.483416100000003, 72.93536100000001),
  //   //   const LatLng(20.483416100000003, 72.93536100000001),
  //   //   const LatLng(20.48366811118992, 72.9353762592813),
  //   //   const LatLng(20.4840123, 72.9353971),
  //   //   const LatLng(20.484069492740627, 72.93540011407397),
  //   //   const LatLng(20.484241900000004, 72.93540920000001),
  //   //   const LatLng(20.484307100000002, 72.9354157),
  //   //   const LatLng(20.484307100000002, 72.9354157),
  //   //   const LatLng(20.484471599999996, 72.9354322),
  //   //   const LatLng(20.48448325257325, 72.93543353356546),
  //   //   const LatLng(20.4847783, 72.9354673),
  //   //   const LatLng(20.484789060490026, 72.93546908499977),
  //   //   const LatLng(20.485012800000003, 72.93550619999999),
  //   //   const LatLng(20.485053077358764, 72.9355143932242),
  //   //   const LatLng(20.485235000000003, 72.9355514),
  //   //   const LatLng(20.485333857560395, 72.93557334051853),
  //   //   const LatLng(20.485471999999998, 72.935604),
  //   //   const LatLng(20.4857043, 72.935659),
  //   //   const LatLng(20.485753581230643, 72.93567299586236),
  //   //   const LatLng(20.4858293, 72.9356945),
  //   //   const LatLng(20.485961200000002, 72.935735),
  //   //   const LatLng(20.486124642918796, 72.93579232163098),
  //   //   const LatLng(20.486143400000003, 72.9357989),
  //   //   const LatLng(20.486475499999997, 72.9359351),
  //   //   const LatLng(20.486475499999997, 72.9359351),
  //   //   const LatLng(20.486498706212718, 72.93594525136778),
  //   //   const LatLng(20.4865834, 72.93598229999999),
  //   //   const LatLng(20.486642399999997, 72.9360102),
  //   //   const LatLng(20.48684261801323, 72.93610777936401),
  //   //   const LatLng(20.4869313, 72.936151),
  //   //   const LatLng(20.4869313, 72.936151),
  //   //   const LatLng(20.48716153437477, 72.93626974305721),
  //   //   const LatLng(20.4872964, 72.9363393),
  //   //   const LatLng(20.48747182644473, 72.93642611189073),
  //   //   const LatLng(20.4874813, 72.9364308),
  //   //   const LatLng(20.487661700000004, 72.9365272),
  //   //   const LatLng(20.487661700000004, 72.9365272),
  //   //   const LatLng(20.487778965462248, 72.93658355151229),
  //   //   const LatLng(20.4878519, 72.9366186),
  //   //   const LatLng(20.4879571, 72.93667669999999),
  //   //   const LatLng(20.488089003433636, 72.93675444390819),
  //   //   const LatLng(20.4881439, 72.9367868),
  //   //   const LatLng(20.488229599999997, 72.93684309999999),
  //   //   const LatLng(20.488376799999998, 72.9369335),
  //   //   const LatLng(20.488376799999998, 72.9369335),
  //   //   const LatLng(20.488390169998038, 72.93694453262144),
  //   //   const LatLng(20.488558699999995, 72.9370836),
  //   //   const LatLng(20.48869163955413, 72.93720859652336),
  //   //   const LatLng(20.488781299999996, 72.9372929),
  //   //   const LatLng(20.4889305, 72.9374538),
  //   //   const LatLng(20.4889305, 72.9374538),
  //   //   const LatLng(20.488938189490494, 72.93746301966242),
  //   //   const LatLng(20.4890501, 72.9375972),
  //   //   const LatLng(20.489216188034376, 72.93779972363586),
  //   //   const LatLng(20.4892648, 72.937859),
  //   //   const LatLng(20.489401360497954, 72.9380471982217),
  //   //   const LatLng(20.489484299999997, 72.9381615),
  //   //   const LatLng(20.48950962632016, 72.93819563926716),
  //   //   const LatLng(20.4896277, 72.9383548),
  //   //   const LatLng(20.4896277, 72.9383548),
  //   //   const LatLng(20.48970621312829, 72.93846043707099),
  //   //   const LatLng(20.489740299999998, 72.9385063),
  //   //   const LatLng(20.48981287698269, 72.93860079934947),
  //   //   const LatLng(20.4899055, 72.93872139999999),
  //   //   const LatLng(20.4899055, 72.93872139999999),
  //   //   const LatLng(20.4899793, 72.93881739999999),
  //   //   const LatLng(20.49003620484064, 72.93889615184845),
  //   //   const LatLng(20.490190800000004, 72.9391101),
  //   //   const LatLng(20.49020098467002, 72.93912442761905),
  //   //   const LatLng(20.490340656727664, 72.9393209162324),
  //   //   const LatLng(20.490429499999998, 72.9394459),
  //   //   const LatLng(20.490492513397733, 72.93953196017463),
  //   //   const LatLng(20.4905416, 72.939599),
  //   //   const LatLng(20.4906536, 72.9397463),
  //   //   const LatLng(20.490655536545983, 72.9397485836363),
  //   //   const LatLng(20.490815399999995, 72.9399371),
  //   //   const LatLng(20.4908926, 72.94001770000001),
  //   //   const LatLng(20.490924067991273, 72.94004853631218),
  //   //   const LatLng(20.491002199999997, 72.9401251),
  //   //   const LatLng(20.4911769, 72.9402697),
  //   //   const LatLng(20.491267179259495, 72.94033548136511),
  //   //   const LatLng(20.491276399999997, 72.9403422),
  //   //   const LatLng(20.4913714, 72.9404042),
  //   //   const LatLng(20.4914584, 72.9404632),
  //   //   const LatLng(20.491555899999998, 72.9405251),
  //   //   const LatLng(20.491555899999998, 72.9405251),
  //   //   const LatLng(20.49158131791481, 72.94053768189265),
  //   //   const LatLng(20.491826, 72.9406588),
  //   //   const LatLng(20.491960999721016, 72.94071441040846),
  //   //   const LatLng(20.491968500000002, 72.94071749999999),
  //   //   const LatLng(20.4922791, 72.9408299),
  //   //   const LatLng(20.492438524167596, 72.94088054847697),
  //   //   const LatLng(20.4928419, 72.9410087),
  //   //   const LatLng(20.492971077584695, 72.94105106299305),
  //   //   const LatLng(20.493508879124683, 72.9412274324984),
  //   //   const LatLng(20.494020939386086, 72.94139536147586),
  //   //   const LatLng(20.49452759430871, 72.94156151894128),
  //   //   const LatLng(20.4945934, 72.9415831),
  //   //   const LatLng(20.4945934, 72.9415831),
  //   //   const LatLng(20.49502054891278, 72.94172307075364),
  //   //   const LatLng(20.495474282775877, 72.94187175392015),
  //   //   const LatLng(20.495532099999995, 72.9418907),
  //   //   const LatLng(20.495931440862382, 72.94203199070326),
  //   //   const LatLng(20.4962223, 72.9421349),
  //   //   const LatLng(20.496373560577084, 72.94218735529982),
  //   //   const LatLng(20.496850414672416, 72.94235272312362),
  //   //   const LatLng(20.49730379437469, 72.9425099512873),
  //   //   const LatLng(20.497758609357025, 72.94266767817766),
  //   //   const LatLng(20.49827395174761, 72.94284639677215),
  //   //   const LatLng(20.4982829, 72.9428495),
  //   //   const LatLng(20.4982829, 72.9428495),
  //   //   const LatLng(20.49879054499799, 72.94306840536349),
  //   //   const LatLng(20.4992003, 72.9432451),
  //   //   const LatLng(20.4992003, 72.9432451),
  //   //   const LatLng(20.499281053673197, 72.94327354691552),
  //   //   const LatLng(20.499802517016715, 72.94345724240031),
  //   //   const LatLng(20.4998217, 72.94346399999999),
  //   //   const LatLng(20.500286605685645, 72.94361773086297),
  //   //   const LatLng(20.500522999999998, 72.9436959),
  //   //   const LatLng(20.500702200000003, 72.94375),
  //   //   const LatLng(20.500753607325642, 72.9437646179685),
  //   //   const LatLng(20.5009336, 72.9438158),
  //   //   const LatLng(20.5011316, 72.9438603),
  //   //   const LatLng(20.501228909497787, 72.94387366400392),
  //   //   const LatLng(20.5013515, 72.9438905),
  //   //   const LatLng(20.501531300000003, 72.9439134),
  //   //   const LatLng(20.501531300000003, 72.9439134),
  //   //   const LatLng(20.501655418709024, 72.9439173552208),
  //   //   const LatLng(20.501794899999997, 72.9439218),
  //   //   const LatLng(20.50207084193241, 72.94389504442685),
  //   //   const LatLng(20.5021404, 72.9438883),
  //   //   const LatLng(20.5022965, 72.9438598),
  //   //   const LatLng(20.502491326363817, 72.94381069126987),
  //   //   const LatLng(20.502502399999997, 72.9438079),
  //   //   const LatLng(20.502708299999995, 72.94374789999999),
  //   //   const LatLng(20.502923719077454, 72.94367815915896),
  //   //   const LatLng(20.503184599999997, 72.9435937),
  //   //   const LatLng(20.503184599999997, 72.9435937),
  //   //   const LatLng(20.503364776704984, 72.94353991131983),
  //   //   const LatLng(20.50380501729883, 72.94340848445124),
  //   //   const LatLng(20.5039145, 72.9433758),
  //   //   const LatLng(20.5039145, 72.9433758),
  //   //   const LatLng(20.504241264545705, 72.94327522700436),
  //   //   const LatLng(20.504678024183523, 72.94314079854895),
  //   //   const LatLng(20.505065975282303, 72.94302139200389),
  //   //   const LatLng(20.505451400424736, 72.94290276229317),
  //   //   const LatLng(20.505538999999995, 72.9428758),
  //   //   const LatLng(20.50575, 72.9428147),
  //   //   const LatLng(20.505877899999998, 72.9427804),
  //   //   const LatLng(20.505877899999998, 72.9427804),
  //   //   const LatLng(20.505903999999994, 72.9427798),
  //   //   const LatLng(20.505927717063344, 72.94277453844657),
  //   //   const LatLng(20.505992799999998, 72.9427601),
  //   //   const LatLng(20.506098400000003, 72.9427477),
  //   //   const LatLng(20.5062553533305, 72.94274850264341),
  //   //   const LatLng(20.506313499999997, 72.94274879999999),
  //   //   const LatLng(20.5064085, 72.9427601),
  //   //   const LatLng(20.5065189, 72.9427754),
  //   //   const LatLng(20.506588228736476, 72.94279166130545),
  //   //   const LatLng(20.5066937, 72.9428164),
  //   //   const LatLng(20.506873799999997, 72.9428655),
  //   //   const LatLng(20.506959340757096, 72.94289125417588),
  //   //   const LatLng(20.5071342, 72.9429439),
  //   //   const LatLng(20.507339560715632, 72.94300929100208),
  //   //   const LatLng(20.507734219901927, 72.94313495897696),
  //   //   const LatLng(20.508005999999998, 72.94322149999999),
  //   //   const LatLng(20.508157939135874, 72.94326923229399),
  //   //   const LatLng(20.5083762, 72.94333780000001),
  //   //   const LatLng(20.508548, 72.9433933),
  //   //   const LatLng(20.508589832445804, 72.94340886552192),
  //   //   const LatLng(20.50901278343385, 72.94356624274296),
  //   //   const LatLng(20.50942451366859, 72.94371944568263),
  //   //   const LatLng(20.509722699999994, 72.9438304),
  //   //   const LatLng(20.509722699999994, 72.9438304),
  //   //   const LatLng(20.50977657828118, 72.94384702320762),
  //   //   const LatLng(20.510090866905138, 72.9439439917452),
  //   //   const LatLng(20.510143400000004, 72.94396019999999),
  //   //   const LatLng(20.510355481994452, 72.94403331630801),
  //   //   const LatLng(20.510517524330144, 72.94408918134177),
  //   //   const LatLng(20.5105740174906, 72.94410865771526),
  //   //   const LatLng(20.510605489681055, 72.94411950795806),
  //   //   const LatLng(20.510621999999998, 72.9441252),
  //   //   const LatLng(20.510621999999998, 72.9441252),
  //   //   const LatLng(20.510670683525966, 72.94414190755805),
  //   //   const LatLng(20.510772627484585, 72.94405381074439),
  //   //   const LatLng(20.5108139022881, 72.94406747593155),
  //   //   const LatLng(20.51083279935157, 72.94407373233967),
  //   //   const LatLng(20.51084355905751, 72.94407729464582),
  //   //   const LatLng(20.510847189166196, 72.94407849649647),
  //   //   const LatLng(20.510857073681304, 72.94408176904646),
  //   //   const LatLng(20.51087679366286, 72.94408829790882),
  //   //   const LatLng(20.510880861301153, 72.94408964461671),
  //   //   const LatLng(20.510881108799182, 72.94408972655802),
  //   //   const LatLng(20.510884399413612, 72.94409081601002),
  //   //   const LatLng(20.510914578022213, 72.94410080750359),
  //   //   const LatLng(20.51092956737258, 72.94410577015931),
  //   //   const LatLng(20.51093223978484, 72.94410665493838),
  //   //   const LatLng(20.51093439310895, 72.9441073678584),
  //   //   const LatLng(20.51101717076985, 72.94413477380485),
  //   //   const LatLng(20.511300609380637, 72.9442286146162),
  //   //   const LatLng(20.5115129, 72.94429889999999),
  //   //   const LatLng(20.5115129, 72.94429889999999),
  //   //   const LatLng(20.511623108380583, 72.94433599149517),
  //   //   const LatLng(20.5117093, 72.94436499999999),
  //   //   const LatLng(20.51195781413439, 72.94444343388312),
  //   //   const LatLng(20.5123164283063, 72.94455661705676),
  //   //   const LatLng(20.5125125, 72.9446185),
  //   //   const LatLng(20.512647472000964, 72.94467826100347),
  //   //   const LatLng(20.512764099999995, 72.9447299),
  //   //   const LatLng(20.5128731, 72.9447873),
  //   //   const LatLng(20.5128731, 72.9447873),
  //   //   const LatLng(20.51291226746131, 72.94480827219827),
  //   //   const LatLng(20.5129676, 72.9448379),
  //   //   const LatLng(20.513157053894467, 72.94496539936728),
  //   //   const LatLng(20.513278899999996, 72.94504739999999),
  //   //   const LatLng(20.513374544711667, 72.94512030874508),
  //   //   const LatLng(20.51350806603862, 72.94522209054253),
  //   //   const LatLng(20.5135149, 72.9452273),
  //   //   const LatLng(20.513547220365936, 72.94525786621917),
  //   //   const LatLng(20.51358256889585, 72.94529129627311),
  //   //   const LatLng(20.513646009682763, 72.94535129398277),
  //   //   const LatLng(20.513688099999996, 72.9453911),
  //   //   const LatLng(20.513715141395668, 72.94542169122367),
  //   //   const LatLng(20.513726951620335, 72.94543505182725),
  //   //   const LatLng(20.51373436065423, 72.94544343347847),
  //   //   const LatLng(20.513739899999997, 72.9454497),
  //   //   const LatLng(20.513739899999997, 72.9454497),
  //   //   const LatLng(20.51378851545837, 72.94550463742782),
  //   //   const LatLng(20.5138614, 72.945587),
  //   //   const LatLng(20.51390955381148, 72.94564576333455),
  //   //   const LatLng(20.5140021, 72.9457587),
  //   //   const LatLng(20.51401161219377, 72.94577282037463),
  //   //   const LatLng(20.51413220507479, 72.94595183475813),
  //   //   const LatLng(20.5141629, 72.9459974),
  //   //   const LatLng(20.514367797690884, 72.946298411361),
  //   //   const LatLng(20.514556180796404, 72.94657516283746),
  //   //   const LatLng(20.51475693627781, 72.94687009188951),
  //   //   const LatLng(20.514954215445222, 72.9471599153695),
  //   //   const LatLng(20.514957199999994, 72.9471643),
  //   //   const LatLng(20.514957199999994, 72.9471643),
  //   //   const LatLng(20.515044900000003, 72.94731709999999),
  //   //   const LatLng(20.515117607662397, 72.94743723487471),
  //   //   const LatLng(20.515226833840597, 72.94761770976638),
  //   //   const LatLng(20.5152468, 72.9476507),
  //   //   const LatLng(20.515266601808783, 72.94768425110301),
  //   //   const LatLng(20.515303400000004, 72.9477466),
  //   //   const LatLng(20.515312499999997, 72.9477769),
  //   //   const LatLng(20.51531529518479, 72.9477933858821),
  //   //   const LatLng(20.5153174, 72.9478058),
  //   //   const LatLng(20.5153192, 72.94783780000002),
  //   //   const LatLng(20.5153149, 72.9479085),
  //   //   const LatLng(20.5153149, 72.9479085),
  //   //   const LatLng(20.515434600000003, 72.9480727),
  //   //   const LatLng(20.515434600000003, 72.9480727),
  //   //   const LatLng(20.515488099999995, 72.9480825),
  //   //   const LatLng(20.515527499999997, 72.94810129999999),
  //   //   const LatLng(20.515564599999998, 72.94812809999999),
  //   //   const LatLng(20.5155958, 72.9481586),
  //   //   const LatLng(20.5155958, 72.9481586),
  //   //   const LatLng(20.515602899999998, 72.9481656),
  //   //   const LatLng(20.5156669, 72.9482434),
  //   //   const LatLng(20.515689255832466, 72.94827550103842),
  //   //   const LatLng(20.5158089, 72.9484473),
  //   //   const LatLng(20.5158089, 72.9484473),
  //   //   const LatLng(20.515843161289485, 72.94849654003177),
  //   //   const LatLng(20.515949982069092, 72.94865006221076),
  //   //   const LatLng(20.515986389628218, 72.94870238702802),
  //   //   const LatLng(20.5160342, 72.9487711),
  //   //   const LatLng(20.5160342, 72.9487711),
  //   //   const LatLng(20.51606977766985, 72.94882428763746),
  //   //   const LatLng(20.516193400000002, 72.9490091),
  //   //   const LatLng(20.516193400000002, 72.9490091),
  //   //   const LatLng(20.516199052825737, 72.94901755760637),
  //   //   const LatLng(20.5162849, 72.949146),
  //   //   const LatLng(20.51632179983216, 72.9491995972234),
  //   //   const LatLng(20.5163607, 72.9492561),
  //   //   const LatLng(20.5163607, 72.9492561),
  //   //   const LatLng(20.516455145332184, 72.94939331042494),
  //   //   const LatLng(20.5165853, 72.9495824),
  //   //   const LatLng(20.5165853, 72.9495824),
  //   //   const LatLng(20.516590737051, 72.94959029940397),
  //   //   const LatLng(20.516692454137033, 72.94973808272198),
  //   //   const LatLng(20.51679750293534, 72.94989070703464),
  //   //   const LatLng(20.516876244654004, 72.95000511032781),
  //   //   const LatLng(20.516920826031065, 72.9500698823997),
  //   //   const LatLng(20.51698055182775, 72.95015665784106),
  //   //   const LatLng(20.517053531527637, 72.95026269001798),
  //   //   const LatLng(20.5171967, 72.9504707),
  //   //   const LatLng(20.5171967, 72.9504707),
  //   //   const LatLng(20.5173146, 72.9504707),
  //   //   const LatLng(20.5173146, 72.9504707),
  //   //   const LatLng(20.517320659078727, 72.95047258331002),
  //   //   const LatLng(20.51746865229335, 72.95051858327255),
  //   //   const LatLng(20.517608449658578, 72.95056203584691),
  //   //   const LatLng(20.517794146009503, 72.95061975512054),
  //   //   const LatLng(20.5179455, 72.9506668),
  //   //   const LatLng(20.5179455, 72.9506668),
  //   //   const LatLng(20.518024696522026, 72.95068961352538),
  //   //   const LatLng(20.518061099999997, 72.95070009999999),
  //   //   const LatLng(20.518276466786368, 72.95076866350277),
  //   //   const LatLng(20.5184239, 72.9508156),
  //   //   const LatLng(20.5184239, 72.9508156),
  //   //   const LatLng(20.518505996737268, 72.95084259069903),
  //   //   const LatLng(20.5185553, 72.95085879999999),
  //   //   const LatLng(20.5185553, 72.95085879999999),
  //   //   const LatLng(20.51873599268471, 72.95091000802742),
  //   //   const LatLng(20.518987199999998, 72.9509812),
  //   //   const LatLng(20.518995286691492, 72.95098509477931),
  //   //   const LatLng(20.5190879, 72.9510297),
  //   //   const LatLng(20.51923, 72.9511069),
  //   //   const LatLng(20.519265999999995, 72.95113620000001),
  //   //   const LatLng(20.519265999999995, 72.95113620000001),
  //   //   const LatLng(20.5192977, 72.951162),
  //   //   const LatLng(20.519393110600348, 72.95124680942052),
  //   //   const LatLng(20.519395799999998, 72.95124919999999),
  //   //   const LatLng(20.51946385202117, 72.95133995518285),
  //   //   const LatLng(20.519499172436404, 72.95138705906813),
  //   //   const LatLng(20.519513900000003, 72.95140669999999),
  //   //   const LatLng(20.519513900000003, 72.95140669999999),
  //   //   const LatLng(20.51958095398435, 72.9512586001633),
  //   //   const LatLng(20.519619712218812, 72.95117299599366),
  //   //   const LatLng(20.51965996712086, 72.95108408603438),
  //   //   const LatLng(20.5196869, 72.9510246),
  //   //   const LatLng(20.5197108, 72.9508117),
  //   //   const LatLng(20.5197108, 72.9508117),
  //   //   const LatLng(20.519746474951415, 72.95078880598197),
  //   //   const LatLng(20.51983412171404, 72.95073255955718),
  //   //   const LatLng(20.519849134693306, 72.95072292512171),
  //   //   const LatLng(20.519856679431108, 72.95071808335774),
  //   //   const LatLng(20.519896981555576, 72.95069221984184),
  //   //   const LatLng(20.51993150753839, 72.95067006309867),
  //   //   const LatLng(20.519947116105797, 72.95066004643515),
  //   //   const LatLng(20.519969773043353, 72.95064550653656)];
  //   //
  //
  //   //
  //   //
  //   //
  //   //
  //   // var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
  //   // print("object length multiLocations ${testLocationList.length}");
  //   // print("object length lastLocationList ${testLocationList.length}");
  //   // print("object length currentAllLocations ${testLocationList.length}");
  //   //
  //   //
  //   // if (testLocationList.isNotEmpty) {
  //   //   LatLng item = testLocationList[0];
  //   //   lastLat = item.latitude;
  //   //   lastLong = item.longitude;
  //   // }
  //   //
  //   //
  //   // for (int i = 0; i < testLocationList.length; i++) {
  //   //   print("object length of box currentAllLocations ${testLocationList[i].latitude}\n");
  //   //   currentAllLocationsList.add(LatLng(testLocationList[i].latitude, testLocationList[i].longitude));
  //   //
  //   //   double distance = _coordinateDistance(
  //   //       lastLat,
  //   //       lastLong,
  //   //       testLocationList[testLocationList.length - 1 == i ? i : i + 1].latitude,
  //   //       testLocationList[testLocationList.length - 1 == i ? i : i + 1].latitude);
  //   //
  //   //   if (distance < 1) {
  //   //     totalDistance += distance;
  //   //     lastLat = testLocationList[testLocationList.length - 1 == i ? i : i + 1].latitude;
  //   //     lastLong = testLocationList[testLocationList.length - 1 == i ? i : i + 1].longitude;
  //   //   }
  //   //
  //   //   Marker allMarker = Marker(
  //   //     markerId: MarkerId('${testLocationList[i].latitude}'),
  //   //     position: LatLng(
  //   //       testLocationList[i].latitude,
  //   //       testLocationList[i].longitude,
  //   //     ),
  //   //
  //   //     infoWindow:  InfoWindow(title: "${testLocationList[i].latitude.toString()} : ${testLocationList[i].longitude.toString()}"),
  //   //     icon: _allIcon,
  //   //   );
  //   //
  //   //   _markers.add(allMarker);
  //   // }
  //   //
  //   //
  //   // // for (int i = 0; i < lastLocationList.length; i++) {
  //   // //   print("object length of box currentAllLocations ${lastLocationList[i].latitude}\n");
  //   // //   currentAllLocationsList.add(LatLng(lastLocationList[i].latitude, lastLocationList[i].longitude));
  //   // //
  //   // //   Marker allMarker = Marker(
  //   // //     markerId: MarkerId('${lastLocationList[i].latitude}'),
  //   // //     position: LatLng(
  //   // //       lastLocationList[i].latitude,
  //   // //       lastLocationList[i].longitude,
  //   // //     ),
  //   // //     infoWindow: const InfoWindow(title: 'Start'),
  //   // //     icon: _allIcon,
  //   // //   );
  //   // //
  //   // //   _markers.add(allMarker);
  //   // // }
  //   //
  //   // // if (multiLocations.length > 0) {
  //   // //   dynamic item = multiLocations.getAt(0);
  //   // //   lastLat = item['lat'];
  //   // //   lastLong = item['long'];
  //   // // }
  //   //
  //   // for (int i = 0; i < testLocationList.length; i++) {
  //   //   print("object length of box multiLocations ${testLocationList[i].latitude}\n");
  //   //   points.add(LatLng(testLocationList[i].latitude, testLocationList[i].longitude));
  //   //   Map<String, double> p = {
  //   //     'lat': testLocationList[i].latitude,
  //   //     'lng': testLocationList[i].longitude
  //   //   };
  //   //   polyPoints.add(p);
  //   //   // double distance = _coordinateDistance(
  //   //   //     lastLat,
  //   //   //     lastLong,
  //   //   //     multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['lat'],
  //   //   //     multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['long']);
  //   //   //
  //   //   // if (distance < 1) {
  //   //   //   totalDistance += distance;
  //   //   //   lastLat = multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['lat'];
  //   //   //   lastLong = multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['long'];
  //   //   // }
  //   // }
  //   //
  //   // // print("totalDistance 11 ${totalDistance.toStringAsFixed(2)}");
  //   //
  //   // // if (lastLocationList.length > 0) {
  //   // //   dynamic item = lastLocationList.getAt(0);
  //   // //   lastLat = item['lat'];
  //   // //   lastLong = item['long'];
  //   // // }
  //   //
  //   //
  //   // for (int i = 0; i < testLocationList.length; i++) {
  //   //   // print("object length of box lastLocationList ${testLocationList[i].latitude}\n");
  //   //   // lastPoints.add(LatLng(testLocationList[i].latitude, testLocationList[i].longitude));
  //   //
  //   //
  //   //   // print("object length of box lastLocationList ${lastLocationList[i].latitude}\n");
  //   //   // lastPoints.add(LatLng(lastLocationList[i].latitude, lastLocationList[i].longitude));
  //   //
  //   //
  //   //   // Map<String, double> p = {
  //   //   //   'lat': lastLocationList.getAt(i)['lat'],
  //   //   //   'lng': lastLocationList.getAt(i)['long']
  //   //   // };
  //   //   // double distance = _coordinateDistance(
  //   //   //     lastLat,
  //   //   //     lastLong,
  //   //   //     lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['lat'],
  //   //   //     lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['long']);
  //   //   //
  //   //   // if (distance < 1) {
  //   //   //   totalDistance += distance;
  //   //   //   lastLat = lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['lat'];
  //   //   //   lastLong = lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['long'];
  //   //   //   polyPoints.add(p);
  //   //   // }
  //   // }
  //   //
  //   // print("totalDistance multiLocations  ${totalDistance.toStringAsFixed(2)}");
  //   // await multiLocations.deleteFromDisk();
  //   // await lastLocationList.deleteFromDisk();
  //   // await currentAllLocations.deleteFromDisk();
  //
  //
  //
  //
  //   //===================================================================
  //
  //   var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
  //   print("object length multiLocations ${multiLocations.length}");
  //   print("object length lastLocationList ${lastLocationList.length}");
  //   print("object length currentAllLocations ${currentAllLocations.length}");
  //
  //
  //   if (currentAllLocations.length > 0) {
  //     dynamic item = currentAllLocations.getAt(0);
  //     lastLat = item['lat'];
  //     lastLong = item['lng'];
  //   }
  //
  //
  //   for (int i = 0; i < currentAllLocations.length; i++) {
  //     print("object length of box currentAllLocations ${currentAllLocations.getAt(i)['lat']}\n");
  //     currentAllLocationsList.add(LatLng(currentAllLocations.getAt(i)['lat'], currentAllLocations.getAt(i)['lng']));
  //
  //     double distance = _coordinateDistance(
  //         lastLat,
  //         lastLong,
  //         currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'],
  //         currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng']);
  //
  //     if (distance < 1) {
  //       totalDistance += distance;
  //       lastLat = currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'];
  //       lastLong = currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng'];
  //     }
  //
  //     Marker allMarker = Marker(
  //       markerId: MarkerId('${currentAllLocations.getAt(i)['lat']}'),
  //       position: LatLng(
  //         currentAllLocations.getAt(i)['lat'],
  //         currentAllLocations.getAt(i)['lng'],
  //       ),
  //       infoWindow: const InfoWindow(title: 'Start'),
  //       icon: _allIcon,
  //     );
  //
  //     _markers.add(allMarker);
  //   }
  //
  //
  //   // for (int i = 0; i < lastLocationList.length; i++) {
  //   //   print("object length of box currentAllLocations ${lastLocationList[i].latitude}\n");
  //   //   currentAllLocationsList.add(LatLng(lastLocationList[i].latitude, lastLocationList[i].longitude));
  //   //
  //   //   Marker allMarker = Marker(
  //   //     markerId: MarkerId('${lastLocationList[i].latitude}'),
  //   //     position: LatLng(
  //   //       lastLocationList[i].latitude,
  //   //       lastLocationList[i].longitude,
  //   //     ),
  //   //     infoWindow: const InfoWindow(title: 'Start'),
  //   //     icon: _allIcon,
  //   //   );
  //   //
  //   //   _markers.add(allMarker);
  //   // }
  //
  //   // if (multiLocations.length > 0) {
  //   //   dynamic item = multiLocations.getAt(0);
  //   //   lastLat = item['lat'];
  //   //   lastLong = item['long'];
  //   // }
  //
  //   for (int i = 0; i < multiLocations.length; i++) {
  //     print("object length of box multiLocations ${multiLocations.getAt(i)['lat']}\n");
  //     points.add(LatLng(multiLocations.getAt(i)['lat'], multiLocations.getAt(i)['lng']));
  //     Map<String, double> p = {
  //       'lat': multiLocations.getAt(i)['lat'],
  //       'lng': multiLocations.getAt(i)['lng']
  //     };
  //     polyPoints.add(p);
  //     // double distance = _coordinateDistance(
  //     //     lastLat,
  //     //     lastLong,
  //     //     multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['lat'],
  //     //     multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['long']);
  //     //
  //     // if (distance < 1) {
  //     //   totalDistance += distance;
  //     //   lastLat = multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['lat'];
  //     //   lastLong = multiLocations.getAt(multiLocations.length - 1 == i ? i : i + 1)['long'];
  //     // }
  //   }
  //
  //   // print("totalDistance 11 ${totalDistance.toStringAsFixed(2)}");
  //
  //   // if (lastLocationList.length > 0) {
  //   //   dynamic item = lastLocationList.getAt(0);
  //   //   lastLat = item['lat'];
  //   //   lastLong = item['long'];
  //   // }
  //
  //
  //   for (int i = 0; i < lastLocationList.length; i++) {
  //     print("object length of box lastLocationList ${lastLocationList.getAt(i)['lat']}\n");
  //     lastPoints.add(LatLng(lastLocationList.getAt(i)['lat'], lastLocationList.getAt(i)['lng']));
  //
  //
  //     // print("object length of box lastLocationList ${lastLocationList[i].latitude}\n");
  //     // lastPoints.add(LatLng(lastLocationList[i].latitude, lastLocationList[i].longitude));
  //
  //
  //     // Map<String, double> p = {
  //     //   'lat': lastLocationList.getAt(i)['lat'],
  //     //   'lng': lastLocationList.getAt(i)['long']
  //     // };
  //     // double distance = _coordinateDistance(
  //     //     lastLat,
  //     //     lastLong,
  //     //     lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['lat'],
  //     //     lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['long']);
  //     //
  //     // if (distance < 1) {
  //     //   totalDistance += distance;
  //     //   lastLat = lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['lat'];
  //     //   lastLong = lastLocationList.getAt(lastLocationList.length - 1 == i ? i : i + 1)['long'];
  //     //   polyPoints.add(p);
  //     // }
  //   }
  //
  //   print("totalDistance multiLocations  ${totalDistance.toStringAsFixed(2)}");
  //   await multiLocations.deleteFromDisk();
  //   await lastLocationList.deleteFromDisk();
  //   await currentAllLocations.deleteFromDisk();
  //
  //
  //
  //   //====================================================
  //   return [points,polyPoints,lastPoints,totalDistance.toStringAsFixed(2),currentAllLocationsList];
  // }


  // =============================================


  Future<List> _createAllPoints() async {
    double totalDistance = 0.0;
    final List<LatLng> currentAllLocationsList = <LatLng>[];
    List<Map<String, double>> polyPoints = [];

    var currentAllLocations = await Hive.openBox(Connections.currentAllLocations);
    var temp = await Hive.openBox(Connections.temp);
    print("object length currentAllLocations ${currentAllLocations.length}");

    if (currentAllLocations.length > 0) {
      dynamic item = currentAllLocations.getAt(0);
      lastLat = item['lat'];
      lastLong = item['lng'];
    }

    for (int i = 0; i < currentAllLocations.length; i++) {
      // print("object length of box currentAllLocations ${currentAllLocations.getAt(i)['lat']}\n");
      currentAllLocationsList.add(LatLng(currentAllLocations.getAt(i)['lat'], currentAllLocations.getAt(i)['lng']));
      temp.add({'lat': currentAllLocations.getAt(i)['lat'], 'lng': currentAllLocations.getAt(i)['lng']});
      Map<String, double> p = {
        'lat': currentAllLocations.getAt(i)['lat'],
        'lng': currentAllLocations.getAt(i)['lng']
      };
      polyPoints.add(p);

      // double distance = _coordinateDistance(
      //     lastLat,
      //     lastLong,
      //     currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'],
      //     currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng']);
      //
      // if (distance < 1) {
      //   totalDistance += distance;
      //   lastLat = currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'];
      //   lastLong = currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng'];
      // }

      double distance = _coordinateDistance(
          lastLat,
          lastLong,
          currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'],
          currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng']);

      // if (distance < 1) {
        totalDistance += distance;
        lastLat =  currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lat'];
        lastLong = currentAllLocations.getAt(currentAllLocations.length - 1 == i ? i : i + 1)['lng'];
      // }


    }

    print("totalDistance multiLocations  ${totalDistance.toStringAsFixed(2)}");
    await currentAllLocations.deleteFromDisk();
    return [polyPoints,totalDistance.toStringAsFixed(2),currentAllLocationsList];
  }
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Widget _logoutPopup() {
    return PopupMenuButton<String>(
      onSelected: (option) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.clear();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
            LoginPage()), (Route<dynamic> route) => false);
      },
      itemBuilder: (BuildContext context) {
        return {'Logout'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice, child: Text(choice),
          );
        }).toList();
      },
    );
  }

}

