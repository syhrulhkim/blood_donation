import 'package:blood_donation/api/main_api.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NewsAdd extends StatefulWidget {
  const NewsAdd({super.key});

  @override
  State<NewsAdd> createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> {
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Hospital> hospitalList = [];
  String? selectedHospital;
  String? selectedAvailability;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    _buildHospitalList();
    // _nameController = TextEditingController();
    // _criticalController = TextEditingController();
    // _addressController = TextEditingController();
    // _contactController = TextEditingController();
    // _imageLinkController = TextEditingController();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _criticalController.dispose();
    // _addressController.dispose();
    // _contactController.dispose();
    // _imageLinkController.dispose();
    super.dispose();
  }

  _buildHospitalList() async {
    MainAPI mainAPI = MainAPI();
    List<Hospital> list = await mainAPI.allHospital();
    setState(() {
      hospitalList = list;
    });
  }

  Widget newsForm() {
    print("hospitalList: ${hospitalList}");
    List<String> selectedHospitalOptions = [];
    List<String> options = ['All', 'Not Donate', 'Donated', 'Critical Blood'];

    return Container(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: MySpacing.nTop(20),
          child: Form(
            // key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 0, right: 20, top: 0, bottom: 12),
                  child: MyText.titleMedium("Create Announcement", fontWeight: 600),
                ),
                TextFormField(
                  // controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.border,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // controller: _addressController,
                  maxLines: null,
                  minLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.border,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                    contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                Padding(
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
                          selectedHospital ?? 'Choose Availability',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: selectedAvailability,
                        onChanged: (String? value) {
                          setState(() {
                            selectedAvailability = value;
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
                ),
                Padding(
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
                          selectedHospital ?? 'Choose Hospital',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: selectedHospitalOptions.isNotEmpty ? selectedHospitalOptions.join(', ') : null,
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              if (selectedHospitalOptions.contains(newValue)) {
                                selectedHospitalOptions.remove(newValue);
                                selectedHospital = null;
                              } else {
                                selectedHospitalOptions.add(newValue);
                                selectedHospital = newValue;
                              }
                            }
                          });
                        },
                        items: hospitalList.map<DropdownMenuItem<String>>((Hospital hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital.hospitalName,
                            child: Text(hospital.hospitalName),
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
                ),
                SizedBox(height: 16),
                MyButton.block(
                  elevation: 0,
                  borderRadiusAll: 8,
                  padding: MySpacing.y(20),
                  backgroundColor: AppTheme.customTheme.medicarePrimary,
                  onPressed: () {
                    // _submitForm();
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
    );
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
          newsForm(),
        ]
      ),
    );
  }
}