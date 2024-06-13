import 'package:blood_donation/screen/profile/profile.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ThemeData theme;
  late CustomTheme customTheme;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => Profile()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySpacing.height(42),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "New Password",
                  hintText: "New Password",
                  labelStyle: MyTextStyle.getStyle(
                    color: customTheme.medicarePrimary,
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                  hintStyle: MyTextStyle.getStyle(
                    color: customTheme.medicarePrimary,
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                  fillColor: customTheme.medicarePrimary.withAlpha(50),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: MySpacing.all(16),
                  prefixIcon: Icon(
                    LucideIcons.lock,
                    size: 20,
                  ),
                  prefixIconColor: customTheme.medicarePrimary,
                  focusColor: customTheme.medicarePrimary,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                cursorColor: customTheme.medicarePrimary,
                autofocus: true,
                obscureText: true,  // Hide password
              ),
              MySpacing.height(12),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Confirm Password",
                  hintText: "Confirm Password",
                  labelStyle: MyTextStyle.getStyle(
                    color: customTheme.medicarePrimary,
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                  hintStyle: MyTextStyle.getStyle(
                    color: customTheme.medicarePrimary,
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                  fillColor: customTheme.medicarePrimary.withAlpha(50),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: MySpacing.all(16),
                  prefixIcon: Icon(
                    LucideIcons.lock,
                    size: 20,
                  ),
                  prefixIconColor: customTheme.medicarePrimary,
                  focusColor: customTheme.medicarePrimary,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                cursorColor: customTheme.medicarePrimary,
                autofocus: true,
                obscureText: true,  // Hide password
              ),
              MySpacing.height(16),
              MyButton.block(
                elevation: 0,
                borderRadiusAll: 8,
                padding: MySpacing.y(20),
                onPressed: _changePassword,
                backgroundColor: customTheme.medicarePrimary,
                child: MyText.bodyLarge(
                  "Change Password",
                  color: customTheme.medicareOnPrimary,
                  fontWeight: 600,
                  letterSpacing: 0.3,
                ),
              ),
              MySpacing.height(16),
            ],
          ),
        ],
      )
    );
  }
}