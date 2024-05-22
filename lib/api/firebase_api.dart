import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/main.dart';
import 'package:blood_donation/screen/news/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> initNotifications(Map<String, dynamic> userData) async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("fcmTokenss: ${fcmToken}");

    // store fcmToken to user database
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userData["donorID"])
        .update({"donor_fcmToken": fcmToken});
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
          builder: (context) => News()),
    );
  }
}