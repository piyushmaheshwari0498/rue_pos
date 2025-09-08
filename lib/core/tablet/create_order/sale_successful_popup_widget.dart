import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../../configs/theme_config.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/asset_paths.dart';
import '../../../database/models/order_item.dart';
import '../../../utils/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../widgets/long_button_widget.dart';

class SaleSuccessfulPopup extends StatelessWidget {
  String order_no;
  String amount;
  int items;
  List<OrderItem> orderList;

  SaleSuccessfulPopup(
      {Key? key,
      required this.orderList,
      required this.order_no,
      required this.amount,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, "new_order"),
                    child: SvgPicture.asset(
                      CROSS_ICON,
                      height: 20,
                      width: 20,
                      color: BLACK_COLOR,
                    ),
                  ))),
          Center(
            child: Text(
              order_no,
              style: getTextStyle(
                  fontSize: LARGE_PLUS_FONT_SIZE,
                  color: BLACK_COLOR,
                  fontWeight: FontWeight.bold),
            ), /*SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),*/
          ),
          Center(
            widthFactor: 1,
            child: Lottie.asset(SUCCESS_IMAGE,
                repeat: false,
                height: 350,
                animate:
                    true), /*SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),*/
          ),
          Text(
            "${amount.toString()} $appCurrency2",
            style: getTextStyle(
                fontSize: 45.0,
                color: BLACK_COLOR,
                fontWeight: FontWeight.bold),
          ),
          hightSpacer10,
          Text(
            "Order Successful",
            style: getTextStyle(
                fontSize: LARGE_PLUS_FONT_SIZE,
                color: BLACK_COLOR,
                fontWeight: FontWeight.bold),
          ),
          hightSpacer30,
          Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: LongButton(
                isTab: true,
                isAmountAndItemsVisible: false,
                totalAmount: amount.toString(),
                totalItems: items.toString(),
                buttonTitle: "Open Cash Drawer",
                onTap: () {
                  Navigator.pop(context, "home");
                },
              )),
          // Padding(
          //     padding: const EdgeInsets.only(left: 35, right: 35),
          //     child: LongButton(
          //       isAmountAndItemsVisible: false,
          //       buttonTitle: RETURN_TO_HOME_TXT,
          //       onTap: () {
          //         Navigator.pop(context, "home");
          //       },
          //     )),
          Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: LongButton(
                isTab: true,
                isAmountAndItemsVisible: false,
                buttonTitle: "Print Receipt",
                onTap: () {
                  Navigator.pop(context, "print_receipt");
                  // _printReceipt(cart.ordserNo!, listOrder);
                },
              )),
        ],
      ),
    );
  }



}
