import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/blend_mask.dart';
import 'package:url_launcher/url_launcher.dart';

class Dash4Carou2 extends StatelessWidget {
  _launchSocialURLApp() async {
    const url = 'https://www.fgglass.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(start: 0.0, end: 0.0),
          Pin(start: 0.0, end: 0.0),
          child: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 0.0, end: 0.0),
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(start: 0.0, end: 0.0),
                      child:
                          // Adobe XD layer: 'coloured-glass-1562…' (shape)
                          Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image:
                                const AssetImage('assets/images/Dash4Car2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(start: 0.0, end: 0.0),
                      child: BlendMask(
                        blendMode: BlendMode.multiply,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0x80000000),
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 20.0, end: 16.0),
                      Pin(start: 19.0, end: 20.0),
                      child: Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 2.0),
                            Pin(size: 44.0, start: 0.0),
                            child: Text(
                              'Want to give more creative look to\nyour infrastructure?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w600,
                                height: 1.1764705882352942,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 53.0, middle: 0.6944),
                            child: Text(
                              'VANCEVA COLOURED GLASS will give a new modern look to your infrastructure.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: const Color(0xffffffff),
                                height: 1.2142857142857142,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 99.0, start: 0.0),
                            Pin(size: 29.0, end: 0.0),
                            child: Stack(
                              children: <Widget>[
                                Pinned.fromPins(
                                  Pin(start: 0.0, end: 0.0),
                                  Pin(start: 0.0, end: 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(149.0),
                                      border: Border.all(
                                          width: 1.0,
                                          color: const Color(0xffffffff)),
                                    ),
                                  ),
                                ),
                                Pinned.fromPins(Pin(size: 69.0, middle: 0.5),
                                    Pin(size: 19.0, end: 4.0),
                                    child: InkWell(
                                      onTap: _launchSocialURLApp,
                                      child: Text(
                                        'Read More',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          color: const Color(0xffffffff),
                                          height: 1.3846153846153846,
                                        ),
                                        textHeightBehavior: TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                        textAlign: TextAlign.left,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
