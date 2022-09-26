import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/DeliveryChallan.dart';
import 'package:flutter_fg_glass_app/DeliveryChallanFinal.dart';
import 'package:flutter_fg_glass_app/Deliveryschedule.dart';
import 'package:flutter_fg_glass_app/IssueRaised.dart';

import 'package:flutter_fg_glass_app/Orders.dart';
import 'package:flutter_fg_glass_app/ProformaFinal.dart';
import 'package:flutter_fg_glass_app/ProjectsFinal.dart';
import 'package:flutter_fg_glass_app/QualityComplaint.dart';
import 'package:flutter_fg_glass_app/StatusTimeline.dart';
import 'package:flutter_fg_glass_app/TaxInvoiceFinal.dart';


class Dash31 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

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
        //   Pin(size: 60.0, start: 22.0),
        //   Pin(size: 40.0, end: 30),
        //   child: Text(
        //     'Delivery\nSchedule',
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
          Pin(size: 82.0, start: 10.0),
          Pin(size: 82.0, middle: 0.284),
          child:
          // Adobe XD layer: 'box (1)' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ctx) => DeliverySchedule()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/06.png'),
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
        Pinned.fromPins(
          Pin(size: 48.0, end: 26.0),
          Pin(size: 35.0, end: 42),
          child: Text(
            'Issue\n Raised',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: const Color(0xff333333),
              fontWeight: FontWeight.w400,
              height: 1.0833333333333333,
            ),
            textHeightBehavior:
            TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
        ),
        Pinned.fromPins(
          Pin(size: 48.0, end: 26.0),
          Pin(size: 48.0, middle: 0.2500),
          child:
          // Adobe XD layer: 'schedule 2' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => IssueRaised()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/projects.png'),
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
        //   Pin(size: 62.0, middle: 0.5031),
        //   Pin(size: 40.0, end: 30),
        //   child: Text(
        //     'Quality\nComplaint',
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
          Pin(size: 82.0, middle: 0.503),
          Pin(size: 82.0, middle: 0.298),
          child:
          // Adobe XD layer: 'google-forms' (shape)
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => QualityComplaint()));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/07.png'),
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

// class Dash31 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//
//         Pinned.fromPins(
//           Pin(size: 101.0, start: 0.0),
//           Pin(size: 101.0, middle: 0.2692),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(361.0),
//               color: const Color(0xfff3f3f3),
//             ),
//           ),
//         ),
//         // Pinned.fromPins(
//         //   Pin(size: 60.0, start: 22.0),
//         //   Pin(size: 40.0, end: 30),
//         //   child: Text(
//         //     'Delivery\nSchedule',
//         //     style: TextStyle(
//         //       fontFamily: 'Poppins',
//         //       fontSize: 12,
//         //       color: const Color(0xff333333),
//         //       fontWeight: FontWeight.w500,
//         //       height: 1.0833333333333333,
//         //     ),
//         //     textHeightBehavior:
//         //     TextHeightBehavior(applyHeightToFirstAscent: false),
//         //     textAlign: TextAlign.center,
//         //   ),
//         // ),
//         Positioned(
//           top: 18,
//           right: 257,
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (BuildContext ctx) => DeliverySchedule()));
//             },
//             child: Container(
//               height: 82,
//               width: 82,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: const AssetImage('assets/images/06.png'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Pinned.fromPins(
//           Pin(size: 101.0, end: 0.0),
//           Pin(size: 101.0, middle: 0.2692),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(361.0),
//               color: const Color(0xfff3f3f3),
//             ),
//           ),
//         ),
//         Pinned.fromPins(
//           Pin(size: 48.0, end: 26.0),
//           Pin(size: 35.0, end: 35),
//           child: Text(
//             'Issue\n Raised',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 12,
//               color: const Color(0xff333333),
//               fontWeight: FontWeight.w500,
//               height: 1.0833333333333333,
//             ),
//             textHeightBehavior:
//             TextHeightBehavior(applyHeightToFirstAscent: false),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Pinned.fromPins(
//           Pin(size: 48.0, end: 26.0),
//           Pin(size: 48.0, middle: 0.2863),
//           child:
//           // Adobe XD layer: 'schedule 2' (shape)
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext ctx) => IssueRaised()));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: const AssetImage('assets/images/projects.png'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         Pinned.fromPins(
//           Pin(size: 101.0, middle: 0.5019),
//           Pin(size: 101.0, middle: 0.2692),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(361.0),
//               color: const Color(0xfff3f3f3),
//             ),
//           ),
//         ),
//         // Pinned.fromPins(
//         //   Pin(size: 62.0, middle: 0.5031),
//         //   Pin(size: 40.0, end: 30),
//         //   child: Text(
//         //     'Quality\nComplaint',
//         //     style: TextStyle(
//         //       fontFamily: 'Poppins',
//         //       fontSize: 12,
//         //       color: const Color(0xff333333),
//         //       fontWeight: FontWeight.w500,
//         //       height: 1.0833333333333333,
//         //     ),
//         //     textHeightBehavior:
//         //     TextHeightBehavior(applyHeightToFirstAscent: false),
//         //     textAlign: TextAlign.center,
//         //   ),
//         // ),
//         Pinned.fromPins(
//           Pin(size: 80.0, start: 10.0),
//           Pin(size: 80.0, end: 12.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext ctx) => QualityComplaint()));
//             },
//             child: Container(
//               height: 82,
//               width: 82,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: const AssetImage('assets/images/07.png'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
