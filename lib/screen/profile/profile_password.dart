import 'package:blood_donation/screen/profile/profile.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _hasUppercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;
  bool _hasMinLength = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_validatePassword);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigits = password.contains(RegExp(r'\d'));
      _hasSpecialCharacters = password.contains(RegExp(r'[@$!%*?&]'));
      _hasMinLength = password.length >= 8;
    });
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, return early
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
            builder: (context) => Profile(),
          ),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildPasswordValidationMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationMessage("Contains at least one uppercase letter", _hasUppercase),
        _buildValidationMessage("Contains at least one number", _hasDigits),
        _buildValidationMessage("Contains at least one special character", _hasSpecialCharacters),
        _buildValidationMessage("Contains at least 8 characters", _hasMinLength),
      ],
    );
  }

  Widget _buildValidationMessage(String message, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error_outline,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        SizedBox(width: 8.0),
        Text(message),
      ],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySpacing.height(42),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).dividerColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      cursorColor: customTheme.medicarePrimary,
                      autofocus: true,
                      obscureText: !_passwordVisible, // Toggle password visibility
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        } else if (!_hasUppercase ||
                            !_hasDigits ||
                            !_hasSpecialCharacters ||
                            !_hasMinLength) {
                          return 'Password must contain at least one uppercase letter, one number, one special character, and be at least 8 characters long';
                        }
                        return null;
                      },
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).dividerColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      cursorColor: customTheme.medicarePrimary,
                      autofocus: true,
                      obscureText: !_confirmPasswordVisible, // Toggle password visibility
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    MySpacing.height(16),
                    _buildPasswordValidationMessage(),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}