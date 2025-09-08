import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_posx/utils/helper.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/db_utils/db_sale_order.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/long_button_widget.dart';
import '../../../service/create_order/api/create_sales_order.dart';
import '../../create_order_new/ui/new_create_order.dart';
import '../../home/ui/product_list_home.dart';

class SaleSuccessScreen extends StatefulWidget {
  final SaleOrder placedOrder;

  const SaleSuccessScreen({Key? key, required this.placedOrder})
      : super(key: key);

  @override
  State<SaleSuccessScreen> createState() => _SaleSuccessScreenState();
}

class _SaleSuccessScreenState extends State<SaleSuccessScreen> {
  @override
  void initState() {
    super.initState();
    log("${widget.placedOrder}");
    CreateOrderService().createOrder(widget.placedOrder).then((value) {
      if (value.status!) {
        // print("create order response::::YYYYY");
        SaleOrder order = widget.placedOrder;
        order.transactionSynced = true;
        order.id = value.message;
        //order.save();

        DbSaleOrder().createOrder(order).then((value) {
          debugPrint('order sync and saved to db');
          //Helper.showPopup(context, "Order synced and saved locally");
        });
      } else {
        DbSaleOrder().createOrder(widget.placedOrder).then((value) {
          debugPrint('order saved to db');
          Helper.showPopup(context,
              "Order saved locally, and will be synced when you restart the app.");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the HomeScreen when the back button is pressed
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProductListHome()),
            (route) => false, // Remove all other routes from the stack
          );
          return true; // Prevent default back button behavior
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Center(
            child: Lottie.asset(SUCCESS_IMAGE,
                animate:
                    true),
              ),
              hightSpacer30,
              Text(
                SALES_SUCCESS_TXT,
                style: getTextStyle(
                    fontSize: LARGE_FONT_SIZE,
                    color: BLACK_COLOR,
                    fontWeight: FontWeight.w600),
              ),
              hightSpacer30,
              //rajni
              LongButton(
                isAmountAndItemsVisible: false,
                buttonTitle: "Print Receipt",
                onTap: () {
                  _printInvoice();
                },
              ),
              // LongButton(
              //   isAmountAndItemsVisible: false,
              //   buttonTitle: RETURN_TO_HOME_TXT,
              //   onTap: () {
              //     Navigator.popUntil(context, (route) => route.isFirst);
              //   },
              // ),
              LongButton(
                isAmountAndItemsVisible: false,
                buttonTitle: "New Order",
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => NewCreateOrder()),
                      (route) => route.isFirst);
                },
              ),
            ],
          ),
        ));
  }

  //TODO:: Need to handle the print receipt here
  _printInvoice() async {
    try {
      bool isPrintSuccessful = await Helper().printInvoice(context,widget.placedOrder);
      if (!isPrintSuccessful && mounted) {
        Helper.showPopup(context, "Print operation cancelled by you.");
      }
    } catch (e) {
      Helper.showPopup(context, SOMETHING_WENT_WRONG);
      log('Exception ocurred in printing invoice :: $e');
    }
  }
}
