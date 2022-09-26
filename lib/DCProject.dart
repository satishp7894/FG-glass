import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'globalVariables.dart' as globals;
import 'package:intl/intl.dart';

class DCProject extends StatefulWidget {
  @override
  DCProjectState createState() => DCProjectState();
}

class DCProjectState extends State<DCProject> {
    List<ProjectDetailData> items =[];

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

  createLoginState(int custId, int projectId) async {
    final response = await post(Uri.parse(
        'https://fgapi.digidisruptors.in/api/CustomerAPI/GetTIAgainstProjectAndCustomer?custID=$custId&projectID=$projectId'));

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['taxInvoices'];

      items = data
          .map<ProjectDetailData>((json) => ProjectDetailData.fromJson(json))
          .toList();
      //   employeeDataSource = EmployeeDataSource(_employees);
      //print(_employees[1].title);
      return items;
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
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: <Widget>[

              FutureBuilder<Product>(
                  future: fetchAlbum(
                      globals.custId, globals.projectId),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? Container(
                      height: 50,
                      width: 350,
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
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
                        : Center(
                        child: Container());
                  }),
              FutureBuilder(
                  future: createLoginState(
                      globals.custId, globals.projectId),
                  builder: (context, AsyncSnapshot snapshot) {
                    print('-----$snapshot.data');

                    return snapshot.data != null
                        ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          int i = index + 1;
                          String SrNo = i.toString();
                          print(SrNo);

                          return Container(
                              height: 210,
                              width: 400,
                              color: const Color(0xfff3f3f3),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Pinned.fromPins(
                                  Pin(size: 340.0, end: 16.0),
                                  Pin(size: 190.0, end: 0.0),
                                  child: Stack(children: <Widget>[
                                     Pinned.fromPins(
                                          Pin(size: 138.0, start: 50),
                                          Pin(size: 19.0, start: 0.0),
                                          child: Text(
                                            'TI No. : ' +
                                                " ${snapshot.data[index].number}",
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color:
                                              const Color(0xff27a9e1),
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textHeightBehavior:
                                            TextHeightBehavior(
                                                applyHeightToFirstAscent:
                                                false),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 30),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 60),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 90),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Grand Total :',
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  " ${snapshot.data[index].amount}",
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
                                          Pin(size: 250.0, start: 50),
                                          Pin(size: 19.0, start: 120),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 2,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Project :',
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  " ${snapshot.data[index].project}",
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
                                          Pin(size: 19.0, start: 0.0),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                      Pin(size: 19.0, start: 30.0),
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 16,
                                            color: const Color(
                                                0xff333333),
                                            height: 1,
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
                                    Pinned.fromPins(
                                      Pin(size: 160.0, end: 0.0),
                                      Pin(size: 19.0, start: 60.0),
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 16,
                                            color: const Color(
                                                0xff333333),
                                            height: 1,
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
                                          /*Pinned.fromPins(
                                            Pin(size: 300.4, end: 2.0),
                                            Pin(size: 1.0, start: 180),
                                            child: SvgPicture.string(
                                              _svg_ctuw2f,
                                              allowDrawingOutsideViewBox:
                                              true,
                                              fit: BoxFit.fill,
                                            ),
                                          ),*/
                                          Pinned.fromPins(
                                            Pin(size: 41.0, start: 0.0),
                                            Pin(size: 41.0, start: 0.5),
                                            child: Stack(
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(start: 0.0, end: 0.0),
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.elliptical(
                                                              9999.0,
                                                              9999.0)),
                                                      color: const Color(
                                                          0xff27a9e1),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 30.0, start: 5),
                                                  Pin(start: 10.0, end: 0.0),
                                                  child: Text(
                                                    SrNo,
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0xffffffff),
                                                      fontWeight:
                                                      FontWeight.w900,
                                                      height:
                                                      1.9166666666666667,
                                                    ),
                                                    textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                        false),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ),
                                                ),
                             /* Pinned.fromPins(
                                Pin(size: 380.0, end: 16.0),
                                Pin(size: 250.0, end: 0.0),
                                child: Stack(children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 22.0, end: 57.1),
                                    Pin(size: 220.0,start: 10.5),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(size: 138.0, start: 50),
                                          Pin(size: 19.0, start: 0.0),
                                          child: Text(
                                            'TI No. : ' +
                                                " ${snapshot.data[index].number}",
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color:
                                              const Color(0xff27a9e1),
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textHeightBehavior:
                                            TextHeightBehavior(
                                                applyHeightToFirstAscent:
                                                false),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 30),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 60),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                        Pinned.fromPins(
                                          Pin(size: 140.0, start: 50),
                                          Pin(size: 19.0, start: 90),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 120),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Grand Total :',
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  " ${snapshot.data[index].amount}",
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
                                          Pin(size: 200.0, start: 50),
                                          Pin(size: 19.0, start: 150),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
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
                                          Pin(size: 250.0, start: 50),
                                          Pin(size: 19.0, start: 180),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 2,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Project :',
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  " ${snapshot.data[index].project}",
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
                                          Pin(size: 100.0, end: 0.0),
                                          Pin(size: 19.0, start: 0.0),
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16,
                                                color: const Color(
                                                    0xff333333),
                                                height: 1,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'QTY :',
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/
                          ]))])));
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

class Product {
  final String totalAmount;
  final List<ProjectDetailData> results;

  Product({required this.totalAmount, required this.results});

  factory Product.fromJson(Map<String, dynamic> data) {
    var list = data['deliveryChallans'] as List;
    List<ProjectDetailData> resultList =
    list.map((e) => ProjectDetailData.fromJson(e)).toList();
    return Product(
      totalAmount: data['TotalAmount'] as String,
      results: resultList,
    );
  }
}

/*class ProjectDetailData {
  final int number;
  final String date;
  final int quantity;
  final String product;
  final double sqm;
  final String owner;
  final String salesPerson;
  final String project;

  ProjectDetailData({
    required this.number,
    required this.date,
    required this.quantity,
    required this.product,
    required this.sqm,
    required this.owner,
    required this.salesPerson,
    required this.project,
  });

  factory ProjectDetailData.fromJson(Map<String, dynamic> data) {
    return ProjectDetailData(
      number: data['DisplayDCNo'] as int,
      date: data['DisplayDCDate'] as String,
      quantity: data['Qty'] as int,
      product: data['Product'] as String,
      sqm: data['SQM'] as double,
      owner: data['Owner'] as String,
      salesPerson: data['Salesperson'] as String,
      project: data['Project'] as String,
    );
  }
}*/
class ProjectDetailData {
  final String number;
  final String date;
  final int quantity;
  final String product;
  final double sqm;
  final String owner;
  final String salesPerson;
  final String  piNo;
  final String amount;
  final String project;

  ProjectDetailData({
    required this.number,
    required this.date,
    required this.quantity,
    required this.product,
    required this.sqm,
    required this.owner,
    required this.salesPerson,
    required this.piNo,
    required this.amount,
    required this.project,
  });

  factory ProjectDetailData.fromJson(Map<String, dynamic> data) {
    return ProjectDetailData(
      number: data['DisplayTINo'] as String,
      date: data['DisplayTIDate'] as String,
      quantity: data['Qty'] as int,
      product: data['Product'] ?? " ",
      sqm: data['SQM'] as double,
      owner: data['Owner'] ?? " ",
      salesPerson: data['Salesperson'] ?? " ",
      piNo: data['DisplayPINo'] as String,
      amount: data['DisplayAmount']?? "",
      project: data['Project'] ?? " ",
    );
  }
}

const String _svg_ctuw2f =
    '<svg viewBox="96.0 396.5 239.4 1.0" ><path transform="translate(96.0, 396.5)" d="M 0 0 L 239.40625 0" fill="none" stroke="#c0c0c0" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
