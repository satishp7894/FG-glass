import 'package:flutter/material.dart';
import 'package:flutter_fg_glass_app/sales/pages/records_page.dart';
import '../../utils/apptheme.dart';
import 'map_page.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () {
          // Alerts.showExitAlert(context);
          return Future.value(true);
        },
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MapPage(),
              TravelRecordsPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TabBar(
        labelColor: AppTheme.accentColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
            text: "Home",
            iconMargin: const EdgeInsets.only(bottom: 0),
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "Records",
            iconMargin: const EdgeInsets.only(bottom: 0),
            icon: Icon(Icons.assignment),
          ),
        ],
      ),
    );
  }
}
