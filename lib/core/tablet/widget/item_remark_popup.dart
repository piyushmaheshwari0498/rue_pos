import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/api_category.dart' as dbcat;

import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../database/db_utils/db_constants.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/order_item.dart';
import '../../../database/models/split_bill_model.dart';
import '../../../network/api_helper/api_status.dart';
import '../../../utils copy/ui_utils/textfield_border_decoration.dart';
import '../../../utils/ui_utils/keypad_button.dart';
import '../../../widgets/multitext_field_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../create_order/payment_number_screen.dart';
import '../login/transaction_pin_screen.dart';
import 'hotel_tab_screen.dart';

// ignore: must_be_immutable
class ItemRemarkPopup extends StatefulWidget {
  String message;

  ItemRemarkPopup({Key? key,required this.message}) : super(key: key);

  @override
  State<ItemRemarkPopup> createState() => _ItemRemarkPopupState();
}

class _ItemRemarkPopupState extends State<ItemRemarkPopup> {

  late TextEditingController orderRemarkCtrl;
  List<TextEditingController> remarkCtrl = [];

  @override
  void initState() {
    super.initState();

    remarkCtrl = [];
    orderRemarkCtrl = TextEditingController();

    orderRemarkCtrl.text = widget.message.isNotEmpty ? widget.message : "";
  }

  @override
  Widget build(BuildContext context) {
    // _configureTaxAndTotal(widget.orderItem);
/*
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.max,
            children: <Widget>[
          Center(
            child: Container(
                width: defaultTargetPlatform ==
                    TargetPlatform.iOS
                    ? 630 : MediaQuery.of(context).size.width / 2 ,
                height: 400,
                padding: paddingXY(x: 10, y: 10),
                decoration: BoxDecoration(
                  color: TABLET_BG_COLOR,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 0.05)],
                  border: Border.all(width: 1, color: GREY_COLOR),
                ),
                child: Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Remark",
                              style: getTextStyle(
                                  fontSize: LARGE_PLUS_FONT_SIZE,
                                  color: WHITE_COLOR),
                            )),
                        Spacer(),
                        Row(children: [
                          Visibility(
                              visible: true,
                              child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                      padding: miniPaddingAll(),
                                      child: SvgPicture.asset(CROSS_ICON,
                                          height: 20,
                                          color: Colors.white,
                                          fit: BoxFit.contain)))),
                        ]),
                        hightSpacer20,
                      ],
                    ),
                    hightSpacer5,
                Expanded(
                    child: Center(
                      child:
                      Container(
                      alignment: Alignment.center,
                      padding: paddingXY(x: 0, y: 0),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 330,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 600,
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [

                                    hightSpacer20,

                                    Container(
                                        width: 400,
                                        // height: 100,
                                        padding: horizontalSpace(),
                                        child: MultiTextFieldWidget(
                                          boxDecoration:
                                              txtFieldBorderDecoration,
                                          txtCtrl: orderRemarkCtrl,
                                          hintText: "Remark",
                                          inputType: 2,
                                          txtColor: DARK_GREY_COLOR,
                                        )),
                                    hightSpacer20,

                                    InkWell(
                                            onTap: () {
                                              // _newCustomerAPI();
                                              // customer = Customer(
                                              //     id: emailCtrl.text,
                                              //     name: nameCtrl.text ?? "Guest",
                                              //     email: emailCtrl.text,
                                              //     phone: phoneCtrl.text,
                                              //     isSynced: false,
                                              //     modifiedDateTime: DateTime.now()
                                              //   // ward: Ward(id: "01", name: "name"),
                                              //   // profileImage: Uint8List.fromList([]),
                                              // );
                                              // if (customer != null) {
                                              Get.back(
                                                  result:
                                                  orderRemarkCtrl.text.isNotEmpty ? orderRemarkCtrl.text : "");
                                              // }
                                            },
                                            child: Container(
                                              width: 380,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: MAIN_COLOR,
                                                // phoneCtrl.text.length == 10 && nameCtrl.text.isNotEmpty
                                                //     ? MAIN_COLOR
                                                //     : MAIN_COLOR.withOpacity(0.3),
                                                // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.3)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Save",
                                                  textAlign: TextAlign.center,
                                                  style: getTextStyle(
                                                      fontSize: LARGE_FONT_SIZE,
                                                      color: WHITE_COLOR,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          )
                                       ,

                                    // SizedBox(height: 100,)
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ))),
                  ],
                ))),
          ),
        ]),
      ),
    );*/
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Container(
                width: defaultTargetPlatform == TargetPlatform.iOS
                    ? 630
                    : Device.get().isTablet ? MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width * 0.90,
                height: 400,
                padding: paddingXY(x: 10, y: 10),
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 0.05)],
                  border: Border.all(width: 1, color: GREY_COLOR),
                ),
                child: Column(
                  children: [
                    // Title and Close Button
                    Row(
                      children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Remark",
                            style: getTextStyle(
                              fontSize: LARGE_PLUS_FONT_SIZE,
                              color: WHITE_COLOR,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(children: [
                          Visibility(
                            visible: true,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: miniPaddingAll(),
                                child: SvgPicture.asset(
                                  CROSS_ICON,
                                  height: 20,
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    hightSpacer20,

                    // The 2nd Container (Centered Content)
                    Expanded(
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: paddingXY(x: 0, y: 0),
                          decoration: const BoxDecoration(
                            color: GREY_COLOR,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 330,
                          child: Center( // Ensure everything inside is centered
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Keep elements centered
                              children: [
                                // hightSpacer20,

                                // Remark TextField
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  padding: horizontalSpace(),
                                  // decoration: txtFieldBorderDecoration, // Apply the updated decoration here
                                  child: MultiTextFieldWidget(
                                    boxDecoration: BoxDecoration(color: Colors.white), // No extra decoration inside
                                    txtCtrl: orderRemarkCtrl,
                                    hintText: "Remark",
                                    inputType: 2,
                                    txtColor: Colors.black,
                                  ),
                                ),

                                hightSpacer20,

                                // Save Button
                                InkWell(
                                  onTap: () {
                                    Get.back(
                                        result: orderRemarkCtrl.text.isNotEmpty
                                            ? orderRemarkCtrl.text
                                            : "");
                                  },
                                  child: Container(
                                    width: 380,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: MAIN_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Save",
                                        textAlign: TextAlign.center,
                                        style: getTextStyle(
                                          fontSize: LARGE_FONT_SIZE,
                                          color: WHITE_COLOR,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
