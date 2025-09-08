import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/tablet/customer/customers_landscape.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/button.dart';
import '../../../database/db_utils/db_customer.dart';
import '../../../database/models/customer.dart';
import '../login/login_landscape.dart';

class DeleleCusPopupView extends StatefulWidget {

  Customer customer;
  DeleleCusPopupView({Key? key,required this.customer}) : super(key: key);

  @override
  State<DeleleCusPopupView> createState() => _LogoutPopupViewState();
}

class _LogoutPopupViewState extends State<DeleleCusPopupView> {
  /// LOGIN BUTTON
  Widget get cancelBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => Get.back(),
          title: "Cancel",
          colorBG: DARK_GREY_COLOR,
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  Widget get logoutConfirmBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => handleLogout(),
          title: "Delete",
          colorBG: MAIN_COLOR,
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  Future<void> handleLogout() async {
    // await SyncHelper().logoutFlow();
    // Get.offAll(() => const CustomersLandscape());
    Get.back();
    await DbCustomer().deleteCustomer(widget.customer.id);

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Confirm",
              style: getTextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          hightSpacer10,
          Text("Are you sure, you want to delete \nCustomer: ${widget.customer.name}",
              style: getTextStyle(
                  fontSize: LARGE_FONT_SIZE, fontWeight: FontWeight.w500)),
          hightSpacer10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cancelBtnWidget, logoutConfirmBtnWidget],
          ),
        ],
      ),
    );
  }
}
