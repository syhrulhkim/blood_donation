class User {
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
  final String donorWeight;

  User({
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
    required this.donorWeight,
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
        donorWeight.isEmpty;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
    };
  }
}
