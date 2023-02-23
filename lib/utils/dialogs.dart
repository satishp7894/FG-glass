import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 21,),
                    Text("Please Wait....",style: TextStyle(fontSize: 20,
                        color: Colors.black87, fontWeight: FontWeight.w600),)
                ]),
              )
            ]));
      });
  }
}