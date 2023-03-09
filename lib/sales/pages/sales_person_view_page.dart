import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/theme.dart';
import '../../login.dart';
import '../../models/sales_person_model.dart';

class SalesPersonViewScreen extends StatefulWidget {
  const SalesPersonViewScreen({Key? key}) : super(key: key);

  @override
  State<SalesPersonViewScreen> createState() => _SalesPersonViewScreenState();
}

class _SalesPersonViewScreenState extends State<SalesPersonViewScreen> {

  List<String> personList = ["AMIT PATNURKAR", "JAISHIRI AMRALE","AMIT PATNURKAR", "JAISHIRI AMRALE"];

  List<SalesPerson> salesPersonLists =[];
  bool salesPersonLoader = false;


  @override
  void initState() {
    getSalesPersonData();
    super.initState();
  }

  getSalesPersonData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("_prefs.getInt('UserID') ${
        _prefs.getInt('UserID')
    }");
    print("Connection.getLocation URL========== > https://fgapi.digidisruptors.in/api/FGCRM/GetSalesPersonData?UserID=${_prefs.getInt('UserID')}");
    var response = await http.post(Uri.parse("https://fgapi.digidisruptors.in/api/FGCRM/GetSalesPersonData?UserID=${_prefs.getInt('UserID')}"));
    // var response = await http.post(Uri.parse("https://fgapi.digidisruptors.in/api/FGCRM/GetSalesPersonData?UserID=2"));
    // var results = json.decode(response.body);
    var result = json.decode(response.body);
    print('response == $result  ${response.body}');

    SalesPersonList salesPersonList;
    salesPersonList = (SalesPersonList.fromJson(result));

    // MarkLocationModel markLocationModel = MarkLocationModel.fromJson(results);
    setState(() {
      salesPersonLists = salesPersonList.salesPersonList;
      salesPersonLoader = true;
      print("getLocationsList  ===============> ${salesPersonLists.length}");
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Align(alignment: Alignment.center,
            child: const Text(' v1.0.4', style: const TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500),)),
        centerTitle: true, elevation: 2,
        title: Image.asset('assets/images/infinity.jpg', height: 36, fit: BoxFit.contain,),
        actions: [
          _logoutPopup(),
        ],
      ),
      body: salesPersonLoader == true?

      salesPersonLists.isNotEmpty?


      Padding(
        padding: const EdgeInsets.only(left: 12.0,right: 12,top: 20,bottom: 8),
        child: Column(children:  [

          Row(
            children: [
              Text("Sales Person Wise View", style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color:
                      AppColors.greyColor))),
              SizedBox(width: 5,),

              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.purpleColor,
                  borderRadius: BorderRadius.circular(8)
                ),
                child:  Center(
                  child: Text(salesPersonLists.length.toString(), style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color:
                          Colors.white))),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: salesPersonLists.map((salesPersonObj) {
                return     Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.purpleColor),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        children: [
                          Container(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(salesPersonObj.salesPersonName!, style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.whiteColor))),
                                  Text(salesPersonObj.salesAchievedPercent != null ?salesPersonObj.salesAchievedPercent!.toStringAsFixed(0)+"%":"0"+"%", style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.whiteColor))),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7),topRight: Radius.circular(7))
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0,right: 12),
                            child: Row(

                              children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Total Proforma", style: GoogleFonts.asul(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.whiteColor))),
                                  ),
                                ),

                              ),
                              Expanded(
                                flex: 8,
                                child: Text("${salesPersonObj.totalCount}",
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.asul(
                                    textStyle: const TextStyle(

                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyColor))),
                              )
                            ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 1.0,right: 12),
                            child: Row(

                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Closed Proforma", style: GoogleFonts.asul(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text("${salesPersonObj.closeCount} - ${salesPersonObj.closedPIPercent != null ?salesPersonObj.closedPIPercent!.toStringAsFixed(0)+"%":"0"+"%"}",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyColor))),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0,right: 12),
                            child: Row(

                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Open Proforma", style: GoogleFonts.asul(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text("${salesPersonObj.openCount} - ${salesPersonObj.openPIPercent != null ?salesPersonObj.openPIPercent!.toStringAsFixed(0)+"%":"0"+"%"}",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyColor))),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0,right: 12),
                            child: Row(

                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Cancelled Proforma", style: GoogleFonts.asul(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text("${salesPersonObj.cancelledCount} - ${salesPersonObj.cancelledPIPercent != null ?salesPersonObj.cancelledPIPercent!.toStringAsFixed(0)+"%":"0"+"%"}",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyColor))),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0,right: 12),
                            child: Row(

                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Sales Target", style: GoogleFonts.asul(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text("${salesPersonObj.salesTarget}",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyColor))),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0,right: 12),
                            child: Row(

                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleColor,
                                      // border: Border.all(color: AppColors.purpleColor)
                                    ),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Sales Archieved", style: GoogleFonts.asul(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Text("${salesPersonObj.salesAmount}",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.asul(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyColor))),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),),
            ),
          )


        ],),
      ):Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Center(
            child: Text("No data found!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
          )):Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Center(
            child: CircularProgressIndicator(),
          )),

    );
  }
  Widget _logoutPopup() {
    return PopupMenuButton<String>(
      onSelected: (option) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.clear();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
            LoginPage()), (Route<dynamic> route) => false);
      },
      itemBuilder: (BuildContext context) {
        return {'Logout'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice, child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
