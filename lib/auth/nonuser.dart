import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NonUser extends StatefulWidget {
  const NonUser({super.key});

  @override
  State<NonUser> createState() => _NonUserState();
}

class _NonUserState extends State<NonUser> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            LucideIcons.chevronLeft,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              LucideIcons.shieldOff,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: MyText.titleLarge("Whoops",
                  color: theme.colorScheme.onBackground,
                  fontWeight: 600,
                  letterSpacing: 0.2),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Column(
                children: <Widget>[
                  MyText.bodyLarge(
                    "You are not log in",
                    letterSpacing: 0,
                    fontWeight: 500,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: MyText.bodyLarge(
                      "Please login or register to continue",
                      letterSpacing: 0,
                      fontWeight: 500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: MyButton(
                elevation: 0,
                borderRadiusAll: 4,
                onPressed: () {},
                padding: MySpacing.xy(16, 12),
                child: MyText.labelMedium("Login or Register",
                  fontWeight: 600,
                  color: theme.colorScheme.onPrimary,
                  letterSpacing: 0.5)
              ),
            ),
          ],
        ),
      )
    );
  }
}