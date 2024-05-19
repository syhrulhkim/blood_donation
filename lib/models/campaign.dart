import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final String? id;
  final String campaignId;
  final String campaignDate;
  final String campaignTitle;
  final String campaignDesc;
  final String campaignRequire;
  final String place;
  final String postcode;
  final String timeEnd;
  final String timeStart;

  const Campaign({
    this.id,
    required this.campaignId,
    required this.campaignDate,
    required this.campaignTitle,
    required this.campaignDesc,
    required this.campaignRequire,
    required this.place,
    required this.postcode,
    required this.timeEnd,
    required this.timeStart,
  });

  Campaign copyWith({
    String? id,
    String? campaignId,
    String? campaignDate,
    String? campaignTitle,
    String? campaignDesc,
    String? campaignRequire,
    String? place,
    String? postcode,
    String? timeEnd,
    String? timeStart,
  }) {
    return Campaign(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      campaignDate: campaignDate ?? this.campaignDate,
      campaignTitle: campaignTitle ?? this.campaignTitle,
      campaignDesc: campaignDesc ?? this.campaignDesc,
      campaignRequire: campaignRequire ?? this.campaignRequire,
      place: place ?? this.place,
      postcode: postcode ?? this.postcode,
      timeEnd: timeEnd ?? this.timeEnd,
      timeStart: timeStart ?? this.timeStart,
    );
  }

  toJson() {
    return {
      "campaignId": campaignId,
      "campaignDate": campaignDate,
      "campaignTitle": campaignTitle,
      "campaignDesc": campaignDesc,
      "campaignRequire": campaignRequire,
      "place": place,
      "postcode": postcode,
      "timeEnd": timeEnd,
      "timeStart": timeStart,
    };
  }

  static Future<List<Campaign>> hospitalList() async {
    final _db = FirebaseFirestore.instance;
    List<Campaign> list = [];
    final snapshot = await _db.collection("campaign").get();
    final data = snapshot.docs.map((e) => Campaign.fromSnapshot(e)).toList();
    return list;
  }

  factory Campaign.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Campaign(
      id: document.id,
      campaignId: data["campaignId"],
      campaignDate: data["campaignDate"],
      campaignTitle: data["campaignTitle"],
      campaignDesc: data["campaignDesc"],
      campaignRequire: data["campaignRequire"],
      place: data["place"],
      postcode: data["postcode"],
      timeEnd: data["timeEnd"],
      timeStart: data["timeStart"],
    );
  }

  toMap() {
    return {
      "campaignId": campaignId,
      "campaignDate": campaignDate,
      "campaignTitle": campaignTitle,
      "campaignDesc": campaignDesc,
      "campaignRequire": campaignRequire,
      "place": place,
      "postcode": postcode,
      "timeEnd": timeEnd,
      "timeStart": timeStart,
    };
  }
}

class CampaignSendTo {
  String donorID;
  String donorName;
  String campaignStatus;
  String readTime;

  CampaignSendTo({
    required this.donorID,
    required this.donorName,
    required this.campaignStatus,
    required this.readTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'donorID': donorID,
      'donor_Name': donorName,
      'campaignStatus': campaignStatus,
      'readTime': readTime,
    };
  }
}
