import 'package:blood_donation/auth/login.dart';
import 'package:blood_donation/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ThemeData theme;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    MyTextStyle.changeFontFamily(GoogleFonts.quicksand);
    MyTextStyle.changeDefaultFontWeight({
      100: FontWeight.w200,
      200: FontWeight.w300,
      300: FontWeight.w400,
      400: FontWeight.w500,
      500: FontWeight.w600,
      600: FontWeight.w700,
      700: FontWeight.w800,
      800: FontWeight.w900,
      900: FontWeight.w900,
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.medicarePrimary)),
      child: Scaffold(
        body: Container(
          margin: MySpacing.fromLTRB(24, 100, 24, 32),
          child: Column(
            children: [
              MyText.displaySmall(
                "Welcome to Blood Donation",
                color: customTheme.medicarePrimary,
              ),
              const Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage(
                        'assets/images/apps/medicare/medicare_splash_screen.png'),
                    width: 320,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyButton.text(
                    splashColor: customTheme.medicarePrimary.withAlpha(40),
                    padding: MySpacing.y(8),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage()),
                      );
                    },
                    child: MyText.labelLarge(
                      "SIGN UP",
                      color: customTheme.medicarePrimary,
                      letterSpacing: 0.5,
                    ),
                  )),
                  Expanded(
                      child: MyButton(
                    elevation: 0,
                    padding: MySpacing.y(20),
                    borderRadiusAll: 4,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: customTheme.medicarePrimary,
                    child: MyText.labelLarge(
                      "LOG IN",
                      color: customTheme.medicareOnPrimary,
                      letterSpacing: 0.5,
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}