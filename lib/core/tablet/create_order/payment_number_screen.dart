import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/theme_config.dart';
import '../../../constants/app_constants.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/db_utils/db_hub_manager.dart';
import '../../../database/db_utils/db_preferences.dart';
import '../../../database/models/hub_manager.dart';
import '../../../database/models/order_item.dart';
import '../../../network/api_helper/api_status.dart';
import '../../../../../utils/helper.dart';
import '../../../utils copy/helpers/sync_helper.dart';
import '../../../utils copy/ui_utils/padding_margin.dart';
import '../../../utils copy/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/custom_button.dart';
import '../../../utils/ui_utils/custom_otp_textfield.dart';
import '../../../utils/ui_utils/keypad_button.dart';
import '../../service/api_cat_pro/api/cat_pro_api_service.dart';
import '../../service/login/api/login_api_service.dart';
import '../../service/login/model/api_login_common_response.dart';
import '../home_tablet.dart';

class CashKeyboardScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final double amount;
  final List<OrderItem> orderItem;

  GlobalKey<CashKeyboardScreenState> cashKey;

  CashKeyboardScreen(
      {Key? key,
      this.onPressed,
      this.buttonText,
      required this.amount,
      required this.orderItem,
      required this.cashKey})
      : super(key: key);

  @override
  State<CashKeyboardScreen> createState() => CashKeyboardScreenState();
}

class CashKeyboardScreenState extends State<CashKeyboardScreen> {
  String field1 = '';
  String field2 = '';

  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";

  @override
  void initState() {
    // TODO: implement initState
    field2 = "${widget.amount} BD";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _configureTaxAndTotal(widget.orderItem);

    return Container(
      padding: paddingXY(x: 10, y: 10),
      color: Colors.white,
      width: 400,
      height: 380,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Spacer(),
          // const SizedBox(height: 100),
          // hightSpacer50,
          /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CustomOTPTextField(field1),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedContainer(
                      height: 25,
                      width: 120,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 650),
                      child: Center(
                          child: Text(
                        field1.isNotEmpty ? field1 : field2 ,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: getTextStyle(
                            fontSize: LARGE_ULTRA_PLUS_SIZE,
                            fontWeight: FontWeight.bold),
                      ))))
            ],
          ),*/
          // const Spacer(),
          // const SizedBox(height: 50),
          // hightSpacer50,
          // const Spacer(),

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
              buildNumberButton("."),
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
      });

  _isButtonPressed(String text) {
    setState(() {

      if (text == ".") {}
      field1 = field1 + text;
      // field1 = field1 + text;
      // Get.back(result: field1);

      widget.cashKey.currentState?.field1 = field1;

      log("_isButtonPressed ${widget.cashKey.currentState?.field1}");
    });
  }

  Widget buildNumberButton(String text) => Expanded(
      child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: _isButtonPressed(text),
        onTapUp: (details) => false,
        onTapDown: (details) => false,
        child: Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            // duration: const Duration(milliseconds: 650),
            decoration: BoxDecoration(
              border: Border.all(color: TABLET_BG_COLOR, width: 1),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Center(
              child: Text(text,
                  style: getTextStyle(
                      fontSize: LARGE_ULTRA_PLUS_SIZE,
                      fontWeight: FontWeight.bold)),
            )),
      )));

  Widget buildClearButton() => KeypadButton(
        onPressed: () => setState(
          () {
            // if (field4.isNotEmpty) {
            //   field4 = '';
            // } else if (field3.isNotEmpty) {
            //   field3 = '';
            // } else if (field2.isNotEmpty) {
            //   field2 = '';
            // } else if (field1.isNotEmpty) {
            field1 = field1.substring(0, field1.length - 1);

            widget.cashKey.currentState?.field1 = field1;

            // }
          },
        ),
        child: const Icon(Icons.backspace_outlined),
      );

  Widget buildBiometricButton() => KeypadButton(
        onPressed: () {},
        child: const Text(""),
      );

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

  _configureTaxAndTotal(List<OrderItem> items) {
    totalAmount = 0.0;
    subTotalAmount = 0.0;
    taxAmount = 0.0;
    totalItems = 0;
    taxPercentage = 0;
    for (OrderItem item in items) {
      //taxPercentage = taxPercentage + (item.tax * item.orderedQuantity);
      // log('Tax Percentage after adding ${item.name} :: $taxPercentage');
      // log("${item.price} ${item.orderedQuantity}$subTotalAmount");
      subTotalAmount = subTotalAmount + (item.price * item.orderedQuantity);
      // log('SubTotal after adding ${item.name} :: $subTotalAmount');
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          //taxPercentage = taxPercentage + attribute.tax;
          // log('Tax Percentage after adding ${attribute.name} :: $taxPercentage');
          // if (attribute.options.isNotEmpty) {
          //   for (var options in attribute.options) {
          if (attribute.qty != 0) {
            //taxPercentage = taxPercentage + options.tax;
            subTotalAmount = subTotalAmount + attribute.rate * attribute.qty;
            // log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
          }
        }
        // }
        // }
      }
    }
    //taxAmount = (subTotalAmount / 100) * taxPercentage;
    totalAmount = subTotalAmount + taxAmount;
    // field1 = "${widget.amount} BD";
    //return taxPercentage;
    setState(() {});
  }
}
