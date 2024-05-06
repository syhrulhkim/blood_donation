// import 'package:flutkit/full_apps/other/medicare/forgot_password_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/full_app.dart';
// import 'package:flutkit/full_apps/other/medicare/registration_screen.dart';
import 'dart:convert';

import 'package:blood_donation/api/login_api.dart';
import 'package:blood_donation/auth/forgotpassword.dart';
import 'package:blood_donation/auth/signup.dart';
// import 'package:blood_donation/screen/home/home.dart';
import 'package:blood_donation/screen/mainpage/mainpage.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginApi loginApi = LoginApi();
  late ThemeData theme;
  late CustomTheme customTheme;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  var user;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  Future<void> _submitForm() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userEmail = userCredential.user?.email;
      var userDataObject = await loginApi.findUserByEmail(userEmail!);
      if (userDataObject is Map<String, dynamic>) {
        var userData = userDataObject as Map<String, dynamic>;
        if (userData != null) {
          await _storeUserData(userData);
        }
      } else {
        print('Error: Unexpected user data format');
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email or password is incorrect. Please try again'),
        ),
      );
    }
  }


  Future<void> _storeUserData(Map<String, dynamic> userData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Convert DateTime fields to string representations
      String? dobString = userData['donor_DOB'] != null ? userData['donor_DOB'].toString() : null;
      String? latestDonateString = userData['donor_LatestDonate'] != null ? userData['donor_LatestDonate'].toString() : null;
      // Update userData map with string representations
      Map<String, dynamic> userDataString = Map<String, dynamic>.from(userData);
      if (dobString != null) userDataString['donor_DOB'] = dobString;
      if (latestDonateString != null) userDataString['donor_LatestDonate'] = latestDonateString;

      // Convert userData map to JSON string
      String userDataJson = json.encode(userDataString);
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (context) => MainPage()),
      );

      // Store JSON string in SharedPreferences
      await prefs.setString('userData', userDataJson);
      print('User data stored in SharedPreferences');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: MySpacing.horizontal(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Email Address",
                  hintText: "Email Address",
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
                      borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding: MySpacing.all(16),
                  prefixIcon: Icon(
                    LucideIcons.mail,
                    size: 20,
                  ),
                  prefixIconColor: customTheme.medicarePrimary,
                  focusColor: customTheme.medicarePrimary,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                cursorColor: customTheme.medicarePrimary,
                autofocus: true,
              ),
              MySpacing.height(24),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
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
                  filled: true,
                  labelText: "Password",
                  hintText: "Password",
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
                      borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding: MySpacing.all(16),
                  prefixIcon: Icon(
                    LucideIcons.lock,
                    size: 20,
                  ),
                ),
                cursorColor: customTheme.medicarePrimary,
                autofocus: true,
              ),
              MySpacing.height(16),
              Align(
                alignment: Alignment.centerRight,
                child: MyButton.text(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ForgotPassword()),
                      );
                    },
                    splashColor: customTheme.medicarePrimary.withAlpha(40),
                    child: MyText.bodySmall("Forgot Password?",
                        color: customTheme.medicarePrimary)),
              ),
              MySpacing.height(16),
              MyButton.block(
                borderRadiusAll: 8,
                elevation: 0,
                padding: MySpacing.y(20),
                onPressed: () {
                  _submitForm();
                },
                backgroundColor: customTheme.medicarePrimary,
                child: MyText.labelMedium(
                  "LOG IN",
                  fontWeight: 700,
                  color: customTheme.medicareOnPrimary,
                  letterSpacing: 0.4,
                ),
              ),
              MySpacing.height(16),
              MyButton.text(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => SignUpPage()),
                  );
                },
                splashColor: customTheme.medicarePrimary.withAlpha(40),
                child: MyText.bodySmall("I haven't an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.medicarePrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}