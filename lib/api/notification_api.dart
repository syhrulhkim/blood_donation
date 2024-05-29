import 'package:blood_donation/models/appointment.dart';
import 'package:blood_donation/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationAPI {
  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('user').doc(userId);
      final notificationsSnapshot = await userDoc.collection('notifications').get();
      return notificationsSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      throw e;
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('user').doc(userId);
      final notificationsSnapshot = await userDoc.collection('notifications').get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in notificationsSnapshot.docs) {
        batch.update(doc.reference, {'status': 'read'});
      }
      await batch.commit();
    } catch (e) {
      print('Error updating notifications: $e');
      throw e;
    }
  }

  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    try {
      final notificationDoc = FirebaseFirestore.instance.collection('user').doc(userId).collection('notifications').doc(notificationId);
      await notificationDoc.update({'status': 'read'});
    } catch (e) {
      print('Error updating notification: $e');
      throw e;
    }
  }
}