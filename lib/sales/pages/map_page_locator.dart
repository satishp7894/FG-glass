// import 'package:background_location/background_location.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive/hive.dart';
// import 'dart:math' show cos, sqrt, asin;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
//
// import '../../login.dart';
// import '../../utils/alerts.dart';
// import '../../utils/connections.dart';
// import '../../utils/dialogs.dart';
// import '../../utils/progress_dialog.dart';
// import '../../utils/stop_watch_timer.dart';
//
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();
//   bool? serviceEnabled;
//   LocationPermission? permission;
//   DateTime? _startTime, _endTime;
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;
//
//   GoogleMapController? _mapController;
//   bool recordStarted = false;
//   Position? _startPosition;
//   BitmapDescriptor? _destIcon, _markerIcon;
//   Set<Marker> _markers = {};
//   Map<PolylineId, Polyline> _mapPolyLines = {};
//
//   double lastLat = 0, lastLong = 0;
//
//   final StopWatchTimer _stopWatchTimer = StopWatchTimer();
//   disposeWatch() async {
//     await _stopWatchTimer.dispose();
//   }
//
//   _getLocation() async {
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openLocationSettings();
//       return;
//     }
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         Alerts.showAlert(context, 'Permission Denied',
//             'Please allow app to access location.');
//         return;
//       }
//     }
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled!) {
//       Alerts.showAlert(
//           context, 'Location Disabled', 'Please enable location service.');
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     print('location lat ${position.latitude} long ${position.longitude}');
//     _mapController!
//         .animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: LatLng(position.latitude, position.longitude), zoom: 15),
//       ),
//     )
//         .catchError((e) {
//       print('Error in animating map $e');
//     });
//     setState(() {
//       _startPosition = Position(
//         latitude: position.latitude,
//         longitude: position.longitude,
//         timestamp: DateTime.now(),
//         speed: position.speed,
//         heading: position.heading,
//         accuracy: position.accuracy,
//         altitude: position.altitude,
//         speedAccuracy: position.speedAccuracy,
//       );
//     });
//   }
//
//   _addMark() async {
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openLocationSettings();
//       return;
//     }
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         Alerts.showAlert(context, 'Permission Denied',
//             'Please allow app to access location.');
//         return;
//       }
//     }
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled!) {
//       Alerts.showAlert(
//           context, 'Location Disabled', 'Please enable location service.');
//       return;
//     }
//
//     Dialogs.showLoadingDialog(context, _keyLoader);
//     Position markPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     print(
//         'mark location lat ${markPosition.latitude} long ${markPosition.longitude}');
//     String location = await _getSingleGeocoding(
//         markPosition.latitude, markPosition.longitude);
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     print('location $location');
//     var response = await http.post(Uri.parse(Connections.addMark), body: {
//       'Location': '$location',
//       'Latitude': '${markPosition.latitude}',
//       'Longitude': '${markPosition.longitude}',
//       'UserID': '${_prefs.getInt('UserID')}',
//     });
//     var results = json.decode(response.body);
//     print('mark results $results');
//
//
//
//     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//     if (results['status'] == true) {
//       Marker addonMarker = Marker(
//         markerId: MarkerId('$markPosition'),
//         position: LatLng(
//           markPosition.latitude,
//           markPosition.longitude,
//         ),
//         infoWindow: InfoWindow(title: 'Mark'),
//         icon: _markerIcon!,
//       );
//       setState(() {
//         _markers.add(addonMarker);
//         Fluttertoast.showToast(
//           msg: 'Marked Location Successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.black87,
//           textColor: Colors.white,
//           fontSize: 16,
//         );
//       });
//     } else {
//       Fluttertoast.showToast(
//         msg: 'Failed to mark location',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black87,
//         textColor: Colors.white,
//         fontSize: 16,
//       );
//     }
//   }
//
//   _startRecording() async {
//     print("object recording start clicked");
//     _markers.clear();
//     _mapPolyLines.clear();
//     _startTime = DateTime.now();
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     print(
//         'location on start clicked lat ${position.latitude} long ${position.longitude}');
//     setState(() {
//       _startPosition = Position(
//         latitude: position.latitude,
//         longitude: position.longitude,
//         timestamp: DateTime.now(),
//         speed: position.speed,
//         heading: position.heading,
//         accuracy: position.accuracy,
//         altitude: position.altitude,
//         speedAccuracy: position.speedAccuracy,
//       );
//       _mapController!
//           .animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//               target: LatLng(position.latitude, position.longitude), zoom: 15),
//         ),
//       )
//           .catchError((e) {
//         print('Error in animating map $e');
//       });
//     });
//
//     lastLat = _startPosition!.latitude;
//     lastLong = _startPosition!.longitude;
//     Marker startMarker = Marker(
//       markerId: MarkerId('$_startPosition'),
//       position: LatLng(
//         _startPosition!.latitude,
//         _startPosition!.longitude,
//       ),
//       infoWindow: InfoWindow(title: 'Start'),
//       icon: BitmapDescriptor.defaultMarker,
//     );
//     _markers.add(startMarker);
//     Fluttertoast.showToast(
//       msg: 'Recording Started',
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.black87,
//       textColor: Colors.white,
//       fontSize: 16,
//     );
//
//     await BackgroundLocation.setAndroidNotification(
//       title: "Infinity",
//       message: "Location tracking in progress",
//       icon: "@mipmap/ic_launcher",
//     );
//     BackgroundLocation.setAndroidConfiguration(1000);
//     await BackgroundLocation.startLocationService(distanceFilter: 5);
//     var box = await Hive.openBox(Connections.locations);
//     await box.deleteFromDisk();
//     box.add({'lat': _startPosition!.latitude, 'long': _startPosition!.longitude});
//     BackgroundLocation.getLocationUpdates((location) async {
//       print(
//           'background location later on count is lat ${location.latitude} long ${location.longitude}');
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//               target: LatLng(location.latitude!, location.longitude!), zoom: 15),
//         ),
//       );
//       if (lastLat != location.latitude || lastLong != location.longitude) {
//         lastLat = location.latitude!;
//         lastLong = location.longitude!;
//         box.add({'lat': location.latitude, 'long': location.longitude});
//         print(
//             'background location save is lat ${location.latitude} long ${location.longitude}');
//         print("object box values start ${box.length}");
//       }
//     });
//   }
//
//   _stopRecording() async {
//     await BackgroundLocation.stopLocationService();
//     lastLat = 0;
//     lastLong = 0;
//     Position endPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     Marker stopMarker = Marker(
//       markerId: MarkerId('$endPosition'),
//       position: LatLng(endPosition.latitude, endPosition.longitude),
//       infoWindow: InfoWindow(title: 'Stop'),
//       icon: _destIcon!,
//     );
//     _markers.add(stopMarker);
//     var box = await Hive.openBox(Connections.locations);
//     box.add({'lat': endPosition.latitude, 'long': endPosition.longitude});
//     print("object box values on stop ${box.length}");
//     _createPolyLines(endPosition);
//   }
//
//   _addRoute(Position endPosition, locations, distance) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       print('storing offline');
//       var recordBox = await Hive.openBox(Connections.records);
//       Map<String, dynamic> record = {
//         'start': {
//           'lat': _startPosition!.latitude,
//           'long': _startPosition!.longitude
//         },
//         'end': {'lat': endPosition.latitude, 'long': endPosition.longitude},
//         'path': locations,
//         'distance': distance,
//         'dateTime': DateTime.now().toString(),
//         'startTime': _startTime.toString(),
//         'endTime': _endTime.toString(),
//       };
//       recordBox.add(record);
//       Fluttertoast.showToast(
//         msg: 'Recording Saved Successfully',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black87,
//         textColor: Colors.white,
//         fontSize: 16,
//       );
//     } else {
//       print('storing server');
//       // Dialogs.showLoadingDialog(context, _keyLoader).then((_) {
//       //   if (mounted) {
//       //     Future.delayed(Duration(minutes: 1), () {
//       //       Navigator.of(context, rootNavigator: true).pop();
//       //     });
//       //   }
//       // });
//
//       ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
//         isDismissible: false,);
//       pr.style(message: 'Please wait...',
//         progressWidget: Center(child: CircularProgressIndicator()),);
//       pr.show();
//
//       List<String> addresses = await _getReverseGeocoding(
//           _startPosition!.latitude,
//           _startPosition!.longitude,
//           endPosition.latitude,
//           endPosition.longitude);
//       SharedPreferences _prefs = await SharedPreferences.getInstance();
//       var params = {
//         'userID': '${_prefs.getInt('UserID')}',
//         'start': '${addresses[0]}',
//         'end': '${addresses[1]}',
//         "startCoords": {
//           "lat": '${_startPosition!.latitude ?? ''}',
//           "lng": '${_startPosition!.longitude ?? ''}',
//         },
//         "endCoords": {
//           "lat": '${endPosition.latitude ?? ''}',
//           "lng": '${endPosition.longitude ?? ''}',
//         },
//         'distance': '$distance',
//         'unit': 'kms',
//         "path": locations ?? [],
//         "ID": 6,
//         "dateTime": DateTime.now().toString(),
//         "startTime": '${_startTime.toString()}',
//         'endTime': '${_endTime.toString()}',
//       };
//       var response = await http.post(Uri.parse(Connections.addRoute),
//           headers: {'Content-type': 'application/json'},
//           body: json.encode(params));
//       var result = json.decode(response.body);
//       pr.hide();
//       //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//
//       print('add route result $result');
//       if (result['status'] == true) {
//         Fluttertoast.showToast(
//           msg: 'Recording Saved Successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.black87,
//           textColor: Colors.white,
//           fontSize: 16,
//         );
//       } else {
//         Alerts.showAlert(
//             context, 'Failed to store record', 'Please try again later.');
//       }
//     }
//   }
//
//   _uploadOfflineRecords() async {
//     var box = await Hive.openBox(Connections.records);
//     print("object box open or close $box ${box.isOpen} ${box.length}");
//     for (int i = 0; i < box.length; i++) {
//       bool result = await _addOfflineRoute(box.getAt(i));
//       print('result stored is $result');
//     }
//     await box.deleteFromDisk();
//   }
//
//   Future<bool> _addOfflineRoute(box) async {
//     print(
//         "box values ${box['start']['lat']} ${box['start']['long']}  ${box['end']['lat']} ${box['end']['long']}");
//     List<String> addresses = await _getReverseGeocoding(box['start']['lat'],
//         box['start']['long'], box['end']['lat'], box['end']['long']);
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     print(
//         "List of address ${addresses.length} ${addresses[0]} ${addresses[1]} ${box['distance']} ${box['path']}");
//     var params = {
//       'userID': '${_prefs.getInt('UserID')}',
//       'start': '${addresses[0]}',
//       'end': '${addresses[1]}',
//       "startCoords": {
//         "lat": box['start']['lat'],
//         "lng": box['start']['long'],
//       },
//       "endCoords": {
//         "lat": box['end']['lat'],
//         "lng": box['end']['long'],
//       },
//       'distance': '${box['distance']}',
//       'unit': 'kms',
//       "path": box['path'],
//       "ID": 6,
//       "dateTime": box['dateTime'],
//       "startTime": box['startTime'],
//       'endTime': box['endTime'],
//     };
//     var response = await http.post(Uri.parse(Connections.addRoute),
//         headers: {'Content-type': 'application/json'},
//         body: json.encode(params));
//     var result = json.decode(response.body);
//     if (result['status'] == true) {
//       Fluttertoast.showToast(
//         msg: 'offline record saved successfully',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black87,
//         textColor: Colors.white,
//         fontSize: 16,
//       );
//     } else {
//       Fluttertoast.showToast(
//         msg: 'Failed to store offline record',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black87,
//         textColor: Colors.white,
//         fontSize: 16,
//       );
//     }
//     print("object response generated ${response.body}");
//     return result['status'] ?? false;
//   }
//
//   Future<String> _getSingleGeocoding(lat, long) async {
//     var response =
//     await http.get(Uri.parse(Connections.geocoding + '$lat,$long'));
//     var result = json.decode(response.body);
//     print("response single geocoding ${response.body}");
//     if (response.statusCode >= 200 && response.statusCode <= 299) {
//       return result['results'][0]['formatted_address'];
//     } else {
//       return 'Meeting Marked';
//     }
//   }
//
//   Future<List<String>> _getReverseGeocoding(
//       startLat, startLong, endLat, endLong) async {
//     String startAdd = 'Not Available';
//     String endAdd = 'Not Available';
//     var response1 = await http
//         .get(Uri.parse(Connections.geocoding + '$startLat,$startLong'));
//     var result1 = json.decode(response1.body);
//     if (response1.statusCode >= 200 && response1.statusCode <= 299) {
//       startAdd = result1['results'][0]['formatted_address'];
//     } else {
//       startAdd = 'Start Location';
//     }
//     var response2 =
//     await http.get(Uri.parse(Connections.geocoding + '$endLat,$endLong'));
//     var result2 = json.decode(response2.body);
//     if (response2.statusCode >= 200 && response2.statusCode <= 299) {
//       endAdd = result2['results'][0]['formatted_address'];
//     } else {
//       endAdd = 'End Location';
//     }
//     return [startAdd, endAdd];
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5), 'assets/dest.png')
//         .then((onValue) {
//       _destIcon = onValue;
//     });
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png')
//         .then((onValue) {
//       _markerIcon = onValue;
//     });
//     super.initState();
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen((event) {
//           if (event != ConnectivityResult.none) {
//             _uploadOfflineRecords();
//           }
//         });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getLocation();
//     });
//   }
//
//   @override
//   void dispose() {
//     _connectivitySubscription!.cancel();
//     _mapController!.dispose();
//     //Hive.close();
//     super.dispose();
//     disposeWatch();
//   }
//
//   @override
//   // ignore: must_call_super
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Align(
//             alignment: Alignment.center,
//             child: Text(
//               ' v1.0.4',
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//             )),
//         centerTitle: true,
//         elevation: 2,
//         title: Image.asset(
//           'assets/infinity.jpg',
//           height: 36,
//           fit: BoxFit.contain,
//         ),
//         actions: [
//           _logoutPopup(),
//         ],
//       ),
//       body: Stack(
//         children: [
//           _mapView(),
//           _timerView(),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: recordStarted
//                   ? SizedBox(
//                 width: double.infinity,
//                 child: CupertinoButton(
//                     color: Colors.blue,
//                     child: Text('Stop'),
//                     onPressed: () async {
//                       serviceEnabled =
//                       await Geolocator.isLocationServiceEnabled();
//                       if (!serviceEnabled!) {
//                         Alerts.showAlert(context, 'Location Disabled',
//                             'Please enable location service.');
//                         return;
//                       }
//                       permission = await Geolocator.checkPermission();
//                       if (permission ==
//                           LocationPermission.deniedForever) {
//                         Alerts.showAlertSettings(context, () {
//                           Geolocator.openLocationSettings();
//                         });
//                         return;
//                       }
//                       if (permission == LocationPermission.denied) {
//                         permission = await Geolocator.requestPermission();
//                         if (permission != LocationPermission.whileInUse &&
//                             permission != LocationPermission.always) {
//                           Alerts.showAlert(context, 'Permission Denied',
//                               'Please allow app to access location.');
//                           return;
//                         }
//                       }
//                       Alerts.showRecordStopAlert(context, () {
//                         setState(() {
//                           recordStarted = false;
//                         });
//                         _stopWatchTimer.onExecute
//                             .add(StopWatchExecute.stop);
//                         _stopRecording();
//                       });
//                     }),
//               )
//                   : SizedBox(
//                 width: double.infinity,
//                 child: CupertinoButton(
//                     color: Colors.blue,
//                     child: Text('Start'),
//                     onPressed: () async {
//                       serviceEnabled =
//                       await Geolocator.isLocationServiceEnabled();
//                       if (!serviceEnabled!) {
//                         Alerts.showAlert(context, 'Location Disabled',
//                             'Please enable location service.');
//                         return;
//                       }
//                       permission = await Geolocator.checkPermission();
//                       if (permission ==
//                           LocationPermission.deniedForever) {
//                         Alerts.showAlertSettings(context, () {
//                           Geolocator.openLocationSettings();
//                         });
//                         return;
//                       }
//                       if (permission == LocationPermission.denied) {
//                         permission = await Geolocator.requestPermission();
//                         if (permission != LocationPermission.whileInUse &&
//                             permission != LocationPermission.always) {
//                           Alerts.showAlert(context, 'Permission Denied',
//                               'Please allow app to access location.');
//                           return;
//                         }
//                       }
//                       setState(() {
//                         recordStarted = true;
//                       });
//                       _stopWatchTimer.onExecute
//                           .add(StopWatchExecute.reset);
//                       _stopWatchTimer.onExecute
//                           .add(StopWatchExecute.start);
//                       _startRecording();
//                     }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _timerView() {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 12, right: 12),
//         child: Align(
//           alignment: Alignment.topRight,
//           child: Column(
//             children: [
//               recordStarted
//                   ? StreamBuilder<int>(
//                   initialData: 0,
//                   stream: _stopWatchTimer.rawTime,
//                   builder: (c, s) {
//                     final value = s.data;
//                     final displayTime =
//                     StopWatchTimer.getDisplayTime(value!);
//                     return Container(
//                       width: 118,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(65),
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.red,
//                             radius: 10,
//                           ),
//                           //SizedBox(width: 6,),
//                           Text(
//                             displayTime.substring(
//                                 0, displayTime.length - 3),
//                             style: TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   })
//                   : SizedBox(),
//               SizedBox(
//                 height: 5,
//               ),
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.white, // background
//                   onPrimary: Colors.black87, // foreground
//                 ),
//                 icon: Icon(
//                   Icons.location_on_outlined,
//                   size: 30,
//                   color: Colors.red,
//                 ),
//                 label: Text(
//                   'Mark',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 onPressed: () {
//                   _addMark();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     // if (recordStarted) {
//     //   return SafeArea(
//     //     child: Padding(
//     //       padding: const EdgeInsets.only(top: 12, right: 12),
//     //       child: Align(
//     //         alignment: Alignment.topRight,
//     //         child: StreamBuilder<int>(initialData: 0,
//     //            stream: _stopWatchTimer.rawTime,
//     //            builder: (c, s) {
//     //              final value = s.data;
//     //              final displayTime = StopWatchTimer.getDisplayTime(value);
//     //              return Container(width: 118,
//     //                padding: const EdgeInsets.all(8),
//     //                decoration: BoxDecoration(
//     //                  color: Colors.grey[300],
//     //                  borderRadius: BorderRadius.circular(65),
//     //                ),
//     //                child: Row(
//     //                  children: [
//     //                    CircleAvatar(backgroundColor: Colors.red, radius: 10,),
//     //                    SizedBox(width: 6,),
//     //                    Text(displayTime.substring(0, displayTime.length - 3),
//     //                      style: TextStyle(fontSize: 18,),
//     //                    ),
//     //                  ],
//     //                ),
//     //              );
//     //            }),
//     //       ),
//     //     ),
//     //   );
//     // } else {
//     //   return SizedBox();
//     // }
//   }
//
//   Widget _mapView() {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
//       myLocationEnabled: true,
//       myLocationButtonEnabled: false,
//       mapType: MapType.normal,
//       zoomGesturesEnabled: true,
//       zoomControlsEnabled: false,
//       markers: _markers,
//       polylines: Set<Polyline>.of(_mapPolyLines.values),
//       onMapCreated: (GoogleMapController controller) {
//         _mapController = controller;
//       },
//     );
//   }
//
//   // Create the polyLines to show the route between two places
//   _createPolyLines(Position endPosition) async {
//     var points = await _createPoints();
//     print(
//         "points returned ${points.length} ${points[0]} ${points[1]} ${points[2]}");
//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.red,
//       points: points[0],
//       width: 3,
//     );
//     setState(() {
//       _mapPolyLines[id] = polyline;
//       _endTime = DateTime.now();
//     });
//     _addRoute(endPosition, points[1], points[2]);
//   }
//
//   Future<List> _createPoints() async {
//     double totalDistance = 0.0;
//     final List<LatLng> points = <LatLng>[];
//     List<Map<String, double>> polyPoints = [];
//     var box = await Hive.openBox(Connections.locations);
//     print("object length of box ${box.length}");
//
//     if (box.length > 0) {
//       dynamic item = box.getAt(0);
//       lastLat = item['lat'];
//       lastLong = item['long'];
//     }
//
//     for (int i = 0; i < box.length; i++) {
//       print("object length of box ${box.getAt(i)['lat']}\n");
//       points.add(LatLng(box.getAt(i)['lat'], box.getAt(i)['long']));
//       Map<String, double> p = {
//         'lat': box.getAt(i)['lat'],
//         'lng': box.getAt(i)['long']
//       };
//
//       double distance = _coordinateDistance(
//           lastLat,
//           lastLong,
//           box.getAt(box.length - 1 == i ? i : i + 1)['lat'],
//           box.getAt(box.length - 1 == i ? i : i + 1)['long']);
//
//       // double distance = _coordinateDistance(
//       //     box.getAt(i)['lat'],
//       //     box.getAt(i)['long'],
//       //     box.getAt(box.length - 1 == i ? i : i + 1)['lat'],
//       //     box.getAt(box.length - 1 == i ? i : i + 1)['long']);
//
//       if (distance < 1) {
//         totalDistance += distance;
//         lastLat = box.getAt(box.length - 1 == i ? i : i + 1)['lat'];
//         lastLong = box.getAt(box.length - 1 == i ? i : i + 1)['long'];
//         polyPoints.add(p);
//       }
//     }
//     print("poly points ${polyPoints.length}");
//     await box.deleteFromDisk();
//     return [points, polyPoints, totalDistance.toStringAsFixed(2)];
//   }
//
//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var a = 0.5 -
//         cos((lat2 - lat1) * p) / 2 +
//         cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }
//
//   Widget _logoutPopup() {
//     return PopupMenuButton<String>(
//       onSelected: (option) async {
//         SharedPreferences _prefs = await SharedPreferences.getInstance();
//         await _prefs.clear();
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//                 (Route<dynamic> route) => false);
//       },
//       itemBuilder: (BuildContext context) {
//         return {'Logout'}.map((String choice) {
//           return PopupMenuItem<String>(
//             value: choice,
//             child: Text(choice),
//           );
//         }).toList();
//       },
//     );
//   }
// }
