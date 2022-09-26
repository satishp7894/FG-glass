import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class Dash2Carou1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(start: 0.0, end: 0.0),
          Pin(start: 0.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                begin: Alignment(-0.57, 1.18),
                end: Alignment(1.0, -1.07),
                colors: [const Color(0xff00bfe7), const Color(0xff27a9e1)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 66.0, start: 16.0),
          Pin(size: 66.0, start: 18.0),
          child:
              // Adobe XD layer: 'delivery-box' (shape)
              Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/dash1.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 90.0, start: 16.0),
          Pin(size: 26.0, end: 18.0),
          child: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 0.0, end: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(start: 9.0, end: 9.0),
                Pin(size: 17.0, middle: 0.5556),
                child: Text(
                  'View Details',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: const Color(0xff333333),
                    height: 1.4166666666666667,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Pinned.fromPins(
          Pin(size: 153.0, middle: 0.65),
          Pin(size: 50.0, start: 15.0),
          child: Text(
            'Your order is\nready to ship',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          ),
        ),
        Pinned.fromPins(
          Pin(size: 200.0, end: 21.0),
          Pin(size: 80.0, middle: 0.891),
          child: SingleChildScrollView(
              child: Text(
            '',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: const Color(0xffffffff),
              height: 1.3076923076923077,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.left,
          )),
        ),
      ],
    );
  }
}
