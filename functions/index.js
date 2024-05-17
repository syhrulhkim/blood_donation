const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotifications = functions.https.onRequest(async (req, res) => {
    const { tokens, message } = req.body;

    const payload = {
        notification: {
        title: "New Notification",
        body: message,
        },
        tokens: tokens,
    };

    try {
        const response = await admin.messaging().sendMulticast(payload);
        res.status(200).send(`${response.successCount} messages were sent successfully`);
    } catch (error) {
        console.error("Error sending message:", error);
        res.status(500).send("Error sending notifications");
    }
});
