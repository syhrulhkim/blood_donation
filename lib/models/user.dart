import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String donorID;
  final String donorAddress;
  final String donorContact;
  final String donorDOB;
  final String donorEligibility;
  final String donorAvailability;
  final String donorEmail;
  final String donorGender;
  final String donorHealth;
  final String donorLatestDonate;
  final String donorName;
  final String donorPostcode;
  final String donorRole;
  final String donorType;
  final String donorUsername;
  final String donorHeight;
  final String donorWeight;
  final String donorFcmToken;

  Users({
    required this.donorID,
    required this.donorAddress,
    required this.donorContact,
    required this.donorDOB,
    required this.donorEligibility,
    required this.donorAvailability,
    required this.donorEmail,
    required this.donorGender,
    required this.donorHealth,
    required this.donorLatestDonate,
    required this.donorName,
    required this.donorPostcode,
    required this.donorRole,
    required this.donorType,
    required this.donorUsername,
    required this.donorHeight,
    required this.donorWeight,
    required this.donorFcmToken,
  });

  bool isEmpty() {
    return donorID.isEmpty &&
        donorAddress.isEmpty &&
        donorContact.isEmpty &&
        donorDOB.isEmpty &&
        donorEligibility.isEmpty &&
        donorAvailability.isEmpty &&
        donorEmail.isEmpty &&
        donorGender.isEmpty &&
        donorHealth.isEmpty &&
        donorLatestDonate.isEmpty &&
        donorName.isEmpty &&
        donorPostcode.isEmpty &&
        donorRole.isEmpty &&
        donorType.isEmpty &&
        donorUsername.isEmpty &&
        donorWeight.isEmpty &&
        donorHeight.isEmpty &&
        donorFcmToken.isEmpty;
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      donorID: json['donorID'] ?? '',
      donorAddress: json['donor_Address'] ?? '',
      donorContact: json['donor_Contact'] ?? '',
      donorDOB: json['donor_DOB'] ?? '',
      donorEligibility: json['donor_Eligibility'] ?? '',
      donorAvailability: json['donor_Availability'] ?? '',
      donorEmail: json['donor_Email'] ?? '',
      donorGender: json['donor_Gender'] ?? '',
      donorHealth: json['donor_Health'] ?? '',
      donorLatestDonate: json['donor_LatestDonate'] ?? '',
      donorName: json['donor_Name'] ?? '',
      donorPostcode: json['donor_Postcode'] ?? '',
      donorRole: json['donor_Role'] ?? '',
      donorType: json['donor_Type'] ?? '',
      donorUsername: json['donor_Username'] ?? '',
      donorWeight: json['donor_Weight'] ?? '',
      donorHeight: json['donor_Height'] ?? '',
      donorFcmToken: json['donor_fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "donorID": donorID,
      "donor_Address": donorAddress,
      "donor_Contact": donorContact,
      "donor_DOB": donorDOB,
      "donor_Eligibility": donorEligibility,
      "donor_Availability": donorAvailability,
      "donor_Email": donorEmail,
      "donor_Gender": donorGender,
      "donor_Health": donorHealth,
      "donor_LatestDonate": donorLatestDonate,
      "donor_Name": donorName,
      "donor_Postcode": donorPostcode,
      "donor_Role": donorRole,
      "donor_Type": donorType,
      "donor_Username": donorUsername,
      "donor_Weight": donorWeight,
      "donor_Height": donorHeight,
      "donor_fcmToken": donorFcmToken,
    };
  }

  factory Users.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Users(
      donorID: data["donorID"],
      donorAddress: data["donor_Address"],
      donorContact: data["donor_Contact"],
      donorDOB: data["donor_DOB"],
      donorEligibility: data["donor_Eligibility"],
      donorAvailability: data["donor_Availability"],
      donorEmail: data["donor_Email"],
      donorGender: data["donor_Gender"],
      donorHealth: data["donor_Health"],
      donorLatestDonate: data["donor_LatestDonate"],
      donorName: data["donor_Name"],
      donorPostcode: data["donor_Postcode"],
      donorRole: data["donor_Role"],
      donorType: data["donor_Type"],
      donorUsername: data["donor_Username"],
      donorWeight: data["donor_Weight"],
      donorHeight: data["donor_Height"],
      donorFcmToken: data["donor_fcmToken"],
    );
  }
}

class UserNotification {
  String campaignId;
  String campaignTitle;
  String campaignDesc;
  String campaignDate;
  String place;
  String status;

  UserNotification({
    required this.campaignId,
    required this.campaignTitle,
    required this.campaignDesc,
    required this.campaignDate,
    required this.place,
    required this.status,
  });

  factory UserNotification.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserNotification(
      campaignId: data["campaignId"],
      campaignTitle: data["campaignTitle"],
      campaignDesc: data["campaignDesc"],
      campaignDate: data["campaignDate"],
      place: data["place"],
      status: data["status"],
    );
  }

  factory UserNotification.fromMap(Map<String, dynamic> data) {
    return UserNotification(
      campaignId: data['campaignId'],
      campaignTitle: data['campaignTitle'],
      campaignDesc: data['campaignDesc'],
      place: data['place'],
      campaignDate: data['campaignDate'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'campaignId': campaignId,
      'campaignTitle': campaignTitle,
      'campaignDesc': campaignDesc,
      'campaignDate': campaignDate,
      'place': place,
      'status': status,
    };
  }
}

