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
import '../../service/api_cancel_order/api/api_cancelorder_service.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../create_order/payment_number_screen.dart';
import '../login/transaction_pin_screen.dart';
import 'hotel_tab_screen.dart';

// ignore: must_be_immutable
class CancelOrderPopup extends StatefulWidget {
  // Customer? customer;
  int orderId;
  // List<OrderItem> orderItem;

  CancelOrderPopup({Key? key,required this.orderId}) : super(key: key);

  @override
  State<CancelOrderPopup> createState() => _CancelOrderPopupState();
}

class _CancelOrderPopupState extends State<CancelOrderPopup> {

  late TextEditingController cancelRemarkCtrl;

  late GlobalKey<CashKeyboardScreenState> cashKey;

  @override
  void initState() {
    super.initState();
    cashKey = GlobalKey();
    cancelRemarkCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: Device.get().isTablet
                    ? defaultTargetPlatform == TargetPlatform.iOS
                        ? 630
                        : MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 1.02,
                padding: paddingXY(x: 10, y: 10),
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 0.05)],
                  border: Border.all(width: 1, color: GREY_COLOR),
                ),
                height: 500,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel Order",
                            style: getTextStyle(
                              fontSize: LARGE_PLUS_FONT_SIZE,
                              color: WHITE_COLOR,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
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
                          ],
                        ),
                        hightSpacer20,
                      ],
                    ),
                    hightSpacer5,
                    Expanded(
                      child: Center(
                        // Centering the child content
                        child: Container(
                          padding: paddingXY(x: 0, y: 0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          width: Device.get().isTablet
                              ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 0.50,
                          // Set a fixed width to keep it centered
                          height: 430,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Centers vertically
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Centers horizontally
                            children: [
                              // _paymentModeSection(),
                              hightSpacer20,
                              Container(
                                width: 400,
                                padding: horizontalSpace(),
                                child: MultiTextFieldWidget(
                                  boxDecoration: txtFieldBorderDecoration,
                                  txtCtrl: cancelRemarkCtrl,
                                  prefixText: appCurrency2,
                                  hintText: "Remark",
                                  inputType: 2,
                                  txtColor: DARK_GREY_COLOR,
                                ),
                              ),
                              hightSpacer20,

                              InkWell(
                                      onTap: () {
                                        String remark = cancelRemarkCtrl.text.trim();

                                        if (remark.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Please enter a remark before cancelling.")),
                                          );
                                          return;
                                        }

                                        _cancelOrder(widget.orderId, remark);
                                      },
                                      child: Container(
                                        width: Device.get().isTablet
                                            ? 380 : 200,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: MAIN_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel Order",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelOrder(int orderId, String remark) async {
    try {
      final response = await CancelOrderApiService().cancel_order(
        orderId: orderId,
        remark: remark,
      );

      if (response.status == 1) {
        // Get.back(result: true); // 🔥 success case
        Navigator.pop(context, true);
      } else {
        Get.snackbar("Error", response.message ?? "Failed to cancel order");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

}
