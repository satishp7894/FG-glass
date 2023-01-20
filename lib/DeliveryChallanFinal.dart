import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';
import 'package:flutter_fg_glass_app/DeliveryChallan.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;
import 'package:intl/intl.dart';

class deliveryChallan extends StatefulWidget {
  @override
  deliveryChallanState createState() => deliveryChallanState();
}

class deliveryChallanState extends State<deliveryChallan> {
  late String fromDate;
  late String toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      DateTime date = DateTime.now();
      var newDate = new DateTime(date.year, date.month, date.day - 7);
      fromDate = DateFormat('dd-MMM-yyyy').format(newDate);
      print(fromDate);
      toDate = DateFormat('dd-MMM-yyyy').format(date);
      print(toDate);
      globals.setFromDate = fromDate;
      globals.setToDate = toDate;
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
        body: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: NestedScrollView(
                body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        child: DeliveyChallan(),
                      ),
                      Container(
                        child: DeliveyChallan(),
                      ),
                      Container(
                        child: DeliveyChallan(),
                      ),
                      Container(
                        child: DeliveyChallan(),
                      ),
                    ]),
                scrollDirection: Axis.vertical,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                          child: Column(children: <Widget>[
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 24),
                          child: Text(
                            "Delivery Challan",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20,
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.w900,
                              height: 0.65,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 16, left: 5, right: 5),
                            constraints: BoxConstraints.expand(height: 40),
                            child: TabBar(
                              onTap: (int index) {
                                if (index == 0) {
                                  DateTime date = DateTime.now();
                                  var newDate = new DateTime(
                                      date.year, date.month, date.day - 7);
                                  fromDate =
                                      DateFormat('dd-MMM-yyyy').format(newDate);
                                  print(fromDate);
                                  toDate =
                                      DateFormat('dd-MMM-yyyy').format(date);
                                  print(toDate);
                                  globals.setFromDate = fromDate;
                                  globals.setToDate = toDate;
                                }
                                if (index == 1) {
                                  DateTime date = DateTime.now();
                                  var newDate = new DateTime(
                                      date.year, date.month, 1);
                                  fromDate =
                                      DateFormat('d-MMM-yyyy').format(newDate);
                                  print(fromDate);
                                  var yearToDate = new DateTime(
                                      date.year, date.month, 31);
                                  toDate =
                                      DateFormat('d-MMM-yyyy').format(yearToDate);
                                  print(toDate);
                                  globals.setFromDate = fromDate;
                                  globals.setToDate = toDate;
                                }
                                if (index == 2) {
                                  DateTime date = DateTime.now();

                                  if (date.month == 1 || date.month == 2 || date.month == 3){
                                    var newDate = new DateTime(
                                        date.year, 1, 1);
                                    fromDate =
                                        DateFormat('d-MMM-yyyy').format(newDate);
                                    print(fromDate);
                                    var yearToDate = new DateTime(
                                        date.year, 3, 31);
                                    toDate =
                                        DateFormat('d-MMM-yyyy').format(yearToDate);
                                    print(toDate);
                                  }
                                  if (date.month == 4 || date.month == 5 || date.month == 6){
                                    var newDate = new DateTime(
                                        date.year, 4, 1);
                                    fromDate =
                                        DateFormat('d-MMM-yyyy').format(newDate);
                                    print(fromDate);
                                    var yearToDate = new DateTime(
                                        date.year, 6, 30);
                                    toDate =
                                        DateFormat('d-MMM-yyyy').format(yearToDate);
                                    print(toDate);
                                  }

                                  if (date.month == 7 || date.month == 8 || date.month == 9){
                                    var newDate = new DateTime(
                                        date.year, 7, 1);
                                    fromDate =
                                        DateFormat('d-MMM-yyyy').format(newDate);
                                    print(fromDate);
                                    var yearToDate = new DateTime(
                                        date.year, 9, 30);
                                    toDate =
                                        DateFormat('d-MMM-yyyy').format(yearToDate);
                                    print(toDate);
                                  }

                                  if (date.month == 10 || date.month == 11 || date.month == 12){
                                    var newDate = new DateTime(
                                        date.year, 10, 1);
                                    fromDate =
                                        DateFormat('d-MMM-yyyy').format(newDate);
                                    print(fromDate);
                                    var yearToDate = new DateTime(
                                        date.year, 12, 31);
                                    toDate =
                                        DateFormat('d-MMM-yyyy').format(yearToDate);
                                    print(toDate);
                                  }
                                 /* var newDate = new DateTime(
                                      date.year, date.month - 4, date.day);
                                  fromDate =
                                      DateFormat('dd-MMM-yyyy').format(newDate);
                                  print(fromDate);
                                  toDate =
                                      DateFormat('dd-MMM-yyyy').format(date);
                                  print(toDate);*/
                                  globals.setFromDate = fromDate;
                                  globals.setToDate = toDate;
                                }
                                if (index == 3) {
                                  DateTime date = DateTime.now();
                                  var newDate = new DateTime(
                                      date.year, 4, 1);
                                  fromDate =
                                      DateFormat('d-MMM-yyyy').format(newDate);
                                  print(fromDate);
                                  var yearToDate = new DateTime(
                                      date.year+1, 3, 31);
                                  toDate =
                                      DateFormat('d-MMM-yyyy').format(yearToDate);
                                  print(toDate);
                                  globals.setFromDate = fromDate;
                                  globals.setToDate = toDate;
                                }
                              },
                              unselectedLabelColor: Colors.grey,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xff27a9e1)),
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Week',
                                    style: TextStyle(
                                        //  color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Montserrat-Regular'),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Month',
                                    style: TextStyle(
                                        // color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Montserrat-Regular'),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Quarter',
                                    style: TextStyle(
                                        //  color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Montserrat-Regular'),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Year',
                                    style: TextStyle(
                                        // color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: 'Montserrat-Regular'),
                                  ),
                                ),
                              ],
                            ))
                      ]))
                    ])));
  }
}
