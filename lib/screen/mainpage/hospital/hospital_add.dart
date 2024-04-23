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

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
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
                padding: MySpacing.nTop(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 0, right: 20, top: 0, bottom: 12),
                      child: MyText.titleMedium("Personal", fontWeight: 600),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Hospital Name",
                        border: theme.inputDecorationTheme.border,
                        enabledBorder: theme.inputDecorationTheme.border,
                        focusedBorder: theme.inputDecorationTheme.focusedBorder,
                        prefixIcon: Icon(LucideIcons.user, size: 24),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Hospital Address",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.home, size: 24),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Hospital Contact",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.contact2, size: 24),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Hospital Image Link",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                          prefixIcon: Icon(LucideIcons.image, size: 24),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withAlpha(28),
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: MyButton.block(
                          elevation: 0,
                          borderRadiusAll: 8,
                          padding: MySpacing.y(20),
                          backgroundColor: AppTheme.customTheme.medicarePrimary,
                          onPressed: () {
                            // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                            //     builder: (context) => MediCareAppointmentScreen()));
                          },
                          child: MyText.bodyLarge(
                            'Submit',
                            color: AppTheme.customTheme.medicareOnPrimary,
                            fontWeight: 600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}