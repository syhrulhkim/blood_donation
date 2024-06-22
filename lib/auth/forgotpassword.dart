import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/auth/signup.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late ThemeData theme;
  late CustomTheme customTheme;
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
            MySpacing.height(32),
            MyButton.block(
              elevation: 0,
              borderRadiusAll: 8,
              padding: MySpacing.y(20),
              onPressed: _sendPasswordResetEmail,
              backgroundColor: customTheme.medicarePrimary,
              child: MyText.bodyLarge(
                "Forgot Password",
                color: customTheme.medicareOnPrimary,
                fontWeight: 600,
                letterSpacing: 0.3,
              ),
            ),
            MySpacing.height(16),
            MyButton.text(
              elevation: 0,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              splashColor: customTheme.medicarePrimary.withAlpha(40),
              child: MyText.bodySmall(
                "I dont have an account",
                decoration: TextDecoration.underline,
                color: customTheme.medicarePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
