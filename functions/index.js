const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendAppointmentNotification = functions.firestore
    .document("appointments/{id}")
    .onUpdate(async (change, context) => {
      const before = change.before.data();
      const after = change.after.data();

      // only trigger when status changes to approved
      if (before.status === after.status) return null;
      if (after.status !== "approved") return null;

      const patientId = after.patientId;

      // get user notification data
      const userDoc = await admin.firestore()
          .collection("usersNotification")
          .doc(patientId)
          .get();

      if (!userDoc.exists) {
        console.log("User not found");
        return null;
      }

      const data = userDoc.data();
      const token = data.fcmToken;
      const enabled = data.notificationsEnabled;

      if (!token || enabled === false) {
        console.log("Notification disabled or token missing");
        return null;
      }

      const message = {
        token: token,
        notification: {
          title: "Appointment Approved ✅",
          body: "Doctor approved your appointment",
        },
        data: {
          screen: "appointments",
        },
      };

      await admin.messaging().send(message);

      console.log("Notification sent successfully");

      return null;
    });
