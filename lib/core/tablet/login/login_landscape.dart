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
import '../../mobile/webview_screens/enums/topic_types.dart';
import '../../mobile/webview_screens/ui/webview_screen.dart';
import '../../service/login/api/login_api_service.dart';
import '../forgot_password/forgot_password_landscape.dart';
import '../home_tablet.dart';

class LoginLandscape extends StatefulWidget {
  const LoginLandscape({Key? key}) : super(key: key);

  @override
  State<LoginLandscape> createState() => _LoginLandscapeState();
}

class _LoginLandscapeState extends State<LoginLandscape> {
  late TextEditingController _emailCtrl, _passCtrl, _urlCtrl;
  late BuildContext ctx;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _emailCtrl.text = "1987";
    _passCtrl.text = "15";
    _urlCtrl.text = "";

    // _getAppVersion();
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: WHITE_COLOR,
        body: Stack(
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
                        headingLblWidget(),
                        // hightSpacer50,
                        // instanceUrlTxtboxSection(context),
                        // hightSpacer20,
                        subHeadingLblWidget(),
                        hightSpacer50,
                        emailTxtboxSection(),
                        hightSpacer20,
                        passwordTxtboxSection(),
                        // hightSpacer20,
                        // forgotPasswordSection(),
                        hightSpacer20,
                        // termAndPolicySection,
                        // hightSpacer32,
                        loginBtnWidget(),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  /// HANDLE LOGIN BTN ACTION
  Future<void> login(String email, String password, String url) async {
    try {
      Helper.showCustomLoaderDialog(context, PLEASE_WAIT_TXT);

      ///
      // CommanResponse res = await VerificationUrl.checkAppStatus();
// if(res.message==true){\\

      var isInternetAvailable = await Helper.isNetworkAvailable();

      if (isInternetAvailable) {
      APILoginCommanResponse response =
          await LoginService.login(email, password, url);

      if (response.apiStatus == ApiStatus.REQUEST_SUCCESS) {
        //API success
        // if (response.message!.successKey == 1) {
        DBPreferences dbPreferences = DBPreferences();

        // Saving API Key and API secret in database.
        await dbPreferences.savePreference(
            ApiKey, response.response.data["Token"]);
        await dbPreferences.savePreference(
            ApiSecret, response.response.data["Token"]);
        await dbPreferences.savePreference(
            HubManagerId, response.response.data["userdata"]["id"]);

        DbHubManager dbHubManager = DbHubManager();
        var image = Uint8List.fromList([]);
        HubManager hubManager = HubManager(
          id: '${response.response.data["userdata"]["id"]}',
          name: response.response.data["userdata"]["UserName"],
          phone: "",
          emailId: "",
          profileImage: image,
          cashBalance: 0.0,
          branchid: 0,
          branchname: "",
          counterid: 0,
          countername: "",

        );

        //Saving the HubManager data into the database
        await dbHubManager.addManager(hubManager);

        await SyncHelper().loginFlow();
        // }
        // ignore: use_build_context_synchronously

        Helper.showCustomLoaderDialog(context,"Setting Local Environment");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _selectedBranchId = prefs.getString(BranchId) ?? '';
        // await CatProductService.getProducts(_selectedBranchId);

        Helper.hideLoader(ctx);

        Get.offAll(() => HomeTablet(selectedTab: "New Order".obs,));
      } else {
        if (!mounted) return;
        Helper.hideLoader(ctx);
        Helper.showPopup(ctx, response.message!);
      }
      //   }
      //   else{
      // Helper.showPopup(context, "Please update your app to latest version",
      //         barrierDismissible: true);
      //   }
      } else {
        Helper.hideLoader(ctx);
        // ignore: use_build_context_synchronously
        Helper.showPopup(
            context, NO_INTERNET,
            barrierDismissible: true);
      }
    } catch (e) {
      print(e);
      Helper.hideLoader(ctx);
      Helper.showSnackBar(context, SOMETHING_WRONG);
      if (e is SocketException) {
        // ignore: unrelated_type_equality_checks
        if ((e).osError == 7) {
          print('***** Exception Caught *****');
        }
      }
      // httpClient.close();
      print('Force closing previous connections');
      // httpClient = http.Client() as http.BaseClient;
      print('Creating new HttpClient instance');
    }

    // on DioError catch (e) {
    //   Helper.hideLoader(ctx);
    //   log('Exception Caught :: $e');
    //   Helper.showSnackBar(context, SOMETHING_WRONG);
    // }
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);

    return false;
  }

  ///Input field for entering the instance URL
  Widget instanceUrlTxtboxSection(context) => Padding(
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
          height: 250,
          width: 250,
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

  /// EMAIL SECTION
  Widget emailTxtboxSection() => Padding(
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
  Widget passwordTxtboxSection() => Padding(
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
  Widget forgotPasswordSection() => Row(
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
  Widget get termAndPolicySection => Padding(
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
                                builder: (context) => WebViewScreen(
                                    topicTypes: TopicTypes.TERMS_AND_CONDITIONS,
                                    apiUrl: "https://${_urlCtrl.text}/api/")));
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
                                  builder: (context) => WebViewScreen(
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

  /// LOGIN BUTTON
  Widget loginBtnWidget() => SizedBox(
        width: double.infinity,
        child: ButtonWidget(
          onPressed: () async {
            await DbInstanceUrl().deleteUrl();
            // String url = "https://${_urlCtrl.text}/api/";
            await login(_emailCtrl.text, _passCtrl.text, "");
          },
          title: "Log In",
          colorBG: MAIN_COLOR,
          // width: MediaQuery.of(context).size.width - 150,
          height: 60,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  ///Method to check whether the API URL is correct.
  /* bool isValidInstanceUrl() {
    String url = "https://${_urlCtrl.text}/api/";
    return Helper.isValidUrl(url);
  }*/
}
