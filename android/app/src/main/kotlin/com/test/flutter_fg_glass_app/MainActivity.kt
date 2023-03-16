package com.test.flutter_fg_glass_app

import android.app.NotificationManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onDestroy() {
        val mNotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        mNotificationManager.cancelAll()
        super.onDestroy()
    }
}
