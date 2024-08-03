package com.creator.chore_app

import android.content.Intent
import android.os.Bundle
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.creator.chore_app.services.DeviceInstallationService
import com.creator.chore_app.services.NotificationActionService
import com.creator.chore_app.services.NotificationRegistrationService
import com.creator.chore_app.services.PushNotificationsFirebaseMessagingService
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private lateinit var deviceInstallationService: DeviceInstallationService

    private fun processNotificationActions(intent: Intent, launchAction: Boolean = false) {
        if (intent.hasExtra("action")) {
            val action = intent.getStringExtra("action") ?: "" // Handle null case

            if (action.isNotEmpty()) {
                if (launchAction) {
                    PushNotificationsFirebaseMessagingService.notificationActionService?.launchAction = action
                } else {
                    PushNotificationsFirebaseMessagingService.notificationActionService?.triggerAction(action)
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        processNotificationActions(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.let {
            deviceInstallationService = DeviceInstallationService(context, it)
            PushNotificationsFirebaseMessagingService.notificationActionService = NotificationActionService(it)
            PushNotificationsFirebaseMessagingService.notificationRegistrationService = NotificationRegistrationService(it)
        }

        if (deviceInstallationService.playServicesAvailable) {
            FirebaseMessaging.getInstance().token
                .addOnCompleteListener(OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        return@OnCompleteListener
                    }

                    PushNotificationsFirebaseMessagingService.token = task.result
                    PushNotificationsFirebaseMessagingService.notificationRegistrationService?.refreshRegistration()
                })
        }
        processNotificationActions(this.intent, true)
    }
}
