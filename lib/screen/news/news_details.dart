import 'package:blood_donation/models/campaign.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:blood_donation/widgets/my_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDetails extends StatefulWidget {
  final Campaign campaign;
  const NewDetails(this.campaign);

  @override
  State<NewDetails> createState() => _NewDetailsState();
}

class _NewDetailsState extends State<NewDetails> {
  late Campaign campaign;
  late ThemeData theme;
  late CustomTheme customTheme;


  @override
  void initState() {
    super.initState();
    campaign = widget.campaign;
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }
  
  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('d MMM yy').format(dateTime);
    String formattedTime = DateFormat('h:mma').format(dateTime);
    return '$formattedDate $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: MySpacing.fromLTRB(24, 44, 24, 44),
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
          MyContainer(
            paddingAll: 24,
            borderRadiusAll: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.bodyLarge(
                  'News Details',
                  fontWeight: 600,
                ),
                MySpacing.height(10),
                MyContainer(
                  paddingAll: 4,
                  borderRadiusAll: 8,
                  bordered: true,
                  border: Border.all(color: customTheme.border, width: 1),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText.bodyLarge(
                            '${campaign.campaignTitle}',
                            fontWeight: 600,
                          ),
                          MyText.bodyLarge(
                            '${formatDateTime(campaign.campaignDate)}',
                            fontWeight: 400,
                            fontSize: 11,
                          ),
                        ],
                      ),
                      MySpacing.height(4),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "${campaign.campaignDesc}",
                              style: MyTextStyle.bodySmall(
                                color: theme.colorScheme.onBackground,
                                xMuted: true,
                                height: 1.5,
                              )),
                        ]),
                      ),
                    ],
                  )
                ),                
                MySpacing.height(10),
                Row(
                  children: [
                    MyText.bodyLarge(
                      'Send To',
                      fontWeight: 600,
                    ),
                    SizedBox(width: 12),
                    Padding(
                      padding: MySpacing.right(5),
                      child: MyContainer(
                        paddingAll: 4,
                        borderRadiusAll: 8,
                        bordered: true,
                        border: Border.all(color: customTheme.border, width: 1),
                        color: Colors.white,
                        child: Row(
                          children: [
                            MyText.labelMedium(
                              "${campaign.campaignRequire}",
                              fontWeight: 600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: MySpacing.right(5),
                      child: MyContainer(
                        paddingAll: 4,
                        borderRadiusAll: 8,
                        bordered: true,
                        border: Border.all(color: customTheme.border, width: 1),
                        color: Colors.white,
                        child: Row(
                          children: [
                            MyText.labelMedium(
                              "${campaign.campaignSend.length} Users",
                              fontWeight: 600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                MySpacing.height(16),
                MyContainer(
                  height: MediaQuery.of(context).size.height * 0.3,
                  paddingAll: 2,
                  borderRadiusAll: 10,
                  bordered: true,
                  border: Border.all(color: customTheme.border, width: 1),
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // Ensure no padding inside the ListView
                    itemCount: campaign.campaignSend.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyContainer(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText.labelMedium(
                                      "ID : ${campaign.campaignSend[index].donorID}",
                                      fontWeight: 600,
                                    ),
                                    MyText.labelMedium(
                                      "Status : ${campaign.campaignSend[index].campaignStatus}",
                                      fontWeight: 600,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                MyText.labelMedium(
                                  "Name : ${campaign.campaignSend[index].donorName}",
                                  fontWeight: 600,
                                ),                                
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}