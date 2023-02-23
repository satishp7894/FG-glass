import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alerts {

  static showAlert(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showAlertAndBack(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                Navigator.pop(context, true);
              },
            ),
          ],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // static showExitAlert(BuildContext context) {
  //   showDialog(context: context,
  //     builder: (BuildContext c) {
  //       return Platform.isIOS ? CupertinoAlertDialog(
  //         title: Text('Alert'),
  //         content: Text('Are you sure. You want to close the app'),
  //         actions: <Widget>[
  //           CupertinoButton(
  //             child: Text("Cancel", style: TextStyle(color: Colors.red),),
  //             onPressed: () {
  //               Navigator.of(c).pop();
  //             },
  //           ),
  //           CupertinoButton(
  //             child: Text("Close", style: TextStyle(color: Colors.red),),
  //             onPressed: () {
  //               Navigator.of(c).pop();
  //               MinimizeApp.minimizeApp();
  //             },
  //           ),
  //         ],
  //       ) : AlertDialog(
  //         title: Text('Alert'),
  //         content: Text('Are you sure. You want to close the app'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Cancel", style: TextStyle(color: Colors.red),),
  //             onPressed: () {
  //               Navigator.of(c).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text("Close", style: TextStyle(color: Colors.red),),
  //             onPressed: () {
  //               Navigator.of(c).pop();
  //               MinimizeApp.minimizeApp();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static showRecordStopAlert(BuildContext context, Function action) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to stop recording?'),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            CupertinoButton(
              child: Text("Stop", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                action();
              },
            ),
          ],
        ) : AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to stop recording?'),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            TextButton(
              child: Text("Stop", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                action();
              },
            ),
          ],
        );
      },
    );
  }

  static showAlertSettings(BuildContext context, Function action) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please allow app to access location from settings.'),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            CupertinoButton(
              child: Text("Open Settings", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                action();
              },
            ),
          ],
        ) : AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please allow app to access location from settings.'),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
            TextButton(
              child: Text("Open Settings", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(c).pop();
                action();
              },
            ),
          ],
        );
      },
    );
  }

}

