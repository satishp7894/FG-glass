import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/DCProject.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';
import 'package:flutter_fg_glass_app/ProjectsPieChart.dart';
import 'package:flutter_fg_glass_app/TIProject.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'OrdersPieChart.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;

class ProjectDetails extends StatefulWidget {
  @override
  ProjectDetailsState createState() => ProjectDetailsState();
}

class ProjectDetailsState extends State<ProjectDetails> {
  late final List<ProjectDetailData> items;

  Future<List<ProjectDetailData>> createLoginState(
      int custId, int projId) async {
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI//GetPIAgainstProjectAndCustomer?custID=$custId&projectID=$projId'));

    if (response.statusCode == 200) {
      print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      if (parsed == null) {
        String display = "Will be available soon";
        Text(
          "Will be available soon",
          textAlign: TextAlign.center,
        );
      }
      return parsed
          .map<ProjectDetailData>((json) => ProjectDetailData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to create album.');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
          //leadingWidth: 30,

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
                      child: Image.asset('assets/images/login head.png',
                          fit: BoxFit.fitWidth)))),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext ctx) => ProjectsPieChartPage()));
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 26.0,
                      color: Colors.white,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldkey.currentState?.openEndDrawer();
                          },
                        );
                      })),
            ],

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
                                builder: (BuildContext ctx) =>
                                    ProjectsFinal()));
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
                                builder: (BuildContext ctx) =>
                                    StatusTimeline()));
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
            physics: ScrollPhysics(),
            child: Column(children: <Widget>[
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => TIProject()));
                      },
                      color: const Color(0xff00bfe7),
                      textColor: Colors.white,
                      child: Text("Proforma Invoice",
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold)),
                    ),
                    RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => DCProject()));
                      },
                      color: const Color(0xff00bfe7),
                      textColor: Colors.white,
                      child: Text("Tax Invoice",
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<ProjectDetailData>>(
                  future: createLoginState(globals.custId, globals.projectId),
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.data != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data == null
                                ? Container(
                                    child: Text(
                                    "NA",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      color: const Color(0xff333333),
                                      height: 2.0625,
                                    ),
                                  ))
                                : snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                height: 220,
                                width: 350,
                                child: Pinned.fromPins(
                                    Pin(start: 16.0, end: 16.0),
                                    Pin(size: 180.0, start: 16.0),
                                    child: Stack(children: <Widget>[
                                      Pinned.fromPins(
                                        Pin(start: 0.0, end: 0.0),
                                        Pin(size: 190.0, start: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: const Color(0xfff3f3f3),
                                          ),
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 250.0, middle: 0.325),
                                        Pin(size: 19.0, start: 5.0),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'PI No :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].number}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 240.0, middle: 0.2911),
                                        Pin(size: 20.0, start: 35),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Date :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].date}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 240.0, middle: 0.2911),
                                        Pin(size: 20.0, start: 60),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Qty :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].quantity}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 240.0, middle: 0.2911),
                                        Pin(size: 20.0, start: 85),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Product :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].product}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 240.0, middle: 0.2911),
                                        Pin(size: 20.0, start: 110),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Project :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].project}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 240.0, middle: 0.2911),
                                        Pin(size: 20.0, start: 140),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'ASM :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].salesPerson}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 150.0, end: 10.0),
                                        Pin(size: 20.0, start: 35),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'SQM :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].sqm}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Pinned.fromPins(
                                        Pin(size: 150.0, end: 10.0),
                                        Pin(size: 20.0, start: 5),
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: const Color(0xff333333),
                                              height: 2.0625,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Version :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${snapshot.data[index].revNo}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff7e7e7e),
                                                ),
                                              ),
                                            ],
                                          ),
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ])),
                              );
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

class ProjectDetailData {
  final String number;
  final String date;
  final int quantity;
  final String product;
  final double sqm;
  final String owner;
  final String salesPerson;
  final String amount;
  final int revNo;
  final String project;

  ProjectDetailData({
    required this.number,
    required this.date,
    required this.quantity,
    required this.product,
    required this.sqm,
    required this.owner,
    required this.salesPerson,
    required this.amount,
    required this.revNo,
    required this.project,
  });

  factory ProjectDetailData.fromJson(Map<String, dynamic> data) {
    return ProjectDetailData(
      number: data['DisplayPINo'] as String,
      date: data['DisplayPIDate'] as String,
      quantity: data['Qty'] as int,
      product: data['Product'] ?? "",
      sqm: data['SQM'] as double,
      owner: data['Owner'] ?? " ",
      salesPerson: data['Salesperson'] ?? " ",
      amount: data['DisplayAmount'] ?? " ",
      revNo: data['RevisionNo'] as int,
      project: data['Project'] ?? "",
    );
  }
}

const String _svg_veh9ar =
    '<svg viewBox="0.0 0.0 24.6 29.4" ><path transform="translate(-1.97, 0.0)" d="M 23.36554908752441 3.186540603637695 L 22.53411674499512 3.186540603637695 L 22.53411674499512 2.219601631164551 C 22.53411674499512 0.9951886534690857 21.62772369384766 0 20.51233291625977 0 C 19.39618873596191 0 18.49054718017578 0.9951886534690857 18.49054718017578 2.219601631164551 L 18.49054718017578 3.185733795166016 L 16.4157600402832 3.185733795166016 L 16.4157600402832 2.219601631164551 C 16.4157600402832 0.9951886534690857 15.50936412811279 0 14.39397430419922 0 C 13.27858352661133 0 12.37218761444092 0.9951886534690857 12.37218761444092 2.219601631164551 L 12.37218761444092 3.185733795166016 L 10.29739665985107 3.185733795166016 L 10.29739665985107 2.219601631164551 C 10.29739665985107 0.9951886534690857 9.391000747680664 0 8.275611877441406 0 C 7.160222053527832 0 6.253824710845947 0.9951886534690857 6.253824710845947 2.219601631164551 L 6.253824710845947 3.185733795166016 L 5.192197322845459 3.185733795166016 C 3.418024063110352 3.185733795166016 1.974000215530396 4.724925994873047 1.974000215530396 6.616027355194092 L 1.974000215530396 25.98709487915039 C 1.974000215530396 27.87819480895996 3.418024063110352 29.41738891601562 5.192197322845459 29.41738891601562 L 23.36554527282715 29.41738891601562 C 25.14047813415527 29.41738891601562 26.58374214172363 27.87819480895996 26.58374214172363 25.98709487915039 L 26.58374214172363 6.616025924682617 C 26.58374214172363 4.725733280181885 25.13972282409668 3.186540603637695 23.36554908752441 3.186540603637695 Z M 19.62638092041016 2.219601631164551 C 19.62638092041016 1.663490414619446 20.02392196655273 1.210691809654236 20.51233291625977 1.210691809654236 C 21.00149917602539 1.210691809654236 21.39828109741211 1.663490414619446 21.39828109741211 2.219601631164551 L 21.39828109741211 6.171299457550049 C 21.39828109741211 6.727410793304443 21.00149917602539 7.180209159851074 20.51233291625977 7.180209159851074 C 20.02392196655273 7.180209159851074 19.62638092041016 6.727410793304443 19.62638092041016 6.171299457550049 L 19.62638092041016 2.219601631164551 Z M 13.50802135467529 2.219601631164551 C 13.50802135467529 1.663490414619446 13.9055643081665 1.210691809654236 14.39397239685059 1.210691809654236 C 14.88238143920898 1.210691809654236 15.27992343902588 1.663490414619446 15.27992343902588 2.219601631164551 L 15.27992343902588 6.171299457550049 C 15.27992343902588 6.727410793304443 14.88238143920898 7.180209159851074 14.39397239685059 7.180209159851074 C 13.9055643081665 7.180209159851074 13.50802135467529 6.727410793304443 13.50802135467529 6.171299457550049 L 13.50802135467529 2.219601631164551 Z M 7.388902187347412 2.219601631164551 C 7.388902187347412 1.663490414619446 7.786444187164307 1.210691809654236 8.274853706359863 1.210691809654236 C 8.763262748718262 1.210691809654236 9.16080379486084 1.663490414619446 9.16080379486084 2.219601631164551 L 9.16080379486084 6.171299457550049 C 9.16080379486084 6.727410793304443 8.763262748718262 7.180209159851074 8.274853706359863 7.180209159851074 C 7.786444187164307 7.180209159851074 7.388902187347412 6.727410793304443 7.388902187347412 6.171299457550049 L 7.388902187347412 2.219601631164551 Z M 24.6906909942627 25.9879035949707 C 24.6906909942627 26.76678466796875 24.09626960754395 27.40037727355957 23.36554908752441 27.40037727355957 L 5.192198276519775 27.40037727355957 C 4.461477756500244 27.40037727355957 3.867058277130127 26.76678466796875 3.867058277130127 25.9879035949707 L 3.867058277130127 8.23109245300293 L 24.6906909942627 8.23109245300293 L 24.6906909942627 25.9879035949707 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ecwlvx =
    '<svg viewBox="364.8 330.5 14.5 6.1" ><path transform="translate(-874.23, 83.5)" d="M 1238.986328125 246.9999694824219 L 1246.89208984375 253.1191101074219 L 1253.48046875 246.9999694824219" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
