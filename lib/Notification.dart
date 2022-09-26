import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';
import 'package:http/http.dart';
import 'globalVariables.dart' as globals;

class NotificationData extends StatefulWidget {
  @override
  NotificationState createState() => new NotificationState();
}

Future<List<NotificationRes>> createLoginState(int custId) async {
  final response = await post(Uri.parse(
      'https://fgapi.digidisruptors.in/api/CustomerAPI/GetCustwiseTodaysNotification?custID=$custId'));
  print('https://fgapi.digidisruptors.in/api/CustomerAPI/GetCustwiseTodaysNotification?custID=$custId');

  if (response.statusCode == 200) {
    print(response.body);

   final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<NotificationRes>((json) => NotificationRes.fromJson(json))
        .toList();

    //final data = json.decode(response.body);
   // print (data[0].Count);
  } else {
    throw Exception('Failed to create album.');
  }
}
class NotificationState extends State<NotificationData> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 2.0,
        backgroundColor: const Color(0xff00bfe7),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0xff00bfe7),
                    const Color(0xff27a9e1)
                  ])),
        ),
        //  centerTitle: true,
        leadingWidth: 30,

        title: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 15),
            child: Container(
                height: 100,
                width: 120,
                child: Image.asset('assets/images/login head.png',
                    fit: BoxFit.fitWidth))),
        /* actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: GestureDetector(
                    *//* onTap: () async{
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
                    },*//*
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.white,
                    ),
                  )),
            ]*/
      ),

      body: Container(
        margin: EdgeInsets.only(top: 24,left: 24,right: 24),

      child: FutureBuilder(
        future: createLoginState(globals.custId),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data != null
              ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                child:Text(
                        " ${snapshot.data[index].name}",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff333333),
                          height: 1,
                        ),
                )),
                        Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                        " ${snapshot.data[index].count}",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,

                          color: const Color(0xff333333),
                          height: 1,
                        ),
                      ),
                        )]);})
              : Center(
              child: Container());

        },
      ),
    ));
  }
}



class NotificationRes {
  final String name;
  final int count;

  NotificationRes({
    required this.name,
    required this.count,

  });

  factory NotificationRes.fromJson(Map<String, dynamic> data) {
    return NotificationRes(
      name: data['Name'] as String,
      count: data['Count'] as int,

    );
  }
}
