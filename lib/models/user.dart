
class User {
  final String? id;
  final String donorID;
  final String donorAddress;
  final String donorContact;
  final String donorDOB;
  final String donorEligibility;
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


  const User({
    this.id,
    required this.donorID,
    required this.donorAddress,
    required this.donorContact,
    required this.donorDOB,
    required this.donorEligibility,
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

  User copyWith({
    String? id,
    String? donorID,
    String? donorAddress,
    String? donorContact,
    String? donorDOB,
    String? donorEligibility,
    String? donorEmail,
    String? donorGender,
    String? donorHealth,
    String? donorLatestDonate,
    String? donorName,
    String? donorPostcode,
    String? donorRole,
    String? donorType,
    String? donorUsername,
    String? donorWeight,
  }) {
    return User(
      id: id ?? this.id,
      donorID: donorID ?? this.donorID,
      donorAddress: donorAddress ?? this.donorAddress,
      donorContact: donorContact ?? this.donorContact,
      donorDOB: donorDOB ?? this.donorDOB,
      donorEligibility: donorEligibility ?? this.donorEligibility,
      donorEmail: donorEmail ?? this.donorEmail,
      donorGender: donorGender ?? this.donorGender,
      donorHealth: donorHealth ?? this.donorHealth,
      donorLatestDonate: donorLatestDonate ?? this.donorLatestDonate,
      donorName: donorName ?? this.donorName,
      donorPostcode: donorPostcode ?? this.donorPostcode,
      donorRole: donorRole ?? this.donorRole,
      donorType: donorType ?? this.donorType,
      donorUsername: donorUsername ?? this.donorUsername,
      donorWeight: donorWeight ?? this.donorWeight,
    );
  }

  toJson() {
    return {
      "donorID": donorID,
      "donor_Address": donorAddress,
      "donor_Contact": donorContact,
      "donor_DOB": donorDOB,
      "donor_Eligibility": donorEligibility,
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
