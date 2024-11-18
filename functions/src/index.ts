/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onDocumentUpdated} from "firebase-functions/v2/firestore";
// import {getFirestore} from "firebase-admin/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// Trigger this function when any document in
// 'Notifications' is onDocumentUpdated
export const sendNotification = onDocumentUpdated(
  "Notifications/{docId}",
  async (event) => {
    const userId = event.params.docId;

    try {
      const userDoc = await db.collection("Users").doc(userId).get();

      if (!userDoc.exists) {
        console.error("No user with ID: ${userId}");
        return;
      } else {
        console.log("Sending Notification to ${userId}");
      }

      const fcmToken = userDoc.data()?.device_token;

      if (!fcmToken) {
        console.error("User with ID ${userId} has no FCM token attached to it");
      } else {
        console.log("FCM Token: ${fcmToken}");
      }

      const notificationDoc = await db.collection("Notifications")
        .doc(userId)
        .get();

      if (!notificationDoc.exists) {
        console.error("Notification doc does not exist");
      } else {
        const activeNotifications = notificationDoc.data()?.ActiveNotifications;
        // const notificationType = notificationDoc.data()?.type;
        // const sender = notificationDoc.data()?.user;
        const notificationMessage =
          activeNotifications[activeNotifications.length - 1]["message"];

        console.log(notificationMessage);

        const message: admin.messaging.Message = {
          token: fcmToken,
          notification: {
            title: "Test Notification",
            body: notificationMessage,
          },
        };

        await admin.messaging().send(message);
      }
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
