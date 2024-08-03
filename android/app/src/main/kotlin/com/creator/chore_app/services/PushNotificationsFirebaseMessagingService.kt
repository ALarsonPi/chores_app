package com.creator.chore_app.services

import android.os.Handler
import android.os.Looper
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.creator.chore_app.services.NotificationActionService
import com.creator.chore_app.services.NotificationRegistrationService

class PushNotificationsFirebaseMessagingService : FirebaseMessagingService() {

    companion object {
        var token: String? = null
        var notificationRegistrationService : NotificationRegistrationService? = null
        var notificationActionService : NotificationActionService? = null
    }

    override fun onNewToken(token: String) {
        PushNotificationsFirebaseMessagingService.token = token
        notificationRegistrationService?.refreshRegistration()
    }

    override fun onMessageReceived(message: RemoteMessage) {
        message.data.let {
            Handler(Looper.getMainLooper()).post {
                notificationActionService?.triggerAction(it.getOrDefault("action", null))
            }
        }
    }
}