package com.zinging.hobbystar.Notifications

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService

class MyFirebaseMessagingService : FirebaseMessagingService()
{
    override fun onNewToken(token: String) {
        Log.d("Tag", "The Token Refreshed: $token")
    }

}