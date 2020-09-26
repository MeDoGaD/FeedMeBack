const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);
exports.orderTrigger = functions.firestore.document('orders/{orderId}').onCreate
(
    async (snapshot,context)=>
    {
        var payload={notification: {title:'new order', body: 'body'},
                        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
         const response = await admin.messaging().sendToTopic('Admin',payload);
    }
)