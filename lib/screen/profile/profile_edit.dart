import 'dart:convert';

import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/profile/profile.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEdit extends StatefulWidget {
  final Users userData;
  const ProfileEdit(this.userData);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late Users userData;
  late Users userDatas;
  late ThemeData theme;
  late CustomTheme customTheme;
  late String selectedGender;
  late String selectedStatusPregnant;
  late String selectedBloodType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _poscodeController;
  late TextEditingController _dateController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  var isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    userData = widget.userData;
    selectedGender = "";
    selectedStatusPregnant = "";
    selectedBloodType = "";
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _poscodeController = TextEditingController();
    _dateController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _getUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _poscodeController.dispose();
    _dateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('userData');
    if(userDataJson != null) {
      Map<String, dynamic> decodedData = json.decode(userDataJson);
      var userId = decodedData['donorID'];
      var fetchedUserData = await UserAPI().getUserData(userId);

      if(fetchedUserData != null) {
        setState(() {
          isLoadingUser = false;
          userDatas = Users(
            donorID: fetchedUserData['donorID'],
            donorAddress: fetchedUserData['donor_Address'],
            donorContact: fetchedUserData['donor_Contact'],
            donorDOB: fetchedUserData['donor_DOB'],
            donorEligibility: fetchedUserData['donor_Eligibility'],
            donorAvailability: fetchedUserData['donor_Availability'],
            donorEmail: fetchedUserData['donor_Email'],
            donorGender: fetchedUserData['donor_Gender'],
            donorHealth: fetchedUserData['donor_Health'],
            donorLatestDonate: fetchedUserData['donor_LatestDonate'],
            donorName: fetchedUserData['donor_Name'],
            donorPostcode: fetchedUserData['donor_Postcode'],
            donorRole: fetchedUserData['donor_Role'],
            donorType: fetchedUserData['donor_Type'],
            donorUsername: fetchedUserData['donor_Username'],
            donorWeight: fetchedUserData['donor_Weight'],
            donorHeight: fetchedUserData['donor_Height'],
            donorFcmToken: fetchedUserData['donor_fcmToken'],
          );
        });
      } else {
        print("User data not found for userId: $userId");
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      var convertDatetoISO = _dateController.text;
      DateTime dateTime = DateTime.parse(convertDatetoISO);

      Users updatedUser = Users(
        donorID: userData.donorID,
        donorName: _nameController.text,
        donorContact: _contactController.text,
        donorAddress: _addressController.text,
        donorPostcode: _poscodeController.text,
        donorEmail: _emailController.text,
        donorDOB: dateTime.toString(),
        donorHeight: _heightController.text,
        donorWeight: _weightController.text,
        donorGender: selectedGender,
        donorEligibility: selectedStatusPregnant,
        donorType: selectedBloodType,
        donorAvailability: userDatas.donorAvailability, 
        donorFcmToken: userDatas.donorFcmToken,
        donorHealth: userDatas.donorHealth,
        donorLatestDonate: userDatas.donorLatestDonate, 
        donorRole: userDatas.donorRole, 
        donorUsername: userDatas.donorUsername,
      );
      UserAPI userAPI = UserAPI();
      try {
        await userAPI.updateUser(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }


  Widget selectGender() {
    List<String> options = ['Male', 'Female'];
    return Padding(
      padding: EdgeInsets.fromLTRB(0,5,0,5),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(10,5,10,5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              selectedGender.isEmpty ? 'Gender' : selectedGender,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: selectedGender.isEmpty ? null : selectedGender,
            onChanged: (String? value) {
              setState(() {
                selectedGender = value!;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget selectStatusPregnant() {
    List<String> options = ['Non-Pregnant', 'Pregnant'];
    return Padding(
      padding: EdgeInsets.fromLTRB(0,5,0,5),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(10,5,10,5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              selectedStatusPregnant.isEmpty ? 'Pregnant Status' : selectedStatusPregnant,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: selectedStatusPregnant.isEmpty ? null : selectedStatusPregnant,
            onChanged: (String? value) {
              setState(() {
                selectedStatusPregnant = value!;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget selectBloodType() {
    List<String> options = ['A+', 'A-', 'AB+', 'AB-', 'B+', 'B-', 'O+', 'O-'];
    return Padding(
      padding: EdgeInsets.fromLTRB(0,5,0,5),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(10,5,10,5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              selectedBloodType.isEmpty ? 'Blood Type' : selectedBloodType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: selectedBloodType.isEmpty ? null : selectedBloodType,
            onChanged: (String? value) {
              setState(() {
                selectedBloodType = value!;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: MySpacing.fromLTRB(24, 44, 24, 24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: MyContainer(
                  paddingAll: 4,
                  borderRadiusAll: 8,
                  child: Icon(
                    Icons.chevron_left,
                    color: theme.colorScheme.onBackground.withAlpha(160),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          MySpacing.height(32),
          Container(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: MySpacing.nTop(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 0, right: 20, top: 0, bottom: 12),
                        child: MyText.titleMedium("Edit User Profile", fontWeight: 600),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "${userData.donorName}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.user, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          labelText: "User Contact Number",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.contact2, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user contact number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "${userData.donorEmail}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.mail, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: "User Address",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.home, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _poscodeController,
                        decoration: InputDecoration(
                          labelText: "Poscode",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.locate, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter poscode';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true, // Prevents keyboard from appearing
                        decoration: InputDecoration(
                          labelText: "User Date of Birth",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(Icons.calendar_today, size: 24),
                        ),
                        onTap: () async {
                          await _selectDate(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user date of birth';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(
                          labelText: "User Height",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.ruler, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user gender';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: "User Weight",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.ruler, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user gender';
                          }
                          return null;
                        },
                      ),
                      selectGender(),
                      selectStatusPregnant(),
                      selectBloodType(),
                      SizedBox(height: 36),
                      MyButton.block(
                        elevation: 0,
                        borderRadiusAll: 8,
                        padding: MySpacing.y(20),
                        backgroundColor: AppTheme.customTheme.medicarePrimary,
                        onPressed: () {
                          _submitForm();
                        },
                        child: MyText.bodyLarge(
                          'Submit',
                          color: AppTheme.customTheme.medicareOnPrimary,
                          fontWeight: 600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}