import 'package:blood_donation/api/hospital_api.dart';
// import 'package:blood_donation/api/main_api.dart';
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

class HospitalAdd extends StatefulWidget {
  const HospitalAdd({super.key});

  @override
  State<HospitalAdd> createState() => _HospitalAddState();
}

class _HospitalAddState extends State<HospitalAdd> {
  late ThemeData theme;
  late CustomTheme customTheme;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _criticalController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _imageLinkController;
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
    _nameController = TextEditingController();
    _criticalController = TextEditingController();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
    _imageLinkController = TextEditingController();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, submit data to Firestore
      Hospital newHospital = Hospital(
        hospitalID: _nameController.text,
        criticalBloodId: _criticalController.text,
        hospitalAddress: _addressController.text,
        hospitalName: _nameController.text,
        hospitalContact: _contactController.text,
        hospitalImage: _imageLinkController.text,
      );

      HospitalAPI().submitHospital(newHospital).then((_) {
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hospital added successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add hospital: $error')),
        );
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
                        child: MyText.titleMedium("Add New Hospital", fontWeight: 600),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Hospital Name",
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
                          labelText: "Hospital Address",
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
                          labelText: "Hospital Contact",
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
                          labelText: "Hospital Image Link",
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
                          labelText: "Hospital Critical Blood",
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