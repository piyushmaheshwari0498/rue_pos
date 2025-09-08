import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_posx/core/tablet/aniket/menus/cashier_lamdscape.dart';
import 'package:nb_posx/core/tablet/aniket/menus/printerMenu/printer_menu_landscape.dart';
import 'package:nb_posx/core/tablet/aniket/menus/settings/pinPad.dart';
import 'package:nb_posx/core/tablet/aniket/menus/stocks_landscape.dart';
import 'package:nb_posx/core/tablet/product/products_landscape.dart';
import 'package:nb_posx/core/tablet/tables/tableDine_landscape.dart';
import 'package:nb_posx/core/tablet/tables/tableDine_landscape_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';

import '../../database/db_utils/db_constants.dart';
import '../../database/db_utils/db_preferences.dart';
import 'aniket/menus/all_orders/all_orders_landscape.dart';
import 'aniket/menus/all_orders/all_orders_landscape_new.dart';
import 'aniket/menus/sales_landscape.dart';
import 'aniket/menus/sales_landscape_new.dart';
import 'aniket/menus/settings/settings.dart';
import 'create_order/create_order_landscape2.dart';
import 'customer/customers_landscape.dart';
import 'my_account/my_account_landscape.dart';
import 'transaction/transaction_screen_landscape.dart';
import 'widget/left_side_menu.dart';

// ignore: must_be_immutable
class HomeTablet extends StatelessWidget {
  var selectedTab = "New Order".obs;

  late Size size;

  late String name = "-";
  bool isCashierLogin = false;
  String _selectedTypeId = "";
  // late bool isCashierLogin = false;

  HomeTablet({super.key,required this.selectedTab});
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    size = MediaQuery.of(context).size;
    MediaQueryData queryData = MediaQuery.of(context);
    _getHubManager();
    config();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: queryData.size.width,
        height: queryData.size.height,
        child: Helper.checkOrientation(context)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 24,
                    child: Container(
                      color: const Color(0xFFF9F8FB),
                      padding: paddingXY(),
                      child: Obx(() => SizedBox(
                            // width: size.width - 120,
                            height: size.height,
                            child: _getSelectedView(),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: LeftSideMenu(selectedView: selectedTab, name: name),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: LeftSideMenu(selectedView: selectedTab, name: name),
                  ),
                  Expanded(
                    flex: 17,
                    child: Container(
                      color: const Color(0xFFF9F8FB),
                      padding: paddingXY(),
                      child: Obx(() => SizedBox(
                            // width: size.width - 120,
                            height: size.height,
                            child: _getSelectedView(),
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void config() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  Future<void> _getHubManager() async {
    HubManager? manager = await DbHubManager().getManager();
    Helper.hubManager = manager;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DBPreferences dbPreferences = DBPreferences();
    // name = await DBPreferences().getPreference(HubUsername);
    name = manager!.name;

    _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    // userTypeId = prefs.getInt(UserTypeId)!;
    // setState(() {
      isCashierLogin = prefs.getBool(isNewCashierLogin) ?? false;
    // });
  }

  _getSelectedView() {
    switch (selectedTab.value) {
/*case "Home":
        //return const HomeLandscape();
        return CreateOrderLandscape(selectedView: selectedTab);*/
      case "New Order":
        return CreateOrderLandscape(selectedView: selectedTab);
      case "Tables":
        return TableDineLandscapeNew(
          onTabSelected: (tabName) {
            selectedTab.value = tabName;
          },
        );
      case "Sales":
        return SalesMenuLandscapeNew(
          type: 0,
        );
      case "Cashier":
        return CashierLandscape();
      case "Printer Settings":
        return PrinterMenuLandscape();
      case "Stock":
        return const StocksMenuLandscape();
      case "Product":
        return const ProductsLandscape();
      case "Customer":
        return const CustomersLandscape();
      case "Setting":
        if(_selectedTypeId == "1") {
          return const SettingsLandscape();
        }else{
          return const PINLandscape();
        }
      case "ASetting":
          return const SettingsLandscape();
      case "History":
        return TransactionScreenLandscape(
          selectedView: selectedTab,
        );
      case "Orders":
        return const CurrentOrdersLandscape();
    }
  }
}
