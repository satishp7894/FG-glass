import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/OrderStatus.dart';
import 'package:flutter_fg_glass_app/OrdersPieChart.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'Dashboard.dart';
import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;

class Orders extends StatefulWidget {
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders> {
  var date;
  var displayDate;
  late final List<OrderData> items;
  late Future<List<OrderDateData>> dateSorting;
  late String seldate = "11-Aug-2021";
  String date2 = "04-Aug-2021";

//  int custId = 19;
  // int custId2 = 33;
  int _selectedIndex = 0;
  late String type = "next";

  late String month = "";
  late int year = 0;

  String updatedDt = " ";

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  //late final custid ;
  Future<List<OrderData>> createLoginState(String date, int custId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final custid = prefs.getInt('CustID') ?? '';
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetOrderofGivenDate?orderDate=$date&custID=$custId'));

    if (response.statusCode == 200) {
      print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<OrderData>((json) => OrderData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<List<OrderDateData>> selectOrderDate(
      String date, int custId, String type) async {
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetActiveDatesForOrders?orderDate=$date&custID=$custId&type=$type'));

    if (response.statusCode == 200) {
      print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<OrderDateData>((json) => OrderDateData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to create album.');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      DateTime currentDate = DateTime.now();
      var newFormat = DateFormat("dd-MMM-yyyy");
      var monthFormat = DateFormat("MMM");
      String strCurrentDate = newFormat.format(currentDate);

      dateSorting = selectOrderDate(strCurrentDate, globals.custId, "previous");
      year = currentDate.year;
      month = monthFormat.format(currentDate);
      _selectedIndex = currentDate.day;

      seldate = strCurrentDate; // "11-Aug-2021";
      // date2 = "04-Aug-2021";
    });
  }

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
                              builder: (BuildContext ctx) => OrdersPieChartPage()));
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
            ]),
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
        resizeToAvoidBottomInset: false,
        body: Column(children: <Widget>[
          Container(
              height: 150,
              width: 400,
              color: const Color(0xfff3f3f3),
              child: Column(children: <Widget>[
                Container(
                    height: 93,
                    width: 375,
                    child: Row(children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectOrderDate(
                                seldate, globals.custId, "previous");
                            date2 = seldate;
                            type = "previous";
                          });
                        },
                        child: Container(
                          height: 15,
                          width: 5,
                          margin: EdgeInsets.only(right: 10, top: 5, left: 5),
                          child: Pinned.fromPins(
                            Pin(size: 6, start: 0.0),
                            Pin(size: 15.0, middle: 0.4302),
                            child: SvgPicture.string(
                              _svg_dwdtau,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<OrderDateData>>(
                            future:
                                selectOrderDate(date2, globals.custId, type),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data?.isEmpty ?? true) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Text(
                                        "NA",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 20,
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ))
                                    ]);
                              }
                              return snapshot.data != null
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      /* shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),*/
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, int index) {
                                        date = DateTime.parse(
                                            "${snapshot.data[index].orderDate}");
                                        var formattedDate =
                                            "${date.day}-${date.month}-${date.year}";

                                        return Container(
                                            height: 90,
                                            width: 65,
                                            margin: EdgeInsets.only(),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 5.0),
                                            child: Stack(
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 16.0, end: 0.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _onSelected(index);

                                                        DateTime dateTime =
                                                            DateTime.parse(
                                                                snapshot
                                                                    .data[index]
                                                                    .orderDate);
                                                        var newFormat =
                                                            DateFormat(
                                                                "dd-MMM-yyyy");
                                                        String updatedDt =
                                                            newFormat.format(
                                                                dateTime);
                                                        seldate =
                                                            _selectedIndex ==
                                                                    index
                                                                ? seldate =
                                                                    updatedDt
                                                                : seldate =
                                                                    date2;
                                                        print(updatedDt);
                                                        month =
                                                            "${snapshot.data[index].month}";
                                                        year = snapshot
                                                            .data[index].year;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
                                                        color: _selectedIndex !=
                                                                    null &&
                                                                _selectedIndex ==
                                                                    index
                                                            ? const Color(
                                                                0xff27a9e1)
                                                            : Colors.grey[400],
                                                        //  color: const Color(0xff27a9e1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 40.0, middle: 0.5),
                                                  Pin(size: 34.0, end: 6.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _onSelected(index);

                                                        DateTime dateTime =
                                                            DateTime.parse(
                                                                snapshot
                                                                    .data[index]
                                                                    .orderDate);
                                                        var newFormat =
                                                            DateFormat(
                                                                "dd-MMM-yyyy");
                                                        String updatedDt =
                                                            newFormat.format(
                                                                dateTime);
                                                        seldate =
                                                            _selectedIndex ==
                                                                    index
                                                                ? seldate =
                                                                    updatedDt
                                                                : seldate =
                                                                    date2;
                                                        print(updatedDt);
                                                        month =
                                                            "${snapshot.data[index].month}";
                                                        year = snapshot
                                                            .data[index].year;
                                                      });
                                                    },
                                                    child: Text(
                                                      "${date.day}",
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 28,
                                                        color: const Color(
                                                            0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        height:
                                                            1.1785714285714286,
                                                      ),
                                                      textHeightBehavior:
                                                          TextHeightBehavior(
                                                              applyHeightToFirstAscent:
                                                                  false),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 34.0, middle: 0.5),
                                                  Pin(
                                                      size: 17.0,
                                                      middle: 0.3968),
                                                  child: Text(
                                                    "${snapshot.data[index].day2}",
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xffffffff),
                                                      height: 2.357142857142857,
                                                    ),
                                                    textHeightBehavior:
                                                        TextHeightBehavior(
                                                            applyHeightToFirstAscent:
                                                                false),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ));
                                      })
                                  : Center(
                                      child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: 0.8,
                                    ));
                            }),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectOrderDate(date2, globals.custId, "next");
                            date2 = seldate;
                            type = "next";
                          });
                        },
                        child: Container(
                          height: 15,
                          width: 4.0,
                          margin: EdgeInsets.only(left: 10, right: 5, top: 5),
                          child: Pinned.fromPins(
                            Pin(size: 6, start: 0.0),
                            Pin(size: 15.0, middle: 0.4302),
                            child: SvgPicture.string(
                              _svg_kda80f,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    ])),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      month + "  " + year.toString(),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 130),
                  child: Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                )
              ])),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder<List<OrderData>>(
                      future: createLoginState(seldate, globals.custId),
                      builder: (context, AsyncSnapshot snapshot) {
                        print(snapshot.data);
                        return snapshot.data != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  /* );displayDate = DateTime.parse("${snapshot.data[index].date}"
                                  var newFormat2 = DateFormat("dd-mm-yyyy");
                                displayDate = newFormat2.format(displayDate);
                                   var dateDisplay = DateTime.parse(displayDate);*/

                                  /* displayDate = DateTime.parse("${snapshot.data[index].date}");
                                   var formattedDate = "${date.day}";*/
                                  String date = "${snapshot.data[index].date}";
                                  List dateSplit = date.split("-");
                                  print(dateSplit[0]);

                                  //DateTime parseDt = DateTime.parse(displayDate);

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 15),
                                    child: /*ExpansionTileCard(
                                          colorCurve: Curves.easeIn,
                                          baseColor: const Color(0xfff3f3f3),
                                          expandedColor:
                                              const Color(0xfff3f3f3),
                                          title:*/
                                        Container(
                                      height: 240,
                                      width: 350,
                                      //color: cons Color(0xfff3f3f3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: const Color(0xfff3f3f3),
                                      ),
//
                                      child: Pinned.fromPins(
                                          Pin(size: 350.0, middle: 0.2),
                                          Pin(size: 220.0, start: 0.0),
                                          child: Stack(children: <Widget>[
                                            Pinned.fromPins(
                                              Pin(size: 50.0, start: 16.0),
                                              Pin(size: 50.0, start: 21.0),
                                              child: Stack(
                                                children: <Widget>[
                                                  Pinned.fromPins(
                                                    Pin(start: 0.0, end: 0.0),
                                                    Pin(start: 0.0, end: 0.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        9999.0,
                                                                        9999.0)),
                                                        color: const Color(
                                                            0xffffffff),
                                                        border: Border.all(
                                                            width: 3.0,
                                                            color: const Color(
                                                                0xff27a9e1)),
                                                      ),
                                                    ),
                                                  ),
                                                  Pinned.fromPins(
                                                    Pin(
                                                        size: 40.0,
                                                        middle: 0.5),
                                                    Pin(
                                                        size: 34.0,
                                                        middle: 0.7),
                                                    child: Text(
                                                      dateSplit[0],
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 20,
                                                        color: const Color(
                                                            0xff27a9e1),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        height:
                                                            1.1785714285714286,
                                                      ),
                                                      textHeightBehavior:
                                                          TextHeightBehavior(
                                                              applyHeightToFirstAscent:
                                                                  false),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(size: 102.0, start: 75),
                                              Pin(size: 19.0, start: 25.0),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'WO No :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].number}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 66.0, start: 75),
                                              Pin(size: 20.0, start: 55),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Qty :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].quantity}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 150.0, start: 75),
                                              Pin(size: 20.0, start: 85),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Product :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].product}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 158.0, start: 75),
                                              Pin(size: 19.0, start: 115.0),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'PI No :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].piNo}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 200.0, start: 75.0),
                                              Pin(size: 20.0, start: 145.0),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Open Since (Days) : ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].days}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 160.0, end: 0.0),
                                              Pin(size: 20.0, start: 85),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Date :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].date}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 160.0, end: 0.0),
                                              Pin(size: 19.0, start: 115),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Status: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].status}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                              Pin(size: 160.0, end: 0.0),
                                              Pin(size: 20.0, start: 55),
                                              child: Text.rich(
                                                TextSpan(
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff333333),
                                                    height: 2.0625,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: 'SQM :',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${snapshot.data[index].sqm}",
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xff7e7e7e),
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
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50,
                                                    vertical: 5),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    ctx) =>
                                                                OrderStatus()));

                                                    globals.woNo =
                                                        "${snapshot.data[index].woNo}";
                                                  },
                                                  color:
                                                      const Color(0xff27a9e1),
                                                  textColor: Colors.white,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.access_time,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "  Product Status",
                                                          style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontSize: 17,
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ]),
                                                ))
                                          ])),
                                    ),
                                    /*children: <Widget>[
                                            Divider(
                                              thickness: 1.0,
                                              height: 1.0,
                                            ),
                                            Container(
                                              height: 120,
                                              width: 400,
                                              child: Stack(children: <Widget>[




                                              ]),*/
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: 0.8,
                              ));
                      })))
        ]));
  }
}

class OrderData {
  final int number;
  final String woNo;
  final String date;
  final int quantity;
  final String product;
  final String status;
  final int days;
  final int piNo;
  final double sqm;

  OrderData({
    required this.number,
    required this.woNo,
    required this.date,
    required this.quantity,
    required this.product,
    required this.status,
    required this.days,
    required this.piNo,
    required this.sqm,
  });

  factory OrderData.fromJson(Map<String, dynamic> data) {
    return OrderData(
      number: data['DisplayWONo'] as int,
      woNo: data['WONo'] as String,
      date: data['DisplayWODate'] as String,
      quantity: data['Qty'] as int,
      product: data['Product'] as String,
      status: data['Status'] as String,
      days: data['OpenSince'] as int,
      piNo: data['DisplayPINo'] as int,
      sqm: data['SQM'] as double,
    );
  }
}

class OrderDateData {
  final int custId;
  final String orderDate;
  final String maxDate;
  final String minDate;
  final String day2;
  final String month;
  final int year;

  OrderDateData({
    required this.custId,
    required this.orderDate,
    required this.maxDate,
    required this.minDate,
    required this.day2,
    required this.month,
    required this.year,
  });

  factory OrderDateData.fromJson(Map<String, dynamic> data) {
    return OrderDateData(
      custId: data['CustID'] as int,
      orderDate: data['OrderDate'] as String,
      maxDate: data['MaxDate'] as String,
      minDate: data['MinDate'] as String,
      day2: data['Day'] as String,
      month: data['Month'] as String,
      year: data['Year'] as int,
    );
  }
}

const String _svg_veh9ar =
    '<svg viewBox="0.0 0.0 24.6 29.4" ><path transform="translate(-1.97, 0.0)" d="M 23.36554908752441 3.186540603637695 L 22.53411674499512 3.186540603637695 L 22.53411674499512 2.219601631164551 C 22.53411674499512 0.9951886534690857 21.62772369384766 0 20.51233291625977 0 C 19.39618873596191 0 18.49054718017578 0.9951886534690857 18.49054718017578 2.219601631164551 L 18.49054718017578 3.185733795166016 L 16.4157600402832 3.185733795166016 L 16.4157600402832 2.219601631164551 C 16.4157600402832 0.9951886534690857 15.50936412811279 0 14.39397430419922 0 C 13.27858352661133 0 12.37218761444092 0.9951886534690857 12.37218761444092 2.219601631164551 L 12.37218761444092 3.185733795166016 L 10.29739665985107 3.185733795166016 L 10.29739665985107 2.219601631164551 C 10.29739665985107 0.9951886534690857 9.391000747680664 0 8.275611877441406 0 C 7.160222053527832 0 6.253824710845947 0.9951886534690857 6.253824710845947 2.219601631164551 L 6.253824710845947 3.185733795166016 L 5.192197322845459 3.185733795166016 C 3.418024063110352 3.185733795166016 1.974000215530396 4.724925994873047 1.974000215530396 6.616027355194092 L 1.974000215530396 25.98709487915039 C 1.974000215530396 27.87819480895996 3.418024063110352 29.41738891601562 5.192197322845459 29.41738891601562 L 23.36554527282715 29.41738891601562 C 25.14047813415527 29.41738891601562 26.58374214172363 27.87819480895996 26.58374214172363 25.98709487915039 L 26.58374214172363 6.616025924682617 C 26.58374214172363 4.725733280181885 25.13972282409668 3.186540603637695 23.36554908752441 3.186540603637695 Z M 19.62638092041016 2.219601631164551 C 19.62638092041016 1.663490414619446 20.02392196655273 1.210691809654236 20.51233291625977 1.210691809654236 C 21.00149917602539 1.210691809654236 21.39828109741211 1.663490414619446 21.39828109741211 2.219601631164551 L 21.39828109741211 6.171299457550049 C 21.39828109741211 6.727410793304443 21.00149917602539 7.180209159851074 20.51233291625977 7.180209159851074 C 20.02392196655273 7.180209159851074 19.62638092041016 6.727410793304443 19.62638092041016 6.171299457550049 L 19.62638092041016 2.219601631164551 Z M 13.50802135467529 2.219601631164551 C 13.50802135467529 1.663490414619446 13.9055643081665 1.210691809654236 14.39397239685059 1.210691809654236 C 14.88238143920898 1.210691809654236 15.27992343902588 1.663490414619446 15.27992343902588 2.219601631164551 L 15.27992343902588 6.171299457550049 C 15.27992343902588 6.727410793304443 14.88238143920898 7.180209159851074 14.39397239685059 7.180209159851074 C 13.9055643081665 7.180209159851074 13.50802135467529 6.727410793304443 13.50802135467529 6.171299457550049 L 13.50802135467529 2.219601631164551 Z M 7.388902187347412 2.219601631164551 C 7.388902187347412 1.663490414619446 7.786444187164307 1.210691809654236 8.274853706359863 1.210691809654236 C 8.763262748718262 1.210691809654236 9.16080379486084 1.663490414619446 9.16080379486084 2.219601631164551 L 9.16080379486084 6.171299457550049 C 9.16080379486084 6.727410793304443 8.763262748718262 7.180209159851074 8.274853706359863 7.180209159851074 C 7.786444187164307 7.180209159851074 7.388902187347412 6.727410793304443 7.388902187347412 6.171299457550049 L 7.388902187347412 2.219601631164551 Z M 24.6906909942627 25.9879035949707 C 24.6906909942627 26.76678466796875 24.09626960754395 27.40037727355957 23.36554908752441 27.40037727355957 L 5.192198276519775 27.40037727355957 C 4.461477756500244 27.40037727355957 3.867058277130127 26.76678466796875 3.867058277130127 25.9879035949707 L 3.867058277130127 8.23109245300293 L 24.6906909942627 8.23109245300293 L 24.6906909942627 25.9879035949707 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ecwlvx =
    '<svg viewBox="364.8 330.5 14.5 6.1" ><path transform="translate(-874.23, 83.5)" d="M 1238.986328125 246.9999694824219 L 1246.89208984375 253.1191101074219 L 1253.48046875 246.9999694824219" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_dwdtau =
    '<svg viewBox="16.0 176.5 3.8 9.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 266.81, -1062.49)" d="M 1238.986328125 246.9999694824219 L 1243.9033203125 250.8057708740234 L 1248.0009765625 246.9999694824219" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_kda80f =
    '<svg viewBox="394.2 176.5 3.8 9.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 398.0, 176.49)" d="M 0 3.8057861328125 L 4.9169921875 0 L 9.0146484375 3.8057861328125" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_878e5e =
    '<svg viewBox="187.5 250.5 39.0 1.0" ><path transform="translate(187.5, 250.5)" d="M 0 0 L 39 0" fill="none" stroke="#c0c0c0" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
