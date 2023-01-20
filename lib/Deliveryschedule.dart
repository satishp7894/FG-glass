import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:http/http.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Dashboard.dart';
import 'DeliveryChallanFinal.dart';
import 'IssueRaised.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;
import 'package:intl/intl.dart';


class DeliverySchedule extends StatefulWidget {
  @override
  DeliveryScheduleState createState() => DeliveryScheduleState();
}

class DeliveryScheduleState extends State<DeliverySchedule> {
  late final List<ProformaData> items;
  late Future<List<OrderDateData>> dateSorting;

  var date;
  var displayDate;
 //late final List<OrderData> items;
  late String seldate = "11-Aug-2021";
  String date2 = "04-Aug-2021";

//  int custId = 19;
  // int custId2 = 33;
  int _selectedIndex = 0;
  late String type = "next";

  late String month = "Aug";
  late int year = 2021;

  String updatedDt = " ";

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }


  Future<List<OrderDateData>> selectOrderDate(
      String date, int custId, String type) async {
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetActiveDatesForDelivery?PIDate=$date&custID=$custId&type=$type'));

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

  Future<List<ProformaData>> createLoginState(String date, int custId) async {
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetDeliveryofGivenDate?PIDate=$date&custID=$custId'));

    if (response.statusCode == 200) {
      print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ProformaData>((json) => ProformaData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      DateTime currentDate =  DateTime.now();
      var newFormat = DateFormat("dd-MMM-yyyy");
      var monthFormat = DateFormat("MMM");
      String strCurrentDate = newFormat.format(currentDate);

      dateSorting = selectOrderDate(strCurrentDate, globals.custId, "previous");
      year = currentDate.year;
      month = monthFormat.format(currentDate);
      _selectedIndex = currentDate.day;

      seldate =strCurrentDate;// "11-Aug-2021";
      // date2 = "04-Aug-2021";
    });
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
          centerTitle: false,
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
    child: Image.asset('assets/images/login head.png',
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

              Container(
                height: 50,
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  'Delivery Schedule',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w900,
                    height: 0.65,
                  ),
                  textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                ),
              ),

              Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16),
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
                                future: selectOrderDate(date2, globals.custId, type),
                                builder: (context, AsyncSnapshot snapshot) {

                                  if (snapshot.data?.isEmpty?? true) {
                                    return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[

                                          Container(

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
                                                            snapshot.data[4]
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
              FutureBuilder<List<ProformaData>>(
                  future: createLoginState(seldate, globals.custId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data?.isEmpty?? true) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[

                            Container(

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



                    }
                    return snapshot.data != null
                        ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            height: 250,
                            width: 350,
                            child: Pinned.fromPins(
                                Pin(start: 16.0, end: 16.0),
                                Pin(size: 220.0, start: 0.0),
                                child: Stack(children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 220.0, start: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        color: const Color(0xfff3f3f3),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 250.0,start: 20),
                                    Pin(size: 19.0, start: 25.0),
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
                                    Pin(size: 240.0, start: 20),
                                    Pin(size: 20.0, start: 55),
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
                                            text: 'WO No :',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            " ${snapshot.data[index].woNo}",
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
                                    Pin(size: 240.0, start: 20),
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
                                            text: 'Total Pcs :',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            " ${snapshot.data[index].totalPcs}",
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
                                    Pin(size: 240.0, start: 20),
                                    Pin(size: 20.0, start: 115),
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
                                            text: 'From Date :',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            " ${snapshot.data[index].fromDate}",
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
                                    Pin(size: 300.0, start: 20),
                                    Pin(size: 20.0, start: 145),
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
                                            text: 'To Date :',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            " ${snapshot.data[index].toDate}",
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
                                    Pin(size: 300.0, start: 20),
                                    Pin(size: 20.0, start: 175),
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
                                            text: 'Project Name :',
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
                                    Pin(size: 190.0, end: 10.0),
                                    Pin(size: 20.0, start: 55),
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
                                    Pin(size: 190.0, end: 10.0),
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
                                            text: 'Total SQM :',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            " ${snapshot.data[index].totalSqm}",
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
                                    Pin(size: 190.0, end: 10.0),
                                    Pin(size: 20.0, start: 25),
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

class ProformaData {
  final String number;
  final String woNo;
  final String date;
  final String product;
  final String fromDate;
  final String toDate;
  final String project;
  final int totalPcs;
  final double totalSqm;

  ProformaData({
    required this.number,
    required this.woNo,
    required this.date,
    required this.product,
    required this.fromDate,
    required this.toDate,
    required this.project,
    required this.totalPcs,
    required this.totalSqm,
  });

  factory ProformaData.fromJson(Map<String, dynamic> data) {
    return ProformaData(
      number: data['DisplayPINo'] as String,
      woNo: data['WONo'] as String,
      date: data['DisplayPIDate'] as String,
      product: data['Product'] as String,
      fromDate: data['FromDate'] as String,
      toDate: data['ToDate'] as String,
      project: data['Project'] as String,
      totalPcs: data['TotalPcs'] as int,
      totalSqm: data['TotalSQM'] as double,
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
      orderDate: data['PIDate'] as String,
      maxDate: data['MaxDate'] as String,
      minDate: data['MinDate'] as String,
      day2: data['Day'] as String,
      month: data['Month'] as String,
      year: data['Year'] as int,
    );
  }
}
const String _svg_dwdtau =
    '<svg viewBox="16.0 176.5 3.8 9.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 266.81, -1062.49)" d="M 1238.986328125 246.9999694824219 L 1243.9033203125 250.8057708740234 L 1248.0009765625 246.9999694824219" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_kda80f =
    '<svg viewBox="394.2 176.5 3.8 9.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 398.0, 176.49)" d="M 0 3.8057861328125 L 4.9169921875 0 L 9.0146484375 3.8057861328125" fill="none" stroke="#707070" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="round" /></svg>';

