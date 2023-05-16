import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/utils/connections.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'globalVariables.dart' as globals;
import 'package:intl/intl.dart';

class TIProject extends StatefulWidget {
  @override
  TIProjectState createState() => TIProjectState();
}

class TIProjectState extends State<TIProject> {
  late List items;
  late String fromDate;
  late String toDate;

  Future<Product> fetchAlbum(int custId, int projectId) async {
    final response = await post(Uri.parse(
        '${Connections.customerUrl}GetTIAgainstProjectAndCustomer?custID=$custId&projectID=$projectId'));

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

  createLoginState(int custId) async {
    final response = await post(Uri.parse(
        '${Connections.customerUrl}GetPIAgainstCustomer?custID=$custId'));

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

                  future: fetchAlbum(globals.custId, globals.projectId),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? Container(

                      height: 0,
                      width: 350,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text(
                              " ",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w700,
                                color: const Color(
                                    0xff333333),
                                height: 1,
                              ),
                            ),
                            Text(' ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w700,
                                color: const Color(
                                    0xff333333),
                                height: 1,
                              ),),
                          ]),
                    )
                        : Center(
                        child: Container());
                  }),
              FutureBuilder(
                  future: createLoginState(
                      globals.custId),
                  builder: (context, AsyncSnapshot snapshot) {


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
                              height: 240,
                              width: 400,
                              color: const Color(0xfff3f3f3),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Stack(children: <Widget>[
                                Pinned.fromPins(
                                  Pin(start: 16.1, end: 16.1),
                                  Pin(size: 220.0, end: 0.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Pinned.fromPins(
                                        Pin(size: 138.0, start: 50),
                                        Pin(size: 19.0, start: 0.0),
                                        child: Text(
                                          'PI No. : ' +
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
                                        Pin(size: 140.0, start: 50),
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
                                        Pin(size: 250.0, start: 50),
                                        Pin(size: 19.0, start: 85),
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
                                        Pin(size: 200.0, start: 50),
                                        Pin(size: 19.0, start: 115),
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
                                        Pin(size: 250.0, start: 50),
                                        Pin(size: 19.0, start: 145),
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
                                        Pin(size: 300.0, start: 50),
                                        Pin(size: 19.0, start: 175),
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
                                                text: 'ASM :',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w700,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                " ${snapshot.data[index].asm}",
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
                                        Pin(size: 140.0, end: 0.0),
                                        Pin(size: 20.0, start: 30),
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
                                        Pin(size: 140.0, end: 0.0),
                                        Pin(size: 20.0, start: 0),
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

                                      Pinned.fromPins(
                                        Pin(start: 0.0, end: 0.0),
                                        Pin(size: 1.0, start: 220),
                                        child: SvgPicture.string(
                                          _svg_ctuw2f,
                                          allowDrawingOutsideViewBox:
                                          true,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]));
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
    var list = data['taxInvoices'] as List;
    List<ProjectDetailData> resultList =
    list.map((e) => ProjectDetailData.fromJson(e)).toList();
    return Product(
      totalAmount: data['TotalAmount'] as String,
      results: resultList,
    );
  }
}

class ProformaData {
  final String number;
  final String date;
  final int quantity;
  final String product;
  final String amount;
  final String project;
  final String status;
  final String asm;
  final int revNo;
  final double sqm;

  ProformaData({
    required this.number,
    required this.date,
    required this.quantity,
    required this.product,
    required this.amount,
    required this.project,
    required this.status,
    required this.asm,
    required this.sqm,
    required this.revNo,

  });

  factory ProformaData.fromJson(Map<String, dynamic> data) {
    return ProformaData(
      number: data['DisplayPINo'] as String,
      date: data['DisplayPIDate'] as String,
      quantity: data['Qty'] as int,
      product: data['Product']?? " ",
      amount: data['DisplayAmount'] ?? " ",
      project: data['Project']?? " ",
      status: data['Status']?? " ",
      asm: data['SalesPerson'] ?? " ",
      sqm: data['SQM'] as double,
      revNo: data['RevisionNo'] as int,
    );
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
