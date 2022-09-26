import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'Dashboard.dart';
import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';

class OrdersPieChartPage extends StatefulWidget {
  const OrdersPieChartPage({Key? key}) : super(key: key);

  @override
  State<OrdersPieChartPage> createState() => OrdersPieChartPageState();
}

class OrdersPieChartPageState extends State<OrdersPieChartPage> {
  Map<String, double> dataMap = {
    "Facades": 18.47,
    "Interio": 17.70,
    "Security": 10.25,
    "Fire Safety": 11.51,
    "Creation": 16.83,
  };

  List<Color> colorList = [
    const Color(0xff36a2eb),
    const Color(0xffffce56),
    const Color(0xff4bc0c0),
    const Color(0xffff6384),
    const Color(0xffff9f40)
  ];

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () {
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
      body: Center(

        child: Column (
          children:[
          SizedBox(
          height: 48,
        ),

        Text('Orders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),),
        SizedBox(
          height: 48,
        ),
        PieChart(
          chartType: ChartType.disc,

          dataMap: dataMap,
          colorList: colorList,
          chartRadius: MediaQuery.of(context).size.width / 2,
          centerText: "Total SQM",
          ringStrokeWidth: 0,
          animationDuration: const Duration(seconds: 3),
          chartValuesOptions: const ChartValuesOptions(
              showChartValues: true,
              showChartValuesOutside: false,
              showChartValuesInPercentage: true,
              showChartValueBackground: true),
          legendOptions: const LegendOptions(
              showLegends: true,
              legendShape: BoxShape.rectangle,
              legendTextStyle: TextStyle(fontSize: 15),
              legendPosition: LegendPosition.right,
              showLegendsInRow: false),
          //gradientList: gradientList,
        ),
      ])),
    );
  }
}