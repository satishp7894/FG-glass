import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/record_bloc.dart';
import '../../login.dart';
import '../../models/travel_record.dart';
import '../../utils/apptheme.dart';
import 'map_record_page.dart';

class TravelRecordsPage extends StatefulWidget {
  @override
  _TravelRecordsPageState createState() => _TravelRecordsPageState();
}

class _TravelRecordsPageState extends State<TravelRecordsPage> {
  final recordBloc = RecordBloc();
  List<String> _criterias = ['Today', 'Yesterday', 'Week', 'Month', 'All'];
  String selectedCriteria = 'Today';

  @override
  void initState() {
    super.initState();
    recordBloc.fetchRecords(selectedCriteria);
  }

  @override
  void dispose() {
    recordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(alignment: Alignment.center,
            child: Text(' v1.0.6', style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500),)),
        centerTitle: true, elevation: 2,
        title: Text('Records'),
        actions: [
          _logoutPopup(),
        ],
      ),
      body: Column(
        children: [
          _criteriaView(),
          Expanded(
            child: StreamBuilder<List<TravelRecord>>(
              stream: recordBloc.recordStream,
              builder: (c, s) {
                if (s.connectionState != ConnectionState.active) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),),
                  );
                } else if (s.hasError || s.data!.isEmpty) {
                  return Center(
                    child: Text('No Records', style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w600),),);
                } else {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: s.data!.length,
                    itemBuilder: (c, i) {
                      return _recordItem(s.data![i]);
                    });
                }
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _criteriaView() {
    return Container(height: 45,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 10, top: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _criterias.length,
        itemBuilder: (c, i) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: selectedCriteria == _criterias[i] ?
              Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('${_criterias[i]}', style: TextStyle(fontSize: 18,
                      color: Colors.black87, fontWeight: FontWeight.w700),),
                  SizedBox(height: 4,),
                  Container(height: 5, width: 5,
                    decoration: BoxDecoration(color: Colors.black87,
                      shape: BoxShape.circle,),
                  ),
                ],
              ) : Text('${_criterias[i]}', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600, color: Colors.grey),),
            ),
            onTap: () {
              setState(() {
                selectedCriteria = _criterias[i];
              });
              recordBloc.fetchRecords(selectedCriteria);
            },
          );
        }),
    );
  }

  Widget _recordItem(TravelRecord record) {
    DateTime date = record.dateTime;
    print("object ptah details ${record.path.length}");
    if (record.path.isEmpty) {
      return GestureDetector(
        child: Container(height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${date.day}-${date.month}-${date.year}  ${date.hour}:${date.minute}:${date.second}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                ],
              ),
              Divider(color: Colors.grey,),
              SizedBox(height: 5,),
              Row(
                children: [
                  Image.asset('assets/images/marker.png', height: 35, width: 35, fit: BoxFit.contain,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marked Location', style: TextStyle(fontSize: 12,
                            color: Colors.grey),),
                        Text('${record.start}', maxLines: 2, style: TextStyle(fontSize: 16,),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) =>
              MapRecordPage(mark: record.startCoords, first: Locations(), mapRecord: [], last: Locations(),)));
        },
      );
    } else {
      return GestureDetector(
        child: Container(height: 220,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(
              color: Colors.black87.withOpacity(.08),
              blurRadius: 16, offset: Offset(6, 6),
            )],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${date.day}-${date.month}-${date.year}\n${date.hour}:${date.minute}:${date.second}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  Text('${record.distance} ${record.unit}', style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w600),),
                ],
              ),
              Divider(color: Colors.grey,),
              Row(
                children: [
                  Icon(Icons.directions_run, size: 26,
                    color: Colors.red,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FROM', style: TextStyle(fontSize: 12,
                            color: Colors.grey),),
                        Text('${record.start}', maxLines: 2, style: TextStyle(fontSize: 16,),),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey,),
              Row(
                children: [
                  Icon(Icons.outlined_flag, size: 26,
                    color: Colors.deepPurple,),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TO', style: TextStyle(fontSize: 12,
                            color: Colors.grey),),
                        Text('${record.end}', maxLines: 2, style: TextStyle(fontSize: 16,),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          // print("objectlist of path ${record.path} ${record.path.length} ${record.path.first.lng}");

          for (int i=0; i<record.path.length; i++) {

            // print("objectlist of path $i ---- ${record.path[i].lat}");

          }
          Navigator.push(context, MaterialPageRoute(builder: (c) =>
              MapRecordPage(mapRecord: record.path,first:record.startCoords, last:record.endCoords, mark: Locations(),)));
        },
      );
    }

  }

  // Widget _recordListItem(TravelRecord record) {
  //   DateTime date = record.dateTime;
  //   return GestureDetector(
  //     child: Card(elevation: 2.5,
  //       margin: const EdgeInsets.all(8),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('${date.day}-${date.month}-${date.year}  ${date.hour}:${date.minute}:${date.second}',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
  //             SizedBox(height: 12,),
  //             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   children: [
  //                     SizedBox(width: 100,
  //                       child: Text('${record.start}', style: TextStyle(fontSize: 16,
  //                           color: Colors.grey), textAlign: TextAlign.center, maxLines: null,)),
  //                     SizedBox(height: 5,),
  //                     Icon(Icons.directions_run, size: 35,
  //                       color: Colors.red,),
  //                   ],
  //                 ),
  //                 Text('${record.distance} ${record.unit}', style: TextStyle(fontSize: 18,
  //                     fontWeight: FontWeight.w600),),
  //                 Column(
  //                   children: [
  //                     SizedBox(width: 100,
  //                       child: Text('${record.end}', style: TextStyle(fontSize: 16,
  //                           color: Colors.grey), textAlign: TextAlign.center, maxLines: null,)),
  //                     SizedBox(height: 5,),
  //                     Icon(Icons.outlined_flag, size: 35,
  //                       color: Colors.deepPurple,),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Divider(thickness: 3, color: Colors.deepPurple,),
  //           ],
  //         ),
  //       ),
  //     ),
  //     onTap: () {
  //       Navigator.push(context, MaterialPageRoute(builder: (c) =>
  //           MapRecordPage(mapRecord: record.path,)));
  //     },
  //   );
  // }

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


// class RecordsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, elevation: 2,
//         title: Text('Records'),
//       ),
//       body: FutureBuilder(
//         future: Hive.openBox(Connections.records),
//         builder: (c, s) {
//           if (s.connectionState != ConnectionState.done) {
//             return Center(
//               child: CircularProgressIndicator(strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//               ),
//             );
//           } else {
//             if (s.hasError || s.data.isEmpty) {
//               return Center(
//                 child: Text('No Records', style: TextStyle(fontSize: 20,
//                   fontWeight: FontWeight.w600),),
//               );
//             } else {
//               return ValueListenableBuilder(
//                 valueListenable: Hive.box(Connections.records).listenable(),
//                 builder: (context, box, widget) {
//                   return ListView.builder(
//                     itemCount: box.length,
//                     itemBuilder: (c, i) {
//                       var data = box.getAt(i);
//                       return _recordListItem(context, data);
//                     });
//                 });
//             }
//           }
//         }
//       ),
//     );
//   }
//
//   Widget _recordListItem(context, data) {
//     DateTime date = data['date'];
//     return GestureDetector(
//       child: Card(elevation: 2.5,
//         margin: const EdgeInsets.all(8),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('${date.day}-${date.month}-${date.year}  ${date.hour}:${date.minute}:${date.second}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
//               SizedBox(height: 8,),
//               Text('Duration ${data['duration'].substring(0, data['duration'].indexOf('.'))}',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[600]),),
//               SizedBox(height: 12,),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(Icons.directions_run, size: 35,
//                     color: Colors.red,),
//                   Text('${data['distance']} km', style: TextStyle(fontSize: 18,
//                       fontWeight: FontWeight.w600),),
//                   Icon(Icons.outlined_flag, size: 35,
//                     color: Colors.deepPurple,),
//                 ],
//               ),
//               Divider(thickness: 3, color: Colors.deepPurple,),
//             ],
//           ),
//         ),
//       ),
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (c) =>
//             MapRecordPage(mapRecord: data,)));
//       },
//     );
//   }
//
// }
