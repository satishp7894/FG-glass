import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/travel_record.dart';
import '../utils/connections.dart';

class RecordBloc {

  final _recordsController = StreamController<List<TravelRecord>>.broadcast();
  Stream<List<TravelRecord>> get recordStream => _recordsController.stream;

  fetchRecords(String criteria) async {
    try {
      final results = await _getTravelRecords(criteria);
      _recordsController.sink.add(results);
    } on Exception catch (e) {
      _recordsController.addError('Something went wrong ${e.toString()}');
    }
  }

  Future<List<TravelRecord>> _getTravelRecords(String criteria) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // print("travelRoute URL =================  "+"${Connections.travelRoute}${_prefs.getInt('id')}&Criteria=$criteria");
    //
    // var response = await http.post(Uri.parse(Connections.travelRoute + '${_prefs.getInt('id')}&Criteria=$criteria'));


    print("travelRoute URL =================  "+"${Connections.travelRoute}2&Criteria=$criteria");

    var response = await http.post(Uri.parse(Connections.travelRoute + '2&Criteria=$criteria'));
    var result = json.decode(response.body);

    // print('result   === ${result.toString()}');
    // log(reallyReallyLongText);
    // printWrapped("Your very long string ...");
    // debugPrint('result   === ${result.toString()}', wrapWidth: 1024);
    List<TravelRecord> _records = [];
    if (result['response']['status'] == true) {
      _records = (result['travel'] as List).map<TravelRecord>((json) {
       return TravelRecord.fromJson(json);
      }
          ).toList();
    }

    // print("object routes bloc ${_prefs.getInt('id')} $criteria $_records ${result['travel'][0]} ");
    return _records;
  }

  dispose() {
    _recordsController.close();
  }

}