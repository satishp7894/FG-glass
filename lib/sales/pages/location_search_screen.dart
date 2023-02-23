import 'package:flutter/material.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/widget/search_widget.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({ Key? key}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Location"),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchLocation(
              apiKey: "AIzaSyCkNrbAXPXJ1-PYYSPY5sSCUG_mF4BrXog",
              onSelected: (Place place) async {
                Navigator.pop(context,place);
    },
    ),
        ),
      ),
    );
  }
}
