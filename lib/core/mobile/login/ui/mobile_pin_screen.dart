import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/core/mobile/home/ui/home_dashboard.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../network/api_helper/api_status.dart';
import '../../../../utils copy/helpers/sync_helper.dart';
import '../../../../utils copy/ui_utils/padding_margin.dart';
import '../../../../utils copy/ui_utils/spacer_widget.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/custom_otp_textfield.dart';
import '../../../../utils/ui_utils/keypad_button.dart';
import '../../../service/api_cat_pro/api/cat_pro_api_service.dart';
import '../../../service/login/api/login_api_service.dart';
import '../../../service/login/model/api_login_common_response.dart';
import '../../home/ui/product_list_home.dart';


class MobileOTPKeyboardScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final String? counter_id;
  const MobileOTPKeyboardScreen({Key? key, this.onPressed, this.buttonText,this.counter_id})
      : super(key: key);

  @override
  State<MobileOTPKeyboardScreen> createState() => _OTPKeyboardScreenState();
}

class _OTPKeyboardScreenState extends State<MobileOTPKeyboardScreen> {
  String field1 = '';
  String field2 = '';
  String field3 = '';
  String field4 = '';

  String _errorMsg = "";
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: paddingXY(x: 10, y: 10),
    color: MAIN_COLOR,
    width: 400,
    height: 700  ,
    child:  Center (

    child : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Spacer(),
        // const SizedBox(height: 100),
        // hightSpacer50,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomOTPTextField(field1),
            CustomOTPTextField(field2),
            CustomOTPTextField(field3),
            CustomOTPTextField(field4),

          ],
        ),

        if (_isError) SizedBox(height: 10),

        Visibility(
          visible: _isError,
          child: Container(
            width: 300,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              _errorMsg ?? "",
              style: getTextStyle(
                color: Colors.white,
                fontSize: LARGE_MINUS_FONT_SIZE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Row(
          children: [
            buildNumberButton('1'),
            buildNumberButton('2'),
            buildNumberButton('3')
          ],
        ),
        Row(
          children: [
            buildNumberButton('4'),
            buildNumberButton('5'),
            buildNumberButton('6')
          ],
        ),
        Row(
          children: [
            buildNumberButton('7'),
            buildNumberButton('8'),
            buildNumberButton('9')
          ],
        ),
        Row(
          children: [
            buildBiometricButton(),
            buildNumberButton('0'),
            buildClearButton()
          ],
        ),
        // const SizedBox(height: 100),
        // Center(
        //   child: CustomButton(
        //     onPressed: widget.onPressed,
        //     text: widget.buttonText,
        //   ),
        // )
      ],
    )),
    );
  }

  void resetFieldOnExit() => setState(() {
    field1 = '';
    field2 = '';
    field3 = '';
    field4 = '';
  });


  double getResponsiveIconSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) return 50.0; // Large tablets
    if (width > 600) return 8.0; // Small tablets
    return 18.0; // Phones
  }
  Widget buildNumberButton(String text) => KeypadButton(
    onPressed: () => setState(() {
      _isError = false;
      _errorMsg = "";
      if (field1.isEmpty) {
        field1 = text;
      } else if (field2.isEmpty) {
        field2 = text;
      } else if (field3.isEmpty) {
        field3 = text;
      } else if (field4.isEmpty) {
        field4 = text;
        String pin = field1 + field2 + field3 + field4;
        login(pin, widget.counter_id!, "");
        widget.onPressed;
      }
    }),
    child: buildButtonContainer(
      child: Text(
        text,
        style: getTextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget buildClearButton() => KeypadButton(
    onPressed: () => setState(() {
      if (field4.isNotEmpty) {
        field4 = '';
      } else if (field3.isNotEmpty) {
        field3 = '';
      } else if (field2.isNotEmpty) {
        field2 = '';
      } else if (field1.isNotEmpty) {
        field1 = '';
      }
    }),
    child: buildButtonContainer(
      child: Icon(
        Icons.backspace_outlined,
        color: Colors.black87,
        size: getResponsiveIconSize(context) * 1.2, // slightly smaller
      ),
    ),
  );

  Widget buildButtonContainer({required Widget child}) => Container(
    height: 100, // Adjust as per your design (previously 120)
    width: 100,
    margin: EdgeInsets.all(8), // Space between buttons
    decoration: BoxDecoration(
      color: TABLET_BG_COLOR, // Background color (matches design)
      border: Border.all(color: Colors.white, width: 2),
      shape: BoxShape.circle,
    ),
    child: Center(child: child),
  );

  Widget buildBiometricButton() => KeypadButton(
    onPressed: () {},
    child: const Text(""),
  );

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

          await dbPreferences.savePreference(
              isNewCashierLogin, response.response.data["NewCashierLogin"]);

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

          bool isSalesOn = false;
          bool isPaymentOn = false;
          if (response.response.data["userdata"]["UserTypeId"] == 1) {
            isSalesOn = prefs.getBool(isSalesOverview) ?? false;
            isPaymentOn = prefs.getBool(isPayment) ?? false;
          }
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(isSubCategory, true);

          Helper.hideLoader(context);

          // Get.offAll(() => ProductListHome());
          Get.offAll(() => HomeDashboard());
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => HomeDashboard()));
        } else {

          resetFieldOnExit();
          if (!mounted) return;
          setState(() {
            _isError = true;
            _errorMsg = response.message;
          });

          Helper.hideLoader(context);
          // Helper.showPopup(context, response.message!);
        }
        //   }
        //   else{
        // Helper.showPopup(context, "Please update your app to latest version",
        //         barrierDismissible: true);
        //   }
      } else {
        // Helper.hideLoader(ctx);
        // ignore: use_build_context_synchronously
        resetFieldOnExit();
        setState(() {
          _isError = true;
          _errorMsg = NO_INTERNET;
        });
        // Helper.showPopup(
        //     context, NO_INTERNET,
        //     barrierDismissible: true);
      }
    } catch (e) {
      print(e);
      resetFieldOnExit();
      Helper.hideLoader(context);
      setState(() {
        _isError = true;
        _errorMsg = SOMETHING_WRONG;
      });
      // Helper.showSnackBar(context, SOMETHING_WRONG);
      // if (e is SocketException) {
      //   // ignore: unrelated_type_equality_checks
      //   if ((e).osError == 7) {
      //     print('***** Exception Caught *****');
      //   }
      // }
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
}