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
        const notificationType =
          activeNotifications[activeNotifications.length - 1]["type"];
        const notificationSender =
          activeNotifications[activeNotifications.length - 1]["user"];
        let notificationMessage =
          activeNotifications[activeNotifications.length - 1]["message"];

        const senderUserDoc =
          await db.collection("Users").doc(notificationSender).get();

        const username = senderUserDoc.data()?.username;

        switch (notificationType) {
        case "message":
          notificationMessage = username + " said: " + notificationMessage;
          break;
        case "like":
          notificationMessage = username + " liked your post.";
          break;
        case "comment":
          notificationMessage = username +
            " commented on your post: " + notificationMessage;
          break;
        case "follow":
          notificationMessage = username + " began following you.";
          break;
        default:
          break;
        }

        console.log(notificationMessage);

        const message: admin.messaging.Message = {
          token: fcmToken,
          notification: {
            title: "Test Notification",
            body: notificationMessage,
          },
          data: {
            sender: notificationSender,
            type: notificationType,
          },
        };

        await admin.messaging().send(message);
      }
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
