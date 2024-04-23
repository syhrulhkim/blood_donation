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
  late ThemeData theme;
  late CustomTheme customTheme;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _criticalController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _imageLinkController;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    hospital = widget.hospital;
    _nameController = TextEditingController();
    _criticalController = TextEditingController();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
    _imageLinkController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _criticalController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _imageLinkController.dispose();
    super.dispose();
  }

  void _editForm() {
    // Remove the validation check
    // Use the existing data if the user does not input anything
    String name = _nameController.text.isNotEmpty ? _nameController.text : widget.hospital.hospitalName;
    String address = _addressController.text.isNotEmpty ? _addressController.text : widget.hospital.hospitalAddress;
    String contact = _contactController.text.isNotEmpty ? _contactController.text : widget.hospital.hospitalContact;
    String imageLink = _imageLinkController.text.isNotEmpty ? _imageLinkController.text : widget.hospital.hospitalImage;
    String criticalBlood = _criticalController.text.isNotEmpty ? _criticalController.text : widget.hospital.criticalBloodId;

    // Create a new Hospital object with the updated data
    Hospital newHospital = Hospital(
      hospitalID: widget.hospital.hospitalID, // Keep the existing hospital ID
      hospitalName: name,
      hospitalAddress: address,
      hospitalContact: imageLink, // Fix this line
      hospitalImage: contact, // Fix this line
      criticalBloodId: criticalBlood,
    );

    // Call the API to update the hospital data
    HospitalAPI().updateHospital(newHospital).then((_) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hospital updated successfully')),
      );
      
      // Navigate back to the previous page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }).catchError((error) {
      // Show error message
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
                      TextFormField(
                        controller: _criticalController,
                        decoration: InputDecoration(
                          labelText: "${widget.hospital.criticalBloodId}",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder: theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.plus, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital critical blood';
                          }
                          return null;
                        },
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