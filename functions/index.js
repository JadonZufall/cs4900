const functions = require("firebase-functions");
const admin = require("firebase-admin");

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

admin.initializeApp();

import {
    onDocumentWritten,
    onDocumentCreated,
    onDocumentUpdated,
    onDocumentDeleted,
    Change,
    FirestoreEvent
} from "firebase-functions/v2/firestore";

exports.myfunction = onDocumentUpdated("Notifications/{docId}", (event) => {
    console.log(docId);
});
