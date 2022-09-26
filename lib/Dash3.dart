import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/DeliveryChallan.dart';
import 'package:flutter_fg_glass_app/DeliveryChallanFinal.dart';

import 'package:flutter_fg_glass_app/Orders.dart';
import 'package:flutter_fg_glass_app/PIDate.dart';
import 'package:flutter_fg_glass_app/OrdersPieChart.dart';
import 'package:flutter_fg_glass_app/ProformaFinal.dart';
import 'package:flutter_fg_glass_app/ProjectsFinal.dart';
import 'package:flutter_fg_glass_app/StatusTimeline.dart';
import 'package:flutter_fg_glass_app/TaxInvoiceFinal.dart';


class Dash3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(size: 93.0, start: 0.0),
          Pin(size: 25.0, start: 0.0),
          child: Text(
            'My Orders',
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
        Pinned.fromPins(
          Pin(size: 101.0, start: 0.0),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 40.0, start: 31.0),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Orders',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 90.0, start: 5.0),
          Pin(size: 90.0, middle: 0.28),
          child:
          // Adobe XD layer: 'box (1)' (shape)
          GestureDetector(
            onTap: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ctx) => Orders()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/08.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, end: 0.0),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 48.0, end: 26.0),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Projects',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 85.0, end: 7.0),
          Pin(size: 85.0, middle: 0.2863),
          child:
          // Adobe XD layer: 'schedule 2' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => ProjectsFinal()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/04.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, end: 0.0),
          Pin(size: 101.0, end: 0.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => StatusTimeline()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(361.0),
                color: const Color(0xfff3f3f3),
              ),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 52.0, end: 24.0),
        //   Pin(size: 30.0, end: 13.0),
        //   child: Text(
        //     'Status\nTimeline',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 89.0, end: 7.0),
          Pin(size: 78.0, middle: 0.95),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => StatusTimeline()));
            },
            // Adobe XD layer: 'timeline 2' (shape)
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/01.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, middle: 0.5019),
          Pin(size: 101.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 44.0, middle: 0.503),
        //   Pin(size: 30.0, end: 12.0),
        //   child: Text(
        //     'Tax\nInvoice',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 80.0, middle: 0.510),
          Pin(size: 80.0, end: 12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => TaxInvoiceFinal()));
            },
            // Adobe XD layer: 'ticket 2' (shape)
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/02.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, start: 0.0),
          Pin(size: 101.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 48.0, start: 27.0),
        //   Pin(size: 30.0, end: 12.0),
        //   child: Text(
        //     'Delivery\nChallan',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 80.0, start: 10.0),
          Pin(size: 80.0, end: 12.0),
          child:
          // Adobe XD layer: 'invoice 2' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => deliveryChallan()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/03.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, middle: 0.5019),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 56.0, middle: 0.5031),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Proforma',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //     TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Pinned.fromPins(
          Pin(size: 85.0, middle: 0.503),
          Pin(size: 85.0, middle: 0.298),
          child:
          // Adobe XD layer: 'google-forms' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => PIDate()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/05.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );










    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(size: 93.0, start: 0.0),
          Pin(size: 25.0, start: 0.0),
          child: Text(
            'My Orders',
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
        Pinned.fromPins(
          Pin(size: 101.0, start: 0.0),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 40.0, start: 31.0),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Orderss',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Positioned(
          top: 45,
          right: 250,
          child: GestureDetector(
            onTap: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ctx) => Orders()));
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/08.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, end: 0.0),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 48.0, end: 26.0),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Projects',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Positioned(
          top: 47,
          right: 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => ProjectsFinal()));
            },
            child: Container(
              height: 95,
              width: 95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/04.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, end: 0.0),
          Pin(size: 101.0, end: 0.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => StatusTimeline()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(361.0),
                color: const Color(0xfff3f3f3),
              ),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 52.0, end: 24.0),
        //   Pin(size: 30.0, end: 13.0),
        //   child: Text(
        //     'Status\nTimeline',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // Pinned.fromPins(
        //   Pin(size: 90.0, end: 0.0),
        //   Pin(size: 90.0, middle: 0.95),
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (BuildContext ctx) => StatusTimeline()));
        //     },
        //     // Adobe XD layer: 'timeline 2' (shape)
        //     child: Container(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: const AssetImage('assets/images/01.png'),
        //           fit: BoxFit.fill,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          top: 180,
          right: 12,

          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => StatusTimeline()));
            },
            // Adobe XD layer: 'timeline 2' (shape)
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/01.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, middle: 0.5019),
          Pin(size: 101.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 44.0, middle: 0.503),
        //   Pin(size: 30.0, end: 12.0),
        //   child: Text(
        //     'Tax\nInvoice',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Positioned(
          top: 175,
          right: 130,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => TaxInvoiceFinal()));
            },
            // Adobe XD layer: 'ticket 2' (shape)
            child: Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/02.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, start: 0.0),
          Pin(size: 101.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 48.0, start: 27.0),
        //   Pin(size: 30.0, end: 12.0),
        //   child: Text(
        //     'Delivery\nChallan',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Positioned(
          top: 175,
          right: 257,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => deliveryChallan()));
            },
            child: Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/03.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 101.0, middle: 0.5019),
          Pin(size: 101.0, middle: 0.2692),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(361.0),
              color: const Color(0xfff3f3f3),
            ),
          ),
        ),
        // Pinned.fromPins(
        //   Pin(size: 56.0, middle: 0.5031),
        //   Pin(size: 17.0, middle: 0.4685),
        //   child: Text(
        //     'Proforma',
        //     style: TextStyle(
        //       fontFamily: 'Poppins',
        //       fontSize: 12,
        //       color: const Color(0xff333333),
        //       fontWeight: FontWeight.w500,
        //       height: 1.0833333333333333,
        //     ),
        //     textHeightBehavior:
        //         TextHeightBehavior(applyHeightToFirstAscent: false),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Positioned(
          top: 49,
          right: 130,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => PIDate()));
            },
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/05.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
