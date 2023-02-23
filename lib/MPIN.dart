import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/sales/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adobe_xd/page_link.dart';
import './login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'globalVariables.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class MPIN extends StatefulWidget {
  @override
  _MPINState createState() => _MPINState();
}

bool mPinState = false;
bool _isLoading = false;

class _MPINState extends State<MPIN> {
  final TextEditingController _mPinController = TextEditingController();

  /*void navigationPage() {
    Navigator.of(context).pushReplacementNamed(MPIN);
  }
*/

  createLoginState(String emailId, String password, String mpin, String isMpin,
      String userId) async {
    final response = await post(
        Uri.parse(
            'https://fgapi.digidisruptors.in/api/CustomerAPI/ValidateLogin'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'EmailID': emailId,
          'Password': password,
          'MPIN': mpin,
          'IsMPIN': isMpin,
          'UserID': userId
        });

    if (response.statusCode == 200) {
      //print(response.body);
      //Navigator.pushNamed(context, DASHBOARD);


      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext ctx) => Dashboard()));

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => MyHome(salesView: false,)));
      var results = json.decode(response.body);
      //print('response == $results  ${response.body}');
      globals.custId = results['CustID'];
      print(results['CustID']);
      // return LoginResponse.fromJson(json.decode(response.body))
    } else {
     if (_mPinController.text == "") {
        Fluttertoast.showToast(
          msg: "Enter MPIN",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: " Enter Valid MPIN ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }

     setState(() {
        _isLoading = false;
      });

    throw Exception('Failed to create album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 35.0, end: 35.0),
            Pin(size: 52.0, middle: 0.6019),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xfff3f3f3),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 210.0, start: 57.0),
            Pin(size: 20.0, middle: 0.5982),
            child: TextField(
              controller: _mPinController,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              decoration: new InputDecoration.collapsed(
                  hintText: 'Enter MPIN Code',
                  hintStyle: new TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  )),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 15.8, end: 56.2),
            Pin(size: 16.9, middle: 0.5978),
            child:
            // Adobe XD layer: 'user' (group)
            Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 7.4, end: 0.0),
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
                              child: SvgPicture.string(
                                _svg_ija7sg,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 8.2, middle: 0.5),
                  Pin(size: 8.6, start: 0.0),
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
                              child: SvgPicture.string(
                                _svg_65f82d,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
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
          Pinned.fromPins(
            Pin(size: 198.0, start: 35.0),
            Pin(size: 25.0, middle: 0.5166),
            child: Text(
              'Login to your account',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: const Color(0xff333333),
                fontWeight: FontWeight.w600,
                height: 0.8888888888888888,
              ),
              textHeightBehavior:
              TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.left,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 36.0, end: 35.0),
            Pin(size: 60.0, end: 114.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  ease: Curves.easeInOut,
                  duration: 0.3,
                  //  pageBuilder: () => Dashboard(),
                ),
              ],
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
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              final id = prefs.getString('EmailID') ?? '';
                              final password = prefs.getString('Password') ??
                                  '';
                              final userIdSet = prefs.getInt('UserID') ?? '';
                              print(userIdSet);
                              prefs.setBool('MPIN', true);
                              setState(() {
                                _isLoading = true;
                                createLoginState(
                                    id,
                                    password,
                                    _mPinController.text,
                                    "true",
                                    userIdSet.toString());
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: LinearGradient(
                                  begin: Alignment(-0.87, 1.0),
                                  end: Alignment(0.81, -1.21),
                                  colors: [
                                    const Color(0xff00bfe7),
                                    const Color(0xff27a9e1)
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 67.0, middle: 0.5),
                          Pin(size: 25.0, middle: 0.5143),
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              final id = prefs.getString('EmailID') ?? '';
                              final password = prefs.getString('Password') ??
                                  '';
                              final userIdSet = prefs.getInt('UserID') ?? '';
                              print(userIdSet);
                              prefs.setBool('MPIN', true);
                              setState(() {
                                _isLoading = true;
                                createLoginState(
                                    id,
                                    password,
                                    _mPinController.text,
                                    "true",
                                    userIdSet.toString());
                              });
                            },
                            child: Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              height: 0.7222222222222222,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ) ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 42.0, middle: 0.3898),
            Pin(size: 23.0, end: 58.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  ease: Curves.easeInOut,
                  duration: 0.4,
                  pageBuilder: () => LoginPage(),
                ),
              ],
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: const Color(0xffc0c0c0),
                  height: 1,
                ),
                textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 45.0, middle: 0.5931),
            Pin(size: 23.0, end: 58.0),
            child: Text(
              'MPIN',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: const Color(0xff27a9e1),
                height: 1,
              ),
              textHeightBehavior:
              TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.left,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 37.5, middle: 0.5936),
            Pin(size: 1.0, end: 50.5),
            child: SvgPicture.string(
              _svg_zf1gds,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(start: -79.0, end: -79.0),
            Pin(size: 572.0, start: -251.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(425.0),
                gradient: LinearGradient(
                  begin: Alignment(-0.5, 0.83),
                  end: Alignment(0.69, -0.38),
                  colors: [const Color(0xff00bfe7), const Color(0xff27a9e1)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Container(
            height: 320,
              child: Center(child: Image.asset('assets/images/login head.png'))),
        ],
      ),
    );
  }
}


class LoginResponse {
  final int userId;
  final int custId;
  final String customer;

  LoginResponse({
    required this.userId,
    required this.custId,
    required this.customer,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['UserID'],
      custId: json['CustID'],
      customer: json['Customer'],
    );
  }
}

const String _svg_ija7sg =
    '<svg viewBox="0.0 0.0 15.8 7.4" ><path transform="translate(-17.44, -288.39)" d="M 25.32698059082031 288.3890075683594 C 20.24101066589355 288.3890075683594 17.44000244140625 290.7950439453125 17.44000244140625 295.1640014648438 C 17.44000244140625 295.5052185058594 17.71655654907227 295.7817687988281 18.05777549743652 295.7817687988281 L 32.59615325927734 295.7817687988281 C 32.9373779296875 295.7817687988281 33.21392822265625 295.5052185058594 33.21392822265625 295.1640014648438 C 33.21395874023438 290.7952575683594 30.4129524230957 288.3890075683594 25.32698059082031 288.3890075683594 Z M 18.69803047180176 294.5462036132812 C 18.9410285949707 291.2796020507812 21.16810035705566 289.6246032714844 25.32698059082031 289.6246032714844 C 29.48586273193359 289.6246032714844 31.71296691894531 291.2796020507812 31.9561653137207 294.5462036132812 L 18.69803047180176 294.5462036132812 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_65f82d =
    '<svg viewBox="0.0 0.0 8.2 8.6" ><path transform="translate(-132.05, 0.0)" d="M 136.1469268798828 0 C 133.8106842041016 0 132.0490112304688 1.797117829322815 132.0490112304688 4.180105686187744 C 132.0490112304688 6.632884502410889 133.8873138427734 8.62810230255127 136.1469268798828 8.62810230255127 C 138.4065246582031 8.62810230255127 140.2448425292969 6.63288402557373 140.2448425292969 4.180303573608398 C 140.2448425292969 1.797117829322815 138.4831695556641 0 136.1469268798828 0 Z M 136.1469268798828 7.392753601074219 C 134.5684967041016 7.392753601074219 133.2845611572266 5.951666831970215 133.2845611572266 4.180303573608398 C 133.2845611572266 2.474003791809082 134.4884033203125 1.235547184944153 136.1469268798828 1.235547184944153 C 137.7789001464844 1.235547184944153 139.0092926025391 2.501378059387207 139.0092926025391 4.180303573608398 C 139.0092926025391 5.951667308807373 137.725341796875 7.392753601074219 136.1469268798828 7.392753601074219 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_zf1gds =
    '<svg viewBox="223.5 844.5 37.5 1.0" ><path transform="translate(223.5, 844.5)" d="M 0 0 L 37.5 0" fill="none" stroke="#13b4e4" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
