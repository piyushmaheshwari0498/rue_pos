import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/cat_pro_api_service.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/product_common_response.dart';
import 'package:nb_posx/core/service/login/model/api_login_common_response.dart';
import 'package:nb_posx/core/tablet/login/transaction_pin_screen.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/models/hub_manager.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/utils%20copy/helpers/sync_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../database/db_utils/db_instance_url.dart';
import '../../../main.dart';
import '../../mobile/webview_screens/enums/topic_types.dart';
import '../../mobile/webview_screens/ui/webview_screen.dart';
import '../../service/login/api/login_api_service.dart';
import '../forgot_password/forgot_password_landscape.dart';
import '../home_tablet.dart';

class LoginLandscape2 extends StatefulWidget {
  const LoginLandscape2({Key? key}) : super(key: key);

  @override
  State<LoginLandscape2> createState() => _LoginLandscapeState();
}

class _LoginLandscapeState extends State<LoginLandscape2> {
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  late BuildContext ctx;

  String branch_counter = "";

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _emailCtrl.text = "1987";
    _passCtrl.text = "15";
    _urlCtrl.text = "";

    _getHubManager();

    _getDetails();

    // _getAppVersion();
  }

  _getHubManager() async {
    HubManager? manager = await DbHubManager().getManager();
    Helper.hubManager = manager;
    branch_counter = Helper.hubManager == null
        ? "-"
        : "${manager!.branchname} : ${manager.countername}";
    _selectedCounterId = Helper.hubManager == null ? "0" : "${manager?.counterid}";
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    /*return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MAIN_COLOR,
        body:
        Stack(
          children: [
            GestureDetector(
                // onTap: _handleTap,
                child: Row(
              children: [
                SizedBox(
                  width: isTabletMode
                      // ? double.infinity
                      ? MediaQuery.of(context).size.width / 1.8
                      : MediaQuery.of(context).size.width * 0.9,
                  height: isTabletMode
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height * 0.9,
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              width: 550,
                              padding: paddingXY(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 100),
                                  // hightSpacer50,
                                  headingLblWidget(),
                                  // hightSpacer50,
                                  // instanceUrlTxtboxSection(context),
                                  // hightSpacer20,
                                  subHeadingLblWidgetPOS(),
                                  hightSpacer20,
                                  subHeadingLblWidgetCounter(),
                                  // hightSpacer50,
                                  // emailTxtboxSection(),
                                  // hightSpacer20,
                                  // passwordTxtboxSection(),
                                  // // hightSpacer20,
                                  // // forgotPasswordSection(),
                                  // hightSpacer20,
                                  // // termAndPolicySection,
                                  // // hightSpacer32,
                                  // loginBtnWidget(),
                                ],
                              ),
                            )),
                      )
                    ],
                  )),
                ),
                Padding(
                  padding: leftSpace(x: 5),
                  child: OTPKeyboardScreen(
                      onPressed: () {
                        log("login press");
                      },
                      buttonText: 'Login'),
                  //_cartWidget()
                ),
              ],
            )),
          ],
        ),
      ),
    );*/
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MAIN_COLOR,
        body: Center( // Ensures everything is centered
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // Centers the Row content
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height, // Full height
                  child: Center( // Centers column content
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.50,
                        padding: paddingXY(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(height: 100),
                            headingLblWidget(),
                            hightSpacer20,
                            subHeadingLblWidgetPOS(),
                            hightSpacer20,
                            subHeadingLblWidgetCounter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Center( // Centers the OTP keyboard
                  child: Padding(
                    padding: leftSpace(x: 5),
                    child: OTPKeyboardScreen(
                      onPressed: () {
                        log("login press");
                      },
                      counter_id: _selectedCounterId,
                      buttonText: 'Login',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  /// HANDLE LOGIN BTN ACTION
  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);

    return false;
  }

  ///Input field for entering the instance URL
  Widget instanceUrlTxtboxSection(context) =>
      Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _urlCtrl,
            verticalContentPadding: 16,
            hintText: URL_HINT,
          ),
        ),
      );

  /// LOGIN TXT(HEADING) IN CENTER
  ///
  Widget headingLblWidget() =>
      Center(
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
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
      );

  Widget subHeadingLblWidgetPOS() =>
      Center(
        child: Text(
          POS_TXT,
          style: getTextStyle(
            color: WHITE_COLOR,
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.02
          ),
        ),
      );

  Widget subHeadingLblWidgetCounter() =>
      Center(
        child: Text(
          _selectedBranch.isNotEmpty
              ? "$_selectedBranch - $_selectedCounter"
              : "-",
          style: getTextStyle(
            color: WHITE_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
        ),
      );

  Widget subHeadingLblWidget() =>
      Center(
        child: Text(
          LOGIN_TXT,
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: HOME_TILE_HORIZONTAL_SPACING,
          ),
        ),
      );

  /// EMAIL SECTION
  Widget emailTxtboxSection() =>
      Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _emailCtrl,
            verticalContentPadding: 16,
            hintText: "Enter Login PIN",
          ),
        ),
      );

  /// PASSWORD SECTION
  Widget passwordTxtboxSection() =>
      Padding(
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _passCtrl,
            verticalContentPadding: 16,
            hintText: "Counter Id",
            password: false,
          ),
        ),
      );

  /// FORGOT PASSWORD SECTION
  Widget forgotPasswordSection() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _emailCtrl.clear();
              _passCtrl.clear();

              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordLandscape()));
            },
            child: Padding(
              padding: rightSpace(),
              child: Text(
                FORGET_PASSWORD_SMALL_TXT,
                style: getTextStyle(
                    color: MAIN_COLOR,
                    fontSize: LARGE_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );

  /// TERM AND CONDITION SECTION
  Widget get termAndPolicySection =>
      Padding(
        padding: horizontalSpace(x: 80),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: BY_SIGNING_IN,
              style: getTextStyle(
                  color: DARK_GREY_COLOR,
                  fontSize: LARGE_MINUS_FONT_SIZE,
                  fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            ctx,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WebViewScreen(
                                        topicTypes: TopicTypes
                                            .TERMS_AND_CONDITIONS,
                                        apiUrl: "https://${_urlCtrl
                                            .text}/api/")));
                      },
                    text: TERMS_CONDITIONS,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
                TextSpan(
                    text: AND_TXT,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        {
                          Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen(
                                          topicTypes: TopicTypes.PRIVACY_POLICY,
                                          apiUrl:
                                          "https://${_urlCtrl.text}/api/")));
                        }
                      },
                    text: PRIVACY_POLICY,
                    style: getTextStyle(
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: LARGE_MINUS_FONT_SIZE)),
              ]),
        ),
      );
}
