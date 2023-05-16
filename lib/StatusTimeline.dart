import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'IssueRaised.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'TaxInvoiceFinal.dart';
import 'login.dart';

class StatusTimeline extends StatelessWidget {

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
        centerTitle: false,
        title: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 15),
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
                  onTap: () async {
                    SharedPreferences _prefs = await SharedPreferences.getInstance();
                    await _prefs.clear();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                        LoginPage()), (Route<dynamic> route) => false);
                  },

                ),

              ],
            ),
          )),

      body: Column(
        children: [

          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16),
            child: Container(
              height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff3f3f3),
                  ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(children: [
                    Expanded(
                      child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                      'Stage A',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: const Color(0xff333333),
                                        height: 1.1428571428571428,
                                      ),
                                      textHeightBehavior:
                                          TextHeightBehavior(applyHeightToFirstAscent: false),
                                      textAlign: TextAlign.left,
                                    ),
                          Stack(
                            children: [
                              SvgPicture.string(
                                                    _svg_lj2ydv,
                                                    allowDrawingOutsideViewBox: true,
                                                    fit: BoxFit.fill,
                                                  ),
                              Positioned(
                                bottom: 4.2,
                                right: 3,
                                child: Column(

                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 2.7,width: 2.9,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff27a9e1),
                                              ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                      ],
                                    ),
                                    SizedBox(height: 1.0,),
                                    Row(
                                      children: [
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                      ],
                                    ),
                                    SizedBox(height: 1.0,),
                                    Row(
                                      children: [
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                        SizedBox(width: 1.0,),
                                        Container(
                                          height: 2.7,width: 2.9,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff27a9e1),
                                          ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                            ],
                          ),
                        ),
                        height: 45,
                      ),
                    ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stage B',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: const Color(0xff333333),
                                    height: 1.1428571428571428,
                                  ),
                                  textHeightBehavior:
                                  TextHeightBehavior(applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                                Stack(
                                  children: [
                                    SvgPicture.string(
                                      _svg_lj2ydv,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                      bottom: 4.2,
                                      right: 3,
                                      child: Column(

                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                            ],
                                          ),
                                          SizedBox(height: 1.0,),
                                          Row(
                                            children: [
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                            ],
                                          ),
                                          SizedBox(height: 1.0,),
                                          Row(
                                            children: [
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                              SizedBox(width: 1.0,),
                                              Container(
                                                height: 2.7,width: 2.9,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xff27a9e1),
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          height: 45,
                        ),
                      ),

                    ],),
                  ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Stage C',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: const Color(0xff333333),
                                      height: 1.1428571428571428,
                                    ),
                                    textHeightBehavior:
                                    TextHeightBehavior(applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  ),
                                  Stack(
                                    children: [
                                      SvgPicture.string(
                                        _svg_lj2ydv,
                                        allowDrawingOutsideViewBox: true,
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        bottom: 4.2,
                                        right: 3,
                                        child: Column(

                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                              ],
                                            ),
                                            SizedBox(height: 1.0,),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                              ],
                                            ),
                                            SizedBox(height: 1.0,),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                                SizedBox(width: 1.0,),
                                                Container(
                                                  height: 2.7,width: 2.9,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff27a9e1),
                                                  ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            height: 45,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Stage A',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: const Color(0xff333333),
                                      height: 1.1428571428571428,
                                    ),
                                    textHeightBehavior:
                                    TextHeightBehavior(applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  ),
                                  // SvgPicture.string(
                                  //   _svg_lj2ydv,
                                  //   allowDrawingOutsideViewBox: true,
                                  //   fit: BoxFit.fill,
                                  // ),
                                ],
                              ),
                            ),
                            height: 45,
                          ),
                        ),

                      ],),
                    ),
                ],),
              ),


            ),
          ),
        ],
      ),
      // body: Stack(
      //   children: <Widget>[
      //
      //
      //     Pinned.fromPins(
      //       Pin(start: 16.0, end: 16.0),
      //       Pin(size: 150.0, middle: 0.2062),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(5.0),
      //           color: const Color(0xfff3f3f3),
      //         ),
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 173.0, start: 30.0),
      //       Pin(size: 45.0, middle: 0.197),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: const Color(0xffffffff),
      //         ),
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 173.0, start: 30.0),
      //       Pin(size: 45.0, middle: 0.2852),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: const Color(0xffffffff),
      //         ),
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 173.0, end: 31.0),
      //       Pin(size: 45.0, middle: 0.2852),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: const Color(0xffffffff),
      //         ),
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 173.0, end: 31.0),
      //       Pin(size: 45.0, middle: 0.197),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: const Color(0xffffffff),
      //         ),
      //       ),
      //     ),
      //
      //     Pinned.fromPins(
      //       Pin(size: 55.0, middle: 0.6435),
      //       Pin(size: 20.0, middle: 0.2921),
      //       child: Text(
      //         'Stage D',
      //         style: TextStyle(
      //           fontFamily: 'Poppins',
      //           fontSize: 14,
      //           color: const Color(0xff333333),
      //           height: 1.1428571428571428,
      //         ),
      //         textHeightBehavior:
      //             TextHeightBehavior(applyHeightToFirstAscent: false),
      //         textAlign: TextAlign.left,
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 54.0, start: 51.0),
      //       Pin(size: 20.0, middle: 0.2065),
      //       child: Text(
      //         'Stage A',
      //         style: TextStyle(
      //           fontFamily: 'Poppins',
      //           fontSize: 14,
      //           color: const Color(0xff333333),
      //           height: 1.1428571428571428,
      //         ),
      //         textHeightBehavior:
      //             TextHeightBehavior(applyHeightToFirstAscent: false),
      //         textAlign: TextAlign.left,
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 53.0, middle: 0.6399),
      //       Pin(size: 20.0, middle: 0.2065),
      //       child: Text(
      //         'Stage B',
      //         style: TextStyle(
      //           fontFamily: 'Poppins',
      //           fontSize: 14,
      //           color: const Color(0xff333333),
      //           height: 1.1428571428571428,
      //         ),
      //         textHeightBehavior:
      //             TextHeightBehavior(applyHeightToFirstAscent: false),
      //         textAlign: TextAlign.left,
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 55.0, start: 51.0),
      //       Pin(size: 20.0, middle: 0.2921),
      //       child: Text(
      //         'Stage C',
      //         style: TextStyle(
      //           fontFamily: 'Poppins',
      //           fontSize: 14,
      //           color: const Color(0xff333333),
      //           height: 1.1428571428571428,
      //         ),
      //         textHeightBehavior:
      //             TextHeightBehavior(applyHeightToFirstAscent: false),
      //         textAlign: TextAlign.left,
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 20.4, middle: 0.4267),
      //       Pin(size: 24.4, middle: 0.2904),
      //       child:
      //           // Adobe XD layer: 'calendar-interface-…' (group)
      //           Stack(
      //         children: <Widget>[
      //           Pinned.fromPins(
      //             Pin(start: 0.0, end: 0.0),
      //             Pin(start: 0.0, end: 0.0),
      //             child: Stack(
      //               children: <Widget>[
      //                 Pinned.fromPins(
      //                   Pin(start: 0.0, end: 0.0),
      //                   Pin(start: 0.0, end: 0.0),
      //                   child: SvgPicture.string(
      //                     _svg_lj2ydv,
      //                     allowDrawingOutsideViewBox: true,
      //                     fit: BoxFit.fill,
      //                   ),
      //                 ),
      //                 // Pinned.fromPins(
      //                 //   Pin(size: 2.9, start: 3.0),
      //                 //   Pin(size: 2.7, middle: 0.452),
      //                 //   child: Container(
      //                 //     decoration: BoxDecoration(
      //                 //       color: const Color(0xff27a9e1),
      //                 //     ),
      //                 //   ),
      //                 // ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 20.4, middle: 0.4267),
      //       Pin(size: 24.4, middle: 0.2043),
      //       child:
      //           // Adobe XD layer: 'calendar-interface-…' (group)
      //           Stack(
      //         children: <Widget>[
      //           Pinned.fromPins(
      //             Pin(start: 0.0, end: 0.0),
      //             Pin(start: 0.0, end: 0.0),
      //             child: Stack(
      //               children: <Widget>[
      //                 Pinned.fromPins(
      //                   Pin(start: 0.0, end: 0.0),
      //                   Pin(start: 0.0, end: 0.0),
      //                   child: SvgPicture.string(
      //                     _svg_lj2ydv,
      //                     allowDrawingOutsideViewBox: true,
      //                     fit: BoxFit.fill,
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Pinned.fromPins(
      //       Pin(size: 20.4, end: 46.6),
      //       Pin(size: 24.4, middle: 0.2043),
      //       child:
      //           // Adobe XD layer: 'calendar-interface-…' (group)
      //           Stack(
      //         children: <Widget>[
      //           Pinned.fromPins(
      //             Pin(start: 0.0, end: 0.0),
      //             Pin(start: 0.0, end: 0.0),
      //             child: Stack(
      //               children: <Widget>[
      //                 Pinned.fromPins(
      //                   Pin(start: 0.0, end: 0.0),
      //                   Pin(start: 0.0, end: 0.0),
      //                   child: SvgPicture.string(
      //                     _svg_lj2ydv,
      //                     allowDrawingOutsideViewBox: true,
      //                     fit: BoxFit.fill,
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.452),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.6206),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, start: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.39),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, middle: 0.61),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //                 Pinned.fromPins(
      //                   Pin(size: 2.9, end: 3.0),
      //                   Pin(size: 2.7, middle: 0.7892),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       color: const Color(0xff27a9e1),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //
      //
      //   ],
      // ),
    );
  }
}

const String _svg_rjvq91 =
    '<svg viewBox="30.4 223.5 353.1 1.0" ><path transform="translate(30.39, 223.5)" d="M 0 0 L 353.1097412109375 0" fill="none" fill-opacity="0.32" stroke="#c0c0c0" stroke-width="1" stroke-opacity="0.32" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_lj2ydv =
    '<svg viewBox="0.0 0.0 20.4 24.4" ><path transform="translate(-1.97, 0.0)" d="M 19.72772979736328 2.644641399383545 L 19.03769111633301 2.644641399383545 L 19.03769111633301 1.842138886451721 C 19.03769111633301 0.8259481191635132 18.28543663024902 0 17.35972785949707 0 C 16.43339347839355 0 15.68176460266113 0.8259481191635132 15.68176460266113 1.842138886451721 L 15.68176460266113 2.643971681594849 L 13.95981216430664 2.643971681594849 L 13.95981216430664 1.842138886451721 C 13.95981216430664 0.8259481191635132 13.20755672454834 0 12.2818489074707 0 C 11.35614013671875 0 10.60388469696045 0.8259481191635132 10.60388469696045 1.842138886451721 L 10.60388469696045 2.643971681594849 L 8.881930351257324 2.643971681594849 L 8.881930351257324 1.842138886451721 C 8.881930351257324 0.8259481191635132 8.129674911499023 0 7.203967094421387 0 C 6.278259754180908 0 5.526002883911133 0.8259481191635132 5.526002883911133 1.842138886451721 L 5.526002883911133 2.643971681594849 L 4.644914627075195 2.643971681594849 C 3.172455072402954 2.643971681594849 1.974000096321106 3.921411037445068 1.974000096321106 5.490913867950439 L 1.974000096321106 21.5677604675293 C 1.974000096321106 23.13726234436035 3.172455072402954 24.41470336914062 4.644914627075195 24.41470336914062 L 19.72772789001465 24.41470336914062 C 21.2008171081543 24.41470336914062 22.39864158630371 23.13726234436035 22.39864158630371 21.5677604675293 L 22.39864158630371 5.490912437438965 C 22.39864158630371 3.922080755233765 21.2001895904541 2.644641399383545 19.72772979736328 2.644641399383545 Z M 16.62443923950195 1.842138886451721 C 16.62443923950195 1.3805992603302 16.95437622070312 1.004803061485291 17.35972785949707 1.004803061485291 C 17.76570701599121 1.004803061485291 18.09501266479492 1.3805992603302 18.09501266479492 1.842138886451721 L 18.09501266479492 5.12181568145752 C 18.09501266479492 5.58335542678833 17.76570701599121 5.959151744842529 17.35972785949707 5.959151744842529 C 16.95437622070312 5.959151744842529 16.62443923950195 5.58335542678833 16.62443923950195 5.12181568145752 L 16.62443923950195 1.842138886451721 Z M 11.54655933380127 1.842138886451721 C 11.54655933380127 1.3805992603302 11.87649726867676 1.004803061485291 12.28184700012207 1.004803061485291 C 12.68719863891602 1.004803061485291 13.01713466644287 1.3805992603302 13.01713466644287 1.842138886451721 L 13.01713466644287 5.12181568145752 C 13.01713466644287 5.58335542678833 12.68719863891602 5.959151744842529 12.28184700012207 5.959151744842529 C 11.87649726867676 5.959151744842529 11.54655933380127 5.58335542678833 11.54655933380127 5.12181568145752 L 11.54655933380127 1.842138886451721 Z M 6.468050479888916 1.842138886451721 C 6.468050479888916 1.3805992603302 6.79798698425293 1.004803061485291 7.203337669372559 1.004803061485291 C 7.608688831329346 1.004803061485291 7.938624858856201 1.3805992603302 7.938624858856201 1.842138886451721 L 7.938624858856201 5.12181568145752 C 7.938624858856201 5.58335542678833 7.608688831329346 5.959151744842529 7.203337669372559 5.959151744842529 C 6.79798698425293 5.959151744842529 6.468050479888916 5.58335542678833 6.468050479888916 5.12181568145752 L 6.468050479888916 1.842138886451721 Z M 20.82751846313477 21.56843185424805 C 20.82751846313477 22.21485710144043 20.33418464660645 22.74070167541504 19.72772979736328 22.74070167541504 L 4.644915103912354 22.74070167541504 C 4.038460254669189 22.74070167541504 3.545127153396606 22.21485710144043 3.545127153396606 21.56843185424805 L 3.545127153396606 6.83132266998291 L 20.82751846313477 6.83132266998291 L 20.82751846313477 21.56843185424805 Z" fill="#27a9e1" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
