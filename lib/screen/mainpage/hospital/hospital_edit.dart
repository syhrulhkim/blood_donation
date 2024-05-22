import 'package:blood_donation/api/hospital_api.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/screen/mainpage/mainpage.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HospitalEdit extends StatefulWidget {
  final Hospital hospital;
  const HospitalEdit(this.hospital);

  @override
  State<HospitalEdit> createState() => _HospitalEditState();
}

class _HospitalEditState extends State<HospitalEdit> {
  late Hospital hospital;
  late var bloodLevel;
  late ThemeData theme;
  late CustomTheme customTheme;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _criticalController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _imageLinkController;
  // blood levels
  late TextEditingController _aPlusController;
  late TextEditingController _aMinusController;
  late TextEditingController _abPlusController;
  late TextEditingController _abMinusController;
  late TextEditingController _bPlusController;
  late TextEditingController _bMinusController;
  late TextEditingController _oPlusController;
  late TextEditingController _oMinusController;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    hospital = widget.hospital;
    bloodLevel = widget.hospital.bloodLevels;
    _nameController = TextEditingController();
    _criticalController = TextEditingController();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
    _imageLinkController = TextEditingController();
    // blood levels
    _aPlusController = TextEditingController();
    _aMinusController = TextEditingController();
    _abPlusController = TextEditingController();
    _abMinusController = TextEditingController();
    _bPlusController = TextEditingController();
    _bMinusController = TextEditingController();
    _oPlusController = TextEditingController();
    _oMinusController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _criticalController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _imageLinkController.dispose();
    // blood levels
    _aPlusController.dispose();
    _aMinusController.dispose();
    _abPlusController.dispose();
    _abMinusController.dispose();
    _bPlusController.dispose();
    _bMinusController.dispose();
    _oPlusController.dispose();
    _oMinusController.dispose();
    super.dispose();
  }

  void _editForm() {
    String name = _nameController.text.isNotEmpty ? _nameController.text : widget.hospital.hospitalName;
    String address = _addressController.text.isNotEmpty ? _addressController.text : widget.hospital.hospitalAddress;
    String contact = _contactController.text.isNotEmpty ? _contactController.text : widget.hospital.hospitalContact;
    String imageLink = _imageLinkController.text.isNotEmpty ? _imageLinkController.text : widget.hospital.hospitalImage;

    List<BloodLevel> bloodLevel = [
      BloodLevel(bloodType: 'blood_a+', percent: _aPlusController.text),
      BloodLevel(bloodType: 'blood_a-', percent: _aMinusController.text),
      BloodLevel(bloodType: 'blood_ab+', percent: _abPlusController.text),
      BloodLevel(bloodType: 'blood_ab-', percent: _abMinusController.text),
      BloodLevel(bloodType: 'blood_b+', percent: _bPlusController.text),
      BloodLevel(bloodType: 'blood_b-', percent: _bMinusController.text),
      BloodLevel(bloodType: 'blood_o+', percent: _oPlusController.text),
      BloodLevel(bloodType: 'blood_o-', percent: _oMinusController.text),
    ];

    // Create a new Hospital object with the updated data
    Hospital newHospital = Hospital(
      hospitalID: widget.hospital.hospitalID, 
      hospitalName: name,
      hospitalAddress: address,
      hospitalContact: contact,
      hospitalImage: imageLink,
      hospitalPoscode: "", 
      bloodLevels: bloodLevel
    );

    // Call the API to update the hospital data
    HospitalAPI().updateHospital(newHospital).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hospital updated successfully')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update hospital: $error')),
      );
    });
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
                        child: MyText.titleMedium("Add New Hospital", fontWeight: 600),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "${widget.hospital.hospitalName}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.user, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: "${widget.hospital.hospitalAddress}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.home, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          labelText: "${widget.hospital.hospitalContact}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.contact2, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital contact';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _imageLinkController,
                        decoration: InputDecoration(
                          labelText: "${widget.hospital.hospitalImage}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.image, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital image link';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 36),
                      Container(
                        padding: EdgeInsets.only(
                            left: 0, right: 20, top: 0, bottom: 12),
                        child: MyText.titleMedium("Critical Blood Level Percentage", fontWeight: 600),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _aPlusController,
                                decoration: InputDecoration(
                                  labelText: "A+",
                                  border: theme.inputDecorationTheme.border,
                                  enabledBorder: theme.inputDecorationTheme.border,
                                  focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _aMinusController,
                                  decoration: InputDecoration(
                                    labelText: "A-",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _abPlusController,
                                  decoration: InputDecoration(
                                    labelText: "AB+",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _abMinusController,
                                  decoration: InputDecoration(
                                    labelText: "AB-",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _bPlusController,
                                  decoration: InputDecoration(
                                    labelText: "B+",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _bMinusController,
                                  decoration: InputDecoration(
                                    labelText: "B-",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _oPlusController,
                                  decoration: InputDecoration(
                                    labelText: "O+",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: _oMinusController,
                                  decoration: InputDecoration(
                                    labelText: "O-",
                                    border: theme.inputDecorationTheme.border,
                                    enabledBorder: theme.inputDecorationTheme.border,
                                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      MyButton.block(
                        elevation: 0,
                        borderRadiusAll: 8,
                        padding: MySpacing.y(20),
                        backgroundColor: AppTheme.customTheme.medicarePrimary,
                        onPressed: () {
                          _editForm();
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