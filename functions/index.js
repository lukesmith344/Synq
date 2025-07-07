const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Helper to schedule a notification at a random hour between 9 AM and 10 PM UTC
exports.scheduleDailyDrop = functions.pubsub
  .schedule('0 5 * * *') // 5 AM UTC
  .timeZone('UTC')
  .onRun(async (context) => {
    // Pick a random hour between 9 and 22 (9 AM to 10 PM UTC)
    const randomHour = Math.floor(Math.random() * (22 - 9 + 1)) + 9;
    const now = new Date();
    const scheduledDate = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), randomHour, 0, 0, 0));

    // If the random hour is before now, schedule for tomorrow
    if (scheduledDate < now) {
      scheduledDate.setUTCDate(scheduledDate.getUTCDate() + 1);
    }

    const delayMs = scheduledDate.getTime() - now.getTime();

    // For production, use Firestore + a trigger function. For demo, use setTimeout (not reliable for long delays)
    setTimeout(async () => {
      await admin.messaging().send({
        topic: 'dailyDrop',
        notification: {
          title: 'Synq time 🎵',
          body: "Drop your song of the day and hear your friends' picks!",
        },
      });
      console.log(`Sent dailyDrop notification at ${new Date().toISOString()}`);
    }, delayMs);

    console.log(`Scheduled dailyDrop notification for ${scheduledDate.toISOString()}`);
    return null;
  }); 