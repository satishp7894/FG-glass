import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/Dash1.dart';
import 'package:flutter_fg_glass_app/Dash2Carou1.dart';
import 'package:flutter_fg_glass_app/Dash2Carou2.dart';
import 'package:flutter_fg_glass_app/Dash3.dart';
import 'package:flutter_fg_glass_app/Dash31.dart';
import 'package:flutter_fg_glass_app/Dash5.dart';
import 'package:flutter_fg_glass_app/Dash6Carou1.dart';
import 'package:flutter_fg_glass_app/Dash6Carou2.dart';
import 'package:flutter_fg_glass_app/Dash6Carou3.dart';
import 'package:flutter_fg_glass_app/DeliveryChallanFinal.dart';
import 'package:flutter_fg_glass_app/Deliveryschedule.dart';
import 'package:flutter_fg_glass_app/IssueRaised.dart';
import 'package:flutter_fg_glass_app/Orders.dart';
import 'package:flutter_fg_glass_app/PIDate.dart';
import 'package:flutter_fg_glass_app/ProjectsFinal.dart';
import 'package:flutter_fg_glass_app/QualityComplaint.dart';
import 'package:flutter_fg_glass_app/StatusTimeline.dart';
import 'package:flutter_fg_glass_app/TaxInvoiceFinal.dart';
import 'package:http/http.dart';

import 'globalVariables.dart' as globals;

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

Future<Product> fetchAlbum(int custId, int projectId) async {
  final response = await post(Uri.parse(
      'https://fgapi.digidisruptors.in/api/CustomerAPI/GetTIAgainstProjectAndCustomer?custID=$custId&projectID=$projectId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Product.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
                height: 100,
                width: 120,
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext ctx) => Dashboard()));
                    },
                    child: Image.asset('assets/images/Dashlogo.png',
                        fit: BoxFit.fitWidth)))),
        backgroundColor: const Color(0xfff3f3f3),
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.5, //<-- SEE HERE
          child: Drawer(
            backgroundColor: Color(0xff0b8bc2),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                    trailing: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/OrdersNav.png',
                      height: 50,
                      width: 50,
                    ),
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
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/DC.png',
                      height: 50,
                      width: 50,
                    ),
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
                              builder: (BuildContext ctx) =>
                                  deliveryChallan()));
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/TI.png',
                      height: 50,
                      width: 50,
                    ),
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
                              builder: (BuildContext ctx) =>
                                  TaxInvoiceFinal()));
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ProformaNav.png',
                      height: 50,
                      width: 50,
                    ),
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
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ProjectsNav.png',
                      height: 50,
                      width: 50,
                    ),
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
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ST.png',
                      height: 50,
                      width: 50,
                    ),
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
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ProjectsNav.png',
                      height: 50,
                      width: 50,
                    ),
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
                              builder: (BuildContext ctx) =>
                                  DeliverySchedule()));
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ProformaNav.png',
                      height: 50,
                      width: 50,
                    ),
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
                              builder: (BuildContext ctx) =>
                                  QualityComplaint()));
                    }),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    leading: Image.asset(
                      'assets/images/ST.png',
                      height: 50,
                      width: 50,
                    ),
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
                    }),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 60, horizontal: 48),
                  leading: Image.asset(
                    'assets/images/logout.png',
                    height: 20,
                    width: 20,
                  ),
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
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 80,
                width: 400,
                child: Dash1(),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash2Carou1(),
                  ),
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Dash2Caro2(),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 270,
                width: 350,
                child: Dash3(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 150,
                width: 350,
                child: Dash31(),
              ),
              /*Container(
                height: 30,
               width: 400,
               margin: EdgeInsets.only(left: 15, top: 30),
               child: Text(
                  "Let's get social",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w600,
                    height: 1.2222222222222223,
                  ),
                  textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash4Carou1(),
                  ),
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash4Carou2(),
                  ),
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash4Carou3(),
                  ),
                ]),
              ),*/

              Container(
                height: 30,
                width: 400,
                margin: EdgeInsets.only(left: 15, top: 30),
                child: Text(
                  "Get the perfect glass",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w600,
                    height: 1.2222222222222223,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 150,
                width: 400,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Dash5(),
              ),
              Container(
                height: 30,
                width: 400,
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  "Projects : we've helped bring to life",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w600,
                    height: 1.2222222222222223,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash6Carou1(),
                  ),
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash6Carou2(),
                  ),
                  Container(
                    height: 150,
                    width: 350,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Dash6Carou3(),
                  ),
                ]),
              ),
            ],
          )),
      /* Container(
                  child: XDBaba(),
              )*/
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      //Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => Dashboard()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Simple Alert"),
    content: FutureBuilder(
      future: fetchAlbum(globals.custId, globals.projectId),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data != null
            ? Container(
                height: 50,
                width: 350,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total Amount ",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff333333),
                          height: 1,
                        ),
                      ),
                      Text(
                        '${snapshot.data!.totalAmount}',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff333333),
                          height: 1,
                        ),
                      ),
                    ]),
              )
            : Center(child: Container());
      },
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Product {
  final String totalAmount;

  // final List<ProjectDetailData> results;

  Product({required this.totalAmount});

  factory Product.fromJson(Map<String, dynamic> data) {
    var list = data['taxInvoices'] as List;
    //List<ProjectDetailData> resultList =
    //list.map((e) => ProjectDetailData.fromJson(e)).toList();
    return Product(
      totalAmount: data['TotalAmount'] as String,
      //results: resultList,
    );
  }
}
