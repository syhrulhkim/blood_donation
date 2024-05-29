import 'package:blood_donation/api/campaign_api.dart';
import 'package:blood_donation/api/main_api.dart';
import 'package:blood_donation/api/user_api.dart';
import 'package:blood_donation/constant.dart';
import 'package:blood_donation/main.dart';
import 'package:blood_donation/models/campaign.dart';
import 'package:blood_donation/models/hospital.dart';
import 'package:blood_donation/models/user.dart';
import 'package:blood_donation/screen/news/news.dart';
import 'package:blood_donation/theme/app_theme.dart';
import 'package:blood_donation/theme/custom_theme.dart';
import 'package:blood_donation/widgets/my_button.dart';
import 'package:blood_donation/widgets/my_container.dart';
import 'package:blood_donation/widgets/my_spacing.dart';
import 'package:blood_donation/widgets/my_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NewsAdd extends StatefulWidget {
  const NewsAdd({super.key});

  @override
  State<NewsAdd> createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> {
  late ThemeData theme;
  late CustomTheme customTheme;
  List<Hospital> hospitalList = [];
  List<Users> userList = [];
  late String selectedHospital;
  late String selectedAvailability;
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    selectedHospital = "";
    selectedAvailability = "";
    _buildHospitalList();
    _buildUserList();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, 
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          )
        );
      }
    });
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  _buildHospitalList() async {
    MainAPI mainAPI = MainAPI();
    List<Hospital> list = await mainAPI.allHospital();
    setState(() {
      hospitalList = list;
    });
  }

  _buildUserList() async {
    UserAPI userAPI = UserAPI();
    List<Users> list = await userAPI.allUser();
    setState(() {
      userList = list;
    });
  }

  getSelectedHospital(hospitalName) {
    for (var i = 0; i < hospitalList.length; i++) {
      var hosp = hospitalList[i];
      if (hospitalName == hosp.hospitalName) {
        return hosp;
      }
    }
  }

  getSelectedUsers(availability) {
    switch (availability) {
      case "All":
        var getUserList = userList;
        List<CampaignSendTo> newUserList = [];
        var userTokenList = [];
        for (var i = 0; i < userList.length; i++) {
          var eachUser = userList[i];
          CampaignSendTo listUser = CampaignSendTo(
            donorID: eachUser.donorID,
            donorName: eachUser.donorName,
            campaignStatus: "send",
            readTime: "",
          );
          newUserList.add(listUser);
          userTokenList.add("\"${eachUser.donorFcmToken}\"");
        }
        // send notification to the selected user 
        pushNotificationsGroupDevice(userTokenList);
        return newUserList;
      case "Not Donate":
        
        break;
      case "Donate":
        
        break;
      case "Critical Blood":
        
        break;
    }

  }

  buttonCreateAnnouncement() async{
    String title = _titleController.text;
    String description = _descController.text;
    String hospital = selectedHospital;
    String availability = "All";
    // String availability = selectedAvailability;

    try {
      Hospital selectedHosp = getSelectedHospital(hospital);
      List<CampaignSendTo> selectedUsers = getSelectedUsers(availability);
      DateTime now = DateTime.now();
      String isoDate = now.toIso8601String();

      Campaign newCampaign = Campaign(
        campaignId: '',
        campaignDate: isoDate,
        campaignTitle: title,
        campaignDesc: description,
        campaignRequire: availability,
        place: selectedHosp.hospitalID,
        postcode: selectedHosp.hospitalPoscode, 
        timeEnd: '', 
        timeStart: '', 
        campaignSend: [],
      );

      // store campaign data & notifications users to database
      CampaignAPI().addCampaignWithUsers(newCampaign,selectedUsers);

      // navigate to add page if succeed
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
            builder: (context) => News()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submit Failed. Please try again'),
        ),
      );
    }
  }

  // send to all
  Future<bool> _submitButton({required String title,required String body,}) async {
    String dataNotifications = '{ '
        ' "to" : "/topics/myTopic1" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    print(dataNotifications.toString());
    return true;
  }

  // send to certain devices
  Future<bool> pushNotificationsGroupDevice(userTokenList) async {
    String dataNotifications = '{'
        '"operation": "create",'
        '"notification_key_name": "appUser-testUser",'
        '"registration_ids":${userTokenList},'        
        '"notification" : {'
          '"title":"${_titleController.text}",'
          '"body":"${_descController.text}"'
          ' }'
        ' }';

    var response= await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
        'project_id': "${Constants.SENDER_ID}"
      },
      body: dataNotifications,
    );

    print(response.body.toString());
    return true;
  }

  Widget newsForm() {
    List<String> selectedHospitalOptions = [];
    List<String> options = ['All', 'Not Donate', 'Donated', 'Critical Blood'];

    return Container(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: MySpacing.nTop(20),
          child: Form(
            // key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 0, right: 20, top: 0, bottom: 12),
                  child: MyText.titleMedium("Create Announcement", fontWeight: 600),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.border,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  maxLines: null,
                  minLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.border,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                    contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,5),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(10,5,10,5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          selectedAvailability.isEmpty ? 'Choose Availability' : selectedAvailability,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: selectedAvailability.isEmpty ? null : selectedAvailability,
                        onChanged: (String? value) {
                          setState(() {
                            selectedAvailability = value!;
                          });
                        },
                        items: options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,5,0,5),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(10,5,10,5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          selectedHospital.isEmpty ? 'Choose Hospital' : selectedHospital,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: selectedHospital.isEmpty ? null : selectedHospital,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHospital = newValue!;
                          });
                        },
                        items: hospitalList.map<DropdownMenuItem<String>>((Hospital hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital.hospitalName,
                            child: Text(hospital.hospitalName),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                MyButton.block(
                  elevation: 0,
                  borderRadiusAll: 8,
                  padding: MySpacing.y(20),
                  backgroundColor: AppTheme.customTheme.medicarePrimary,
                  onPressed: () {
                    buttonCreateAnnouncement();
                    // pushNotificationsGroupDevice();
                  },
                  child: MyText.bodyLarge(
                    'Submit',
                    color: AppTheme.customTheme.medicareOnPrimary,
                    fontWeight: 600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          MySpacing.height(32),
          newsForm(),
        ]
      ),
    );
  }
}