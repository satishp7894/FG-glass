import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

import 'package:http/http.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_fg_glass_app/MPIN.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'globalVariables.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

bool mPin = false;
bool _isLoading = false;

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /*void navigationPage() {
    Navigator.of(context).pushReplacementNamed(MPIN);
  }
*/

  createLoginState(String emailId, String password, String isMpin) async {
    print("emailId $emailId");
    print("password $password");
    print("isMpin $isMpin");
    final response = await post(
      // old
      // Uri.parse('https://fgapi.digidisruptors.in/api/CustomerAPI/ValidateLogin'),

      // new
        Uri.parse('https://fgapi.digidisruptors.in/api/CustomerAPI/ValidateLoginUser'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'EmailID': emailId,
          'Password': password,
          'IsMPIN': isMpin
        });

    if (response.statusCode == 200) {
      print(response.body);

      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      if (results['UserID'] != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('UserID', results['UserID']);
        preferences.setInt('CustID', results['CustID']);
        if(results['Customer'] != null){
          preferences.setString('Customer', results['Customer']);
        }

      }
      Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext ctx) => MPIN()));
      print(results['CustID']);
      // globals.custId = response.body;
    } else {
      if (_emailController.text == "" || _passwordController.text == "") {
        Fluttertoast.showToast(
          msg: "Enter EmailID and password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: "EmailID or password is incorrect",
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
            Pin(start: -79.0, end: -79.0),
            Pin(size: 572.0, start: -251.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(425.0),
                gradient: LinearGradient(
                  begin: Alignment(-0.69, 0.83),
                  end: Alignment(0.7, -0.37),
                  colors: [const Color(0xff00bfe7), const Color(0xff27a9e1)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 35.0, end: 35.0),
            Pin(size: 52.0, middle: 0.5877),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xfff3f3f3),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 185.0, start: 57.0),
            Pin(size: 20.0, middle: 0.5845),
            child: TextField(
              controller: _emailController,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              decoration: new InputDecoration.collapsed(
                  hintText: 'Email',
                  hintStyle: new TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  )),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 15.8, end: 56.2),
            Pin(size: 16.9, middle: 0.5842),
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
            Pin(start: 35.0, end: 35.0),
            Pin(size: 52.0, middle: 0.6894),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xfff3f3f3),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 185.0, start: 57.0),
            Pin(size: 20.0, middle: 0.681),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              decoration: new InputDecoration.collapsed(
                  hintText: 'Password',
                  hintStyle: new TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  )),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 13.7, end: 56.3),
            Pin(size: 11.4, middle: 0.6798),
            child: SvgPicture.string(
              _svg_xto71w,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 9.1, end: 58.6),
            Pin(size: 8.0, middle: 0.6682),
            child: SvgPicture.string(
              _svg_otsjf7,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 3.0, end: 61.6),
            Pin(size: 3.0, middle: 0.6757),
            child: SvgPicture.string(
              _svg_tjl416,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 1.1, end: 62.6),
            Pin(size: 3.2, middle: 0.6651),
            child: SvgPicture.string(
              _svg_4vmjxb,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 198.0, start: 35.0),
            Pin(size: 25.0, middle: 0.504),
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
            Pin(size: 125.0, start: 35.0),
            Pin(size: 20.0, middle: 0.7418),
            child: Text(
              'Forgot password?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: const Color(0xffc0c0c0),
                height: 1.1428571428571428,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.left,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 36.0, end: 35.0),
            Pin(size: 60.0, end: 101.0),
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('EmailID', _emailController.text);
                prefs.setString('Password', _passwordController.text);
                prefs.setBool('MPIN', mPin);

                setState(() {
                  _isLoading = true;
                  createLoginState(
                      _emailController.text, _passwordController.text, "false");
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    begin: Alignment(-0.87, 1.0),
                    end: Alignment(0.81, -1.21),
                    colors: [const Color(0xff00bfe7), const Color(0xff27a9e1)],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
              Pin(size: 54.0, middle: 0.5028), Pin(size: 25.0, end: 118.0),
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('EmailID', _emailController.text);
                  prefs.setString('Password', _passwordController.text);
                  prefs.setBool('MPIN', mPin);

                  setState(() {
                    _isLoading = true;
                    createLoginState(_emailController.text,
                        _passwordController.text, "false");
                  });
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                    height: 0.7222222222222222,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              )),
          Pinned.fromPins(
            Pin(size: 45.0, middle: 0.3898),
            Pin(size: 23.0, end: 65.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  ease: Curves.easeInOut,
                  duration: 0.3,
                  // pageBuilder: () => MPIN(),
                ),
              ],
              child: Text(
                'Login',
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
          ),
          Pinned.fromPins(
            Pin(size: 45.0, middle: 0.5931),
            Pin(size: 23.0, end: 65.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  ease: Curves.easeInOut,
                  duration: 0.4,
                  pageBuilder: () => MPIN(),
                ),
              ],
              child: Text(
                'MPIN',
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
            Pin(size: 42.0, middle: 0.3911),
            Pin(size: 1.0, end: 57.5),
            child: SvgPicture.string(
              _svg_wik914,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          // Pinned.fromPins(
          //   Pin(size: 245.0, middle: 0.503),
          //   Pin(size: 93.9, middle: 0.1782),
          //   child: Stack(
          //     children: <Widget>[
          //       Pinned.fromPins(
          //         Pin(start: 0.0, end: 0.0),
          //         Pin(start: 0.0, end: 0.0),
          //         child: Stack(
          //           children: <Widget>[
          //             Pinned.fromPins(
          //               Pin(start: 0.0, end: 0.0),
          //               Pin(start: 0.0, end: 0.0),
          //               child: Stack(
          //                 children: <Widget>[
          //                   Container(
          //                       child: Image.asset(
          //                           'assets/images/login head.png')),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
      userId: json['UserID'] as int,
      custId: json['CustID'] as int,
      customer: json['Customer'] as String,
    );
  }
}

const String _svg_ija7sg =
    '<svg viewBox="0.0 0.0 15.8 7.4" ><path transform="translate(-17.44, -288.39)" d="M 25.32698059082031 288.3890075683594 C 20.24101066589355 288.3890075683594 17.44000244140625 290.7950439453125 17.44000244140625 295.1640014648438 C 17.44000244140625 295.5052185058594 17.71655654907227 295.7817687988281 18.05777549743652 295.7817687988281 L 32.59615325927734 295.7817687988281 C 32.9373779296875 295.7817687988281 33.21392822265625 295.5052185058594 33.21392822265625 295.1640014648438 C 33.21395874023438 290.7952575683594 30.4129524230957 288.3890075683594 25.32698059082031 288.3890075683594 Z M 18.69803047180176 294.5462036132812 C 18.9410285949707 291.2796020507812 21.16810035705566 289.6246032714844 25.32698059082031 289.6246032714844 C 29.48586273193359 289.6246032714844 31.71296691894531 291.2796020507812 31.9561653137207 294.5462036132812 L 18.69803047180176 294.5462036132812 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_65f82d =
    '<svg viewBox="0.0 0.0 8.2 8.6" ><path transform="translate(-132.05, 0.0)" d="M 136.1469268798828 0 C 133.8106842041016 0 132.0490112304688 1.797117829322815 132.0490112304688 4.180105686187744 C 132.0490112304688 6.632884502410889 133.8873138427734 8.62810230255127 136.1469268798828 8.62810230255127 C 138.4065246582031 8.62810230255127 140.2448425292969 6.63288402557373 140.2448425292969 4.180303573608398 C 140.2448425292969 1.797117829322815 138.4831695556641 0 136.1469268798828 0 Z M 136.1469268798828 7.392753601074219 C 134.5684967041016 7.392753601074219 133.2845611572266 5.951666831970215 133.2845611572266 4.180303573608398 C 133.2845611572266 2.474003791809082 134.4884033203125 1.235547184944153 136.1469268798828 1.235547184944153 C 137.7789001464844 1.235547184944153 139.0092926025391 2.501378059387207 139.0092926025391 4.180303573608398 C 139.0092926025391 5.951667308807373 137.725341796875 7.392753601074219 136.1469268798828 7.392753601074219 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_xto71w =
    '<svg viewBox="344.0 588.7 13.7 11.4" ><path transform="translate(341.0, 579.67)" d="M 14.9571361541748 20.38774871826172 L 4.708162307739258 20.38774871826172 C 3.766775131225586 20.38774871826172 3 19.62173271179199 3 18.67958641052246 L 3 10.70816230773926 C 3 9.766016006469727 3.766775131225586 9 4.708162307739258 9 L 14.9571361541748 9 C 15.89852237701416 9 16.66529846191406 9.766016006469727 16.66529846191406 10.70816230773926 L 16.66529846191406 18.67958641052246 C 16.66529846191406 19.62173271179199 15.89852237701416 20.38774871826172 14.9571361541748 20.38774871826172 Z M 4.708162307739258 10.13877487182617 C 4.394619464874268 10.13877487182617 4.138774871826172 10.39386081695557 4.138774871826172 10.70816230773926 L 4.138774871826172 18.67958641052246 C 4.138774871826172 18.99388694763184 4.394619464874268 19.24897384643555 4.708162307739258 19.24897384643555 L 14.9571361541748 19.24897384643555 C 15.27067852020264 19.24897384643555 15.52652359008789 18.99388694763184 15.52652359008789 18.67958641052246 L 15.52652359008789 10.70816230773926 C 15.52652359008789 10.39386081695557 15.27067852020264 10.13877487182617 14.9571361541748 10.13877487182617 L 4.708162307739258 10.13877487182617 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_otsjf7 =
    '<svg viewBox="346.3 582.0 9.1 8.0" ><path transform="translate(340.28, 582.0)" d="M 14.54081153869629 7.971424102783203 C 14.2265100479126 7.971424102783203 13.9714241027832 7.716338157653809 13.9714241027832 7.402036666870117 L 13.9714241027832 4.555099487304688 C 13.9714241027832 2.671565771102905 12.43863296508789 1.138774871826172 10.55509948730469 1.138774871826172 C 8.671566009521484 1.138774871826172 7.138774871826172 2.671565771102905 7.138774871826172 4.555099487304688 L 7.138774871826172 7.402036666870117 C 7.138774871826172 7.716338157653809 6.883689403533936 7.971424102783203 6.569387435913086 7.971424102783203 C 6.255085468292236 7.971424102783203 6 7.716338157653809 6 7.402036666870117 L 6 4.555099487304688 C 6 2.042962074279785 8.042962074279785 0 10.55509948730469 0 C 13.06723690032959 0 15.11019897460938 2.042962074279785 15.11019897460938 4.555099487304688 L 15.11019897460938 7.402036666870117 C 15.11019897460938 7.716338157653809 14.85511302947998 7.971424102783203 14.54081153869629 7.971424102783203 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_tjl416 =
    '<svg viewBox="349.3 591.8 3.0 3.0" ><path transform="translate(339.31, 578.76)" d="M 11.51836681365967 16.0367317199707 C 10.68098735809326 16.0367317199707 10 15.35574626922607 10 14.51836681365967 C 10 13.68098735809326 10.68098735809326 13 11.51836681365967 13 C 12.35574531555176 13 13.03673267364502 13.68098735809326 13.03673267364502 14.51836681365967 C 13.03673267364502 15.35574626922607 12.35574531555176 16.0367317199707 11.51836681365967 16.0367317199707 Z M 11.51836681365967 14.13877487182617 C 11.30959129333496 14.13877487182617 11.13877487182617 14.3088321685791 11.13877487182617 14.51836681365967 C 11.13877487182617 14.72790145874023 11.30959129333496 14.89795780181885 11.51836681365967 14.89795780181885 C 11.72714138031006 14.89795780181885 11.89795780181885 14.72790145874023 11.89795780181885 14.51836681365967 C 11.89795780181885 14.3088321685791 11.72714138031006 14.13877487182617 11.51836681365967 14.13877487182617 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_4vmjxb =
    '<svg viewBox="350.3 593.8 1.1 3.2" ><path transform="translate(339.01, 578.07)" d="M 11.81938743591309 18.97652816772461 C 11.50508594512939 18.97652816772461 11.25 18.72144317626953 11.25 18.40714073181152 L 11.25 16.31938743591309 C 11.25 16.00508499145508 11.50508594512939 15.75 11.81938743591309 15.75 C 12.13368892669678 15.75 12.38877487182617 16.00508499145508 12.38877487182617 16.31938743591309 L 12.38877487182617 18.40714073181152 C 12.38877487182617 18.72144317626953 12.13368892669678 18.97652816772461 11.81938743591309 18.97652816772461 Z" fill="#5f5f5f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_wik914 =
    '<svg viewBox="145.5 827.5 42.0 1.0" ><path transform="translate(145.5, 827.45)" d="M 0 0 L 42 0" fill="none" stroke="#13b4e4" stroke-width="2" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
