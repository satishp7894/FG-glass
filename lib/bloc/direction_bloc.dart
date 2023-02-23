import 'dart:async';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/directions_model.dart';

class DirectionBloc {

  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  static const String _mapprUrl =
      'https://maps.flightmap.io/api/directions?';

  static const String _roadsUrl =
      'https://roads.googleapis.com/v1/snapToRoads?';

  static const String _apiKey =
      '4722e550-5e4f-11ed-8a6b-ddd75675da84';

  static const String _tripUrl =
      'http://router.project-osrm.org/trip/v1/driving/';
  static const String _path = "20.359246,72.919903;20.359246,72.919903;20.359246,72.919904;20.359246,72.919904;20.359246,72.919904;20.359246,72.919904;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359246,72.919907;20.359246,72.919907;20.359245,72.919906;20.359245,72.919906;20.359246,72.919906;20.359246,72.919906;20.359247,72.919906;20.359247,72.919906;20.359246,72.919905;20.359246,72.919905;20.359245,72.919906;20.359245,72.919906;20.359245,72.919904;20.359245,72.919904;20.359244,72.919905;20.359244,72.919905;20.359244,72.919907;20.359244,72.919907;20.359246,72.919906;20.359246,72.919906;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359245,72.919904;20.359245,72.919904;20.359251,72.919901;20.359251,72.919901;20.35925,72.919904;20.35925,72.919904;20.359247,72.919904;20.359247,72.919904;20.359248,72.919906;20.359248,72.919906;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359245,72.919905;20.359244,72.919906;20.359244,72.919906?";

  static const List<LatLng> routesList = [LatLng(20.365999, 72.92345), LatLng(20.365984, 72.923442), LatLng(20.365984, 72.923442), LatLng(20.365955, 72.923434), LatLng(20.365955, 72.923434), LatLng(20.36595, 72.923432), LatLng(20.36595, 72.923432), LatLng(20.365948, 72.923432), LatLng(20.365948, 72.923432), LatLng(20.365946, 72.923431), LatLng(20.365946, 72.923431), LatLng(20.365945, 72.923431), LatLng(20.365945, 72.923431), LatLng(20.365944, 72.923431), LatLng(20.365944, 72.923431), LatLng(20.365946, 72.923434), LatLng(20.365946, 72.923434), LatLng(20.365946, 72.923435), LatLng(20.365946, 72.923435), LatLng(20.365944, 72.923437), LatLng(20.365944, 72.923437), LatLng(20.365943, 72.923437), LatLng(20.365943, 72.923437), LatLng(20.365943, 72.923437), LatLng(20.365943, 72.923437), LatLng(20.365943, 72.923436), LatLng(20.365943, 72.923436), LatLng(20.365943, 72.923436), LatLng(20.365943, 72.923436), LatLng(20.365948, 72.923434), LatLng(20.365948, 72.923434), LatLng(20.365952, 72.923432), LatLng(20.365952, 72.923432)];

  final Dio _dio;

  DirectionBloc({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    required LatLng? origin,
    required LatLng? destination,
    required String? waypoints,
  }) async {


    // Direction Api
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin!.latitude},${origin.longitude}',
        'destination': '${destination!.latitude},${destination.longitude}',
        // 'routes' : '[{20.6039609,72.9337587},{20.384600,72.858299},{20.523039, 72.959358},{20.365637, 72.923499}]',
        // 'alternatives' : true,
        // 'waypoints' : '20.6039609,72.9337587|20.384600,72.858299|',
        // 'mode' : 'walking',
        // 'waypoints' : waypoints,
        'key': "AIzaSyCkNrbAXPXJ1-PYYSPY5sSCUG_mF4BrXog",
      },
    );


    //
    // // Roads Api
    // final response = await _dio.get(
    //   _roadsUrl,
    //   queryParameters: {
    //     // 'path' : '20.6039609,72.9337587|20.365637, 72.923499|20.365984, 72.923442|20.365984, 72.923442|20.6039609,72.9337587|20.365637, 72.923499|20.365984, 72.923442|20.6039609,72.9337587',
    //     'path' : waypoints,
    //     'interpolate' : true,
    //     'key': "AIzaSyCkNrbAXPXJ1-PYYSPY5sSCUG_mF4BrXog",
    //   },
    // );


    // // trip Api
    // final response = await _dio.get(
    //   "http://router.project-osrm.org/trip/v1/driving/20.6039609,72.9337587;20.365637,72.923499?source=first&destination=last",
    //   // queryParameters: {
    //   //   'overview' : true,
    //   // },
    // );

    // // Mappr Api
    // final response = await _dio.get(
    //   _mapprUrl,
    //   queryParameters: {
    //     'fm_token' : _apiKey,
    //     'points' : waypoints,
    //     'driving_mode' : "car",
    //     // 'waypoints' : waypoints,
    //   },
    // );



    // 'destination': '${destination.latitude},${destination.longitude}',
    // Check if response is successful
    print("response   ----${response.data}");
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }else{
      print("${response.data.toString()}");
      return Directions.fromMap(response.data);
    }
    // return null;
  }

}