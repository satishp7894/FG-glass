import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';
import 'package:flutter_fg_glass_app/Orders.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;

class OrderStatus extends StatefulWidget {
  @override
  OrderStatusState createState() => OrderStatusState();
}

class OrderStatusState extends State<OrderStatus> {
  late final List<OrderStatusData> items;
  String woNo = "WO21-Jul-2048";

  bool isFirst = false;

  Future<List<OrderStatusData>> createLoginState(var woNo) async {
    print(globals.woNo);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final custid = prefs.getInt('CustID') ?? '';
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetStatusofOrder?wono=$woNo'));

    print('https://fgapi.digidisruptors.in/api/CustomerAPI/GetStatusofOrder?wono=$woNo');

    if (response.body.length > 0) {
      print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<OrderStatusData>((json) => OrderStatusData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to create album.');
    }
  }

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
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                  height: 100,
                  width: 120,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext ctx) => Dashboard()));
                    },
    child:Image.asset('assets/images/login head.png',
                      fit: BoxFit.fitWidth)))),
          /* actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: GestureDetector(
                    */ /* onTap: () async{
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
                    },*/ /*
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.white,
                    ),
                  )),
            ]*/
        ),

        endDrawer: Container(
            width: MediaQuery.of(context).size.width * 0.5, //<-- SEE HERE
            child:Drawer(
              backgroundColor: Color(0xff0b8bc2),
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  ListTile(

                      contentPadding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                      trailing: Icon(
                        Icons.menu,
                        color: Colors.white,
                      )

                  ),


                  ListTile(

                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset('assets/images/OrdersNav.png', height: 50, width: 50,),
                      title: const Text('Open \nOrders',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => Orders()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset('assets/images/DC.png', height: 50, width: 50,),
                      title: const Text('Delivery \nChallan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => deliveryChallan()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/TI.png', height: 50, width: 50,),
                      title: const Text('Tax \nInvoice',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => TaxInvoiceFinal()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ProformaNav.png', height: 50, width: 50,),
                      title: const Text('Proforma',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => PIDate()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ProjectsNav.png', height: 50, width: 50,),
                      title: const Text('Projects',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => ProjectsFinal()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ST.png', height: 50, width: 50,),
                      title: const Text('Status \nTimeline',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => StatusTimeline()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ProjectsNav.png', height: 50, width: 50,),
                      title: const Text('Delivery \nSchedule',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => DeliverySchedule()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ProformaNav.png', height: 50, width: 50,),
                      title: const Text('Quality \nComplaint',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => QualityComplaint()));
                      }
                  ),
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                      leading: Image.asset('assets/images/ST.png', height: 50, width: 50,),
                      title: const Text('Issue \nRaised',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => IssueRaised()));
                      }
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 60,horizontal: 48),
                    leading: Image.asset('assets/images/logout.png', height: 20, width: 20,),
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800)),

                  ),

                ],
              ),
            )),
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: <Widget>[
              FutureBuilder<List<OrderStatusData>>(

                  future: createLoginState(globals.woNo),
                  builder: (context, AsyncSnapshot snapshot) {
                    /*if (snapshot.data?.isEmpty?? true) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children:[

                          Container(
                           margin: EdgeInsets.only(top: 100),
                              child: Text(
                                "NA",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 20,
                                  color:
                                  const Color(0xff333333),
                                  fontWeight: FontWeight.w700,
                                ),
                              )

                          )]);

                    }*/
                    return snapshot.data != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                  width: 400,
                                  height: 80,
                                  child: TimelineTile(
                                    axis: TimelineAxis.vertical,
                                    alignment: TimelineAlign.manual,
                                    lineXY: 0.3,
                                    isFirst: isFirst,
                                    indicatorStyle: const IndicatorStyle(
                                      width: 15,
                                      color: Colors.blue,
                                    ),
                                    beforeLineStyle: const LineStyle(
                                      color: Colors.blue,
                                      thickness: 6,
                                    ),
                                    endChild: Container(
                                      height: 100,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 4.0),

                                      //color: Colors.lightGreenAccent,
                                      child: Card(
                                          color: const Color(0xfff3f3f3),
                                          child: Column(children: <Widget>[
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 8.0),
                                              child: Text(
                                                "${snapshot.data[index].status}",
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xff333333),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                'Days Elapsed : ${snapshot.data[index].dayElapsed}',
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 12,
                                                  color:
                                                      const Color(0xff0f91e1),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ])),
                                    ),
                                    startChild: Container(
                                      // color: Colors.amberAccent,
                                      child: Text(
                                        "${snapshot.data[index].date}",
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ));
                            })
                        : Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: 0.8,
                          ));
                  })
            ])));
  }
}

class OrderStatusData {
  final String date;
  final String status;
  final String dayElapsed;

  OrderStatusData({
    required this.date,
    required this.status,
    required this.dayElapsed,
  });

  factory OrderStatusData.fromJson(Map<String, dynamic> data) {
    return OrderStatusData(
      date: data['DisplayDate'] as String,
      status: data['Status'] as String,
      dayElapsed: data['DayElaped'] as String,
    );
  }
}
