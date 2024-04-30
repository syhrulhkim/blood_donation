// import 'package:flutkit/full_apps/other/medicare/forgot_password_screen.dart';
// import 'package:flutkit/full_apps/other/medicare/full_app.dart';
// import 'package:flutkit/full_apps/other/medicare/login_screen.dart';
import 'package:blood_donation/api/signup_api.dart';
import 'package:blood_donation/auth/forgotpassword.dart';
import 'package:blood_donation/auth/login.dart';
import 'package:blood_donation/screen/home/home.dart';
import 'package:blood_donation/screen/mainpage/main_user.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late ThemeData theme;
  late CustomTheme customTheme;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp(String name, String email, String password) async {
    SignUpApi signUpAPI = SignUpApi();
    try {
      print("signUP");
      await signUpAPI.signUpAPI(name, email, password);
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign-up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MySpacing.horizontal(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                labelText: "Name",
                hintText: "Name",
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
                  LucideIcons.user,
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
              controller: emailController,
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
              controller: passwordController,
              obscureText: !_passwordVisible, // Hides the password
              decoration: InputDecoration(
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
            ),
            MySpacing.height(16),
            Align(
              alignment: Alignment.centerRight,
              child: MyButton.text(
                  padding: MySpacing.zero,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()),
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
                  signUp(nameController.text, emailController.text, passwordController.text);
                },
                backgroundColor: customTheme.medicarePrimary,
                child: MyText.bodyLarge(
                  "Create an Account",
                  color: customTheme.medicareOnPrimary,
                )),
            MySpacing.height(16),
            MyButton.text(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => LoginPage()),
                  );
                },
                splashColor: customTheme.medicarePrimary.withAlpha(40),
                child: MyText.bodySmall("I have already an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.medicarePrimary)),
          ],
        ),
      ),
    );
  }
}