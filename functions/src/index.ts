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
// const db = getFirestore();

// Trigger this function when any document in
// 'Notifications' is onDocumentUpdated
export const sendNotification = onDocumentUpdated(
  "Notifications/{userId}",
  async (event) => {
    console.log(event.params.userId);
  });
