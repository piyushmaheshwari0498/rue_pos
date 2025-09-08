import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_posx/core/mobile/home/ui/product_list_home.dart';
import 'package:nb_posx/core/service/login/api/verify_instance_service.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/utils%20copy/helpers/sync_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../service/api_cat_pro/api/cat_pro_api_service.dart';
import '../../../service/login/api/login_api_service.dart';
import '../../../service/login/model/api_login_common_response.dart';
import '../../../tablet/login/transaction_pin_screen.dart';
import '../../forgot_password/ui/forgot_password.dart';
import '../../home/ui/home_dashboard.dart';
import '../../webview_screens/enums/topic_types.dart';
import '../../webview_screens/ui/webview_screen.dart';
import 'mobile_pin_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  String? version;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _emailCtrl.text = "demouser@nestorbird.com";
    _passCtrl.text = "demouser@123";
    _urlCtrl.text = "getpos.in";
    _getAppVersion();
    _getDetails();
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // HubManager manager = await DbHubManager().getManager() as HubManager;

    setState(() {
      // _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  /* _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Close App Confirmation'),
          content: Text('Are you sure you want to close the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can add your code here to exit the app
                // For example, you can use SystemNavigator.pop() to exit the app.
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MAIN_COLOR,
        body: Stack(
          children: [
            GestureDetector(
              // onTap: _handleTap,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1.0,
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Center(
                                child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Container(
                                      width: 1000,
                                      padding: paddingXY(x: 5,y: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // const SizedBox(height: 10),
                                          // hightSpacer50,
                                          headingLblWidget(),
                                          // hightSpacer50,
                                          // instanceUrlTxtboxSection(context),
                                          // hightSpacer20,
                                          subHeadingLblWidgetPOS(),
                                          // hightSpacer20,
                                          subHeadingLblWidgetCounter(),

                                          MobileOTPKeyboardScreen(
                                                onPressed: () {
                                                  log("login press");
                                                },
                                              counter_id: _selectedCounterId,
                                                buttonText: 'Login'
                                            ),
                                            //_cartWidget()

                                        ],
                                      ),
                                    )),
                              )
                            ],
                          )),
                    ),

                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget subHeadingLblWidgetPOS() => Center(
    child: Text(
      POS_TXT,
      style: getTextStyle(
        color: WHITE_COLOR,
        fontWeight: FontWeight.bold,
        fontSize: MEDIUM_PLUS_FONT_SIZE,
      ),
    ),
  );

  Widget subHeadingLblWidgetCounter() => Center(
    child: Text(
      _selectedBranch.isNotEmpty
          ? "$_selectedBranch - $_selectedCounter"
          : "-",
      style: getTextStyle(
        color: WHITE_COLOR,
        fontWeight: FontWeight.bold,
        fontSize: LARGE_MINUS_FONT_SIZE,
      ),
    ),
  );

  Widget subHeadingLblWidget() => Center(
    child: Text(
      LOGIN_TXT,
      style: getTextStyle(
        // color: MAIN_COLOR,
        fontWeight: FontWeight.bold,
        fontSize: LARGE_FONT_SIZE,
      ),
    ),
  );


  /// HANDLE LOGIN BTN ACTION

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "$APP_VERSION - ${packageInfo.version}";
    });
  }

  ///Input field for entering the instance URL
  Widget instanceUrlTxtboxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                URL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _urlCtrl,
              hintText: URL_HINT,
            ),
          ],
        ),
      );

  /// LOGIN BUTTON

  /// EMAIL SECTION
  Widget emailTxtBoxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                EMAIL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _emailCtrl,
              hintText: EMAIL_HINT,
            ),
          ],
        ),
      );

  /// PASSWORD SECTION
  Widget passwordTxtBoxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                PASSWORD_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _passCtrl,
              hintText: PASSWORD_HINT,
              password: true,
            ),
          ],
        ),
      );

  /// FORGOT PASSWORD SECTION
  Widget forgotPasswordSection(context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                FORGET_PASSWORD_SMALL_TXT,
                style: getTextStyle(
                    color: MAIN_COLOR,
                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      );

  /// TERM AND CONDITION SECTION
  Widget termAndPolicySection(context) => Padding(
        padding: horizontalSpace(x: 40),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: BY_SIGNING_IN,
              style: getTextStyle(
                  color: DARK_GREY_COLOR,
                  fontSize: MEDIUM_FONT_SIZE,
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                      topicTypes:
                                          TopicTypes.TERMS_AND_CONDITIONS,
                                      apiUrl: "https://${_urlCtrl.text}/api/",
                                    )));
                      },
                    text: TERMS_CONDITIONS,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    text: AND_TXT,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: MEDIUM_FONT_SIZE)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                      topicTypes: TopicTypes.PRIVACY_POLICY,
                                      apiUrl: "https://${_urlCtrl.text}/api/",
                                    )));
                      },
                    text: PRIVACY_POLICY,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: MEDIUM_FONT_SIZE)),
              ]),
        ),
      );

  /// LOGIN TXT(HEADING) IN CENTER
  Widget headingLblWidget() => Center(
    // child: Text(
    //   "POS",
    //   style: getTextStyle(
    //     color: MAIN_COLOR,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 72.0,
    //   ),
    // ),
    child: Image.asset(
      APP_ICON_TABLET,
      height: 150,
      width: 200,
      color: WHITE_COLOR,
    ),
  );


  ///Method to check whether the API URL is correct.
  /* bool isValidInstanceUrl() {
    String url = "https://${_urlCtrl.text}/api/";
    return Helper.isValidUrl(url);
  }*/

  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);

    return false;
  }
}
