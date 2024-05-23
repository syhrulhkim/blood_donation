import 'package:blood_donation/api/campaign_api.dart';
import 'package:blood_donation/models/campaign.dart';
import 'package:blood_donation/screen/news/news_add.dart';
import 'package:blood_donation/screen/news/news_details.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Campaign> newsList = [];

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    _buildCampaignList();
  }

  _buildCampaignList() async{
    CampaignAPI campaignAPI = CampaignAPI();
    List<Campaign> list = await campaignAPI.allCampaign();
    setState(() {
      newsList = list;
    });
  }

  String extractDay(String dateTimeString) {
    List<String> parts = dateTimeString.split('T');
    if (parts.length != 2) {
      throw FormatException("Invalid date time string format");
    }      
    String datePart = parts[0];
    List<String> dateParts = datePart.split('-');
    if (dateParts.length != 3) {
      throw FormatException("Invalid date format");
    }
    return dateParts[2];
  }

  String extractMonth(String dateTimeString) {
    List<String> parts = dateTimeString.split('T');
    if (parts.length != 2) {
      throw FormatException("Invalid date time string format");
    }
    String datePart = parts[0];
    List<String> dateParts = datePart.split('-');
    if (dateParts.length != 3) {
      throw FormatException("Invalid date format");
    }
    int? month = int.tryParse(dateParts[1]);
    if (month == null || month < 1 || month > 12) {
      throw FormatException("Invalid month");
    }
    List<String> months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];      
    return months[month];
  }

  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Widget _buildAllCampaign() {
    if (newsList.isEmpty) {
      return Column(
        children: [
          CircularProgressIndicator(),
        ],
      );
    } else {
      return Column(
        children: List.generate(newsList.length, (index) {
          final campaignList = newsList[index];
          return Column(
            children: [
              MyContainer.bordered(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                      builder: (context) => NewDetails(campaignList)));
                },
                paddingAll: 16,
                borderRadiusAll: 16,
                child: Row(
                  children: [
                    MyContainer(
                      width: 56,
                      padding: MySpacing.y(12),
                      borderRadiusAll: 4,
                      bordered: true,
                      border: Border.all(color: customTheme.medicarePrimary),
                      color: customTheme.medicarePrimary.withAlpha(20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyText.bodyMedium(
                              "${extractDay(campaignList.campaignDate)}",
                              fontWeight: 700,
                              color: customTheme.medicarePrimary,
                            ),
                            MyText.bodySmall(
                              "${extractMonth(campaignList.campaignDate)}",
                              fontWeight: 600,
                              color: customTheme.medicarePrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    MySpacing.width(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText.bodySmall(
                            "${campaignList.campaignTitle}",
                            fontWeight: 600,
                          ),
                          MySpacing.height(4),
                          MyText.bodySmall(
                            "${campaignList.campaignDesc}",
                            fontSize: 11,
                          ),
                          MySpacing.height(4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText.bodySmall(
                                "Send to: ${campaignList.campaignRequire}",
                                fontSize: 9,
                              ),
                              MyText.bodySmall(
                                "Time: ${formatTime(campaignList.campaignDate)}",
                                fontSize: 9,
                              ),
                            ],  
                          ),
                        ],
                      ),
                    ),
                    MySpacing.width(16),
                    MyContainer.rounded(
                      paddingAll: 4,
                      color: customTheme.card,
                      child: Icon(
                        Icons.navigate_next,
                        size: 16,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
            ],
          );
        }),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText.bodyLarge(
          'News',
          fontWeight: 700,
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          MyContainer(
            color: Colors.transparent,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => NewsAdd()));
            },
            child: Icon(
              Icons.add,
              color: customTheme.medicarePrimary,
              size: 20,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: MySpacing.fromLTRB(24, 8, 24, 24),
        children: [
          MyText.titleMedium(
            'Latest Announcement',
            letterSpacing: 0.5,
            fontWeight: 700,
          ),
          MySpacing.height(16),
          _buildAllCampaign(),
        ],
      ),
    );
  }
}