import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_fg_glass_app/Dashboard.dart';

import 'package:http/http.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_fg_glass_app/MPIN.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DeliveryChallanFinal.dart';
import 'Deliveryschedule.dart';
import 'Orders.dart';
import 'PIDate.dart';
import 'ProjectsFinal.dart';
import 'QualityComplaint.dart';
import 'StatusTimeline.dart';
import 'TaxInvoiceFinal.dart';
import 'globalVariables.dart' as globals;
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';

class IssueRaised extends StatefulWidget {
  @override
  IssueRaisedState createState() => IssueRaisedState();
}

bool mPin = false;
bool _isLoading = false;

class IssueRaisedState extends State<IssueRaised> {
  late String selectedSpinnerItem = "NA";
  late var selectedId;
  int id = 0;
  List data = [];
  late Future myFuture;
  late String formattedDate;
  bool _validate = false;

  fetchData() async {
    var response = await post(
      Uri.parse(
          'https://fgapi.digidisruptors.in/api/CustomerAPI/GetIssueCategory'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);

      setState(() {
        data = resBody;
      });

      print('Loaded Successfully');

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  void initState() {
    myFuture = fetchData();
    super.initState();
    setState(() {
      DateTime now = DateTime.now();
      formattedDate = DateFormat('dd-MMM-yyyy').format(now);
      print(formattedDate);
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  createLoginState(String categoryId, String desc, String custId) async {
    final response = await post(
        Uri.parse(
            'https://fgapi.digidisruptors.in/api/CustomerAPI/AddCustomerIssue'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'CategoryID': categoryId,
          'Description': desc,
          'CustID': custId
        });

    if (response.statusCode == 200) {
      print(response.body);

      var results = json.decode(response.body);

      print(results['Message']);
      Fluttertoast.showToast(
        msg: results['Message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      // globals.custId = response.body;
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                  height: 100,
                  width: 120,
                  child: InkWell(
                      onTap: () {
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
            child: Drawer(
              backgroundColor: Color(0xff0b8bc2),
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                      trailing: Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/OrdersNav.png',
                        height: 50,
                        width: 50,
                      ),
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
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/DC.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    deliveryChallan()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/TI.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    TaxInvoiceFinal()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ProformaNav.png',
                        height: 50,
                        width: 50,
                      ),
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
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ProjectsNav.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    ProjectsFinal()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ST.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    StatusTimeline()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ProjectsNav.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    DeliverySchedule()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ProformaNav.png',
                        height: 50,
                        width: 50,
                      ),
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
                                builder: (BuildContext ctx) =>
                                    QualityComplaint()));
                      }),
                  ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                      leading: Image.asset(
                        'assets/images/ST.png',
                        height: 50,
                        width: 50,
                      ),
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
                      }),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 60, horizontal: 48),
                    leading: Image.asset(
                      'assets/images/logout.png',
                      height: 20,
                      width: 20,
                    ),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  'Issue Raised',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w900,
                    height: 0.65,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            color: const Color(0xff333333),
                            height: 2.0625,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                          height: 40,
                          width: 200,
                          child: Text(formattedDate,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: const Color(0xff333333),
                                height: 2.0625,
                              )))
                    ],
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            color: const Color(0xff333333),
                            height: 2.0625,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        height: 40,
                        width: 200,
                        child: DropdownButton(
                          isExpanded: true,
                          items: data.map((item) {
                            return DropdownMenuItem(
                              onTap: () {
                                id = item['CategoryID'];
                              },
                              //

                              child: Text(item['Category']),
                              value: item['Category'],
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selectedId = id;
                              print(selectedId);
                              selectedSpinnerItem = newVal.toString();
                            });
                          },
                          value: selectedSpinnerItem,
                        ),
                      )
                    ],
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Description",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            color: const Color(0xff333333),
                            height: 2.0625,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                          height: 65,
                          width: 200,
                          child: TextField(
                            maxLines: 3,
                            controller: _emailController,
                            decoration: InputDecoration(
                              //labelText: 'Enter the Value',
                              errorText: _validate
                                  ? 'Description Can\'t Be Empty'
                                  : null,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontSize: 16,
                            ),
                          ))
                    ],
                  )),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(top: 100),
                child: RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    setState(() {
                      _emailController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });

                    createLoginState(selectedId.toString(), _emailController.text,
                        globals.custId.toString());
                    // sendMail();
                  },
                  color: const Color(0xff00bfe7),
                  textColor: Colors.white,
                  child: Text("Save",
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        ));
  }

  Future sendMail() async {
    final email = 'manisha.intelidemics@gmail.com';
    final smtpServer = gmail(email, 'manisha@123');
    final message = Message()
      ..from = Address(email, 'Manisha')
      ..recipients = ['manisha@digidisruptors.com']
      ..subject = 'Test Email'
      ..text = 'Hello Manisha. This is test mail';
    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print(e);
    }
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
