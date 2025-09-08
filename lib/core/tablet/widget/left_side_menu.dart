import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
import 'package:nb_posx/database/models/hub_manager.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/theme_config.dart';
import '../../../constants/asset_paths.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/db_utils/db_preferences.dart';
import '../../../utils/ui_utils/padding_margin.dart';
import '../../../utils/ui_utils/spacer_widget.dart';
import '../../../utils/ui_utils/text_styles/custom_text_style.dart';

class LeftSideMenu extends StatefulWidget {
  final RxString selectedView;
  String name;

  LeftSideMenu({Key? key, required this.selectedView, required this.name})
      : super(key: key);

  @override
  State<LeftSideMenu> createState() => _LeftSideLandscapeState();
}

class _LeftSideLandscapeState extends State<LeftSideMenu> {
  String userName = "";
  String version = "";
  late MediaQueryData queryData;
  late bool isCashierLogin = false;

  @override
  void initState() {
    super.initState();

    _getDetails();

    getAppVersion();
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      userName = manager.name;
      isCashierLogin = prefs.getBool(isNewCashierLogin) ?? false;
      // isCashierLogin = true;
      // debugPrint("NewCashierLogin ${isCashierLogin.toString()}");
    });
  }

  double getResponsiveIconSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) return 60.0; // Large tablets
    if (width > 600) return 50.0; // Small tablets
    return 30.0; // Phones
  }

  double getResponsiveIconSize2(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (width >= 800) return 22.0; // Small tablets
    if (height < 800) return 40.0; // Large tablets
    return 18.0; // Phones
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Container(
      // width: Get.size.width - 1180,
      width: Helper.checkOrientation(context)
          ? defaultTargetPlatform == TargetPlatform.iOS
              ? 800
              : 1000
          : defaultTargetPlatform == TargetPlatform.iOS
              ? 80
              : 100,
      height: queryData.size.height,
      color: Helper.checkOrientation(context)
          ? MENU_TABLET_BG_COLOR
          : MENU_TABLET_BG_COLOR,
      child: Helper.checkOrientation(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(
                  flex: 1,
                ),
                _leftMenuSectionItem("New Order", ORDER_TAB_ICON, () {
                  widget.selectedView.value = "New Order";
                  // debugPrint("order");
                }),
                hightSpacer10,
                if (!isCashierLogin) ...[
                  _leftMenuSectionItem("Tables", ORDER_TAB_ICON, () {
                    widget.selectedView.value = "Tables";
                    // debugPrint("order");
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Orders", HISTORY_TAB_ICON, () {
                    widget.selectedView.value = "Orders";
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Cashier", PRODUCE_TAB_ICON, () {
                    widget.selectedView.value = "Cashier";
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Sales", ORDER_TAB_ICON, () {
                    widget.selectedView.value = "Sales";
                    // debugPrint("order");
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Stock", ORDER_TAB_ICON, () {
                    widget.selectedView.value = "Stock";
                    // debugPrint("order");
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Printer Setting", PRODUCE_TAB_ICON,
                      () {
                    widget.selectedView.value = "Printer Settings";
                  }),
                  hightSpacer10,
                  _leftMenuSectionItem("Setting", SETTING_TAB_ICON, () {
                    widget.selectedView.value = "Setting";
                  }),
                ],
                Spacer(
                  flex: 1,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Container(
                        color: MAIN_COLOR,
                        // Match your sidebar color
                        child: SingleChildScrollView(
                            child: Column(children: [
                          hightSpacer50,
                          Container(
                            child: Padding(
                              padding: verticalSpace(x: 0),
                              child: Text(
                                // "${userName.toUpperCase()}\n${Helper.getCurrentTime()}",
                                "${Helper.getCurrentDate()}\n${Helper.getCurrentTime()}",
                                textAlign: TextAlign.center,
                                style: getTextStyle(
                                    color: WHITE_COLOR,
                                    fontSize: MEDIUM_PLUS_FONT_SIZE),
                              ),
                            ),
                          ),
                          hightSpacer10,
                          _leftMenuSectionItem("New Order", ORDER_TAB_ICON, () {
                            widget.selectedView.value = "New Order";
                            // debugPrint("order");
                          }),
                          hightSpacer10,
                          if (!isCashierLogin) ...[
                            _leftMenuSectionItem("Tables", ORDER_TAB_ICON, () {
                              widget.selectedView.value = "Tables";
                              // debugPrint("order");
                            }),
                            hightSpacer10,
                            _leftMenuSectionItem("Orders", HISTORY_TAB_ICON,
                                () {
                              widget.selectedView.value = "Orders";
                            }),
                            // hightSpacer10,

                            hightSpacer10,
                            _leftMenuSectionItem("Cashier", PRODUCE_TAB_ICON,
                                () {
                              widget.selectedView.value = "Cashier";
                            }),
                            hightSpacer10,

                            _leftMenuSectionItem("Sales", ORDER_TAB_ICON, () {
                              widget.selectedView.value = "Sales";
                              // debugPrint("order");
                            }),
                            hightSpacer10,
                            _leftMenuSectionItem("Stock", ORDER_TAB_ICON, () {
                              widget.selectedView.value = "Stock";
                              // debugPrint("order");
                            }),
                            hightSpacer10,
                            _leftMenuSectionItem(
                                "Printer Setting", PRODUCE_TAB_ICON, () {
                              widget.selectedView.value = "Printer Settings";
                            }),
                            hightSpacer10,
                            _leftMenuSectionItem("Setting", SETTING_TAB_ICON,
                                () {
                              widget.selectedView.value = "Setting";
                            }),

                            hightSpacer10,
                            Container(
                              child: Padding(
                                padding: verticalSpace(x: 0),
                                child: Text(
                                  'V $version',
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                      color: WHITE_COLOR,
                                      fontSize: LARGE_MINUS_FONT_SIZE),
                                ),
                              ),
                            ),
                          ],
                        ])))),
              ],
            ),
    );
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  _leftMenuSectionItem(String title, String iconData, Function() action) {
    return InkWell(
      onTap: () => action(),
      child: Obx(() => Container(
            width: Helper.checkOrientation(context)
                ? defaultTargetPlatform == TargetPlatform.iOS
                    ? 80
                    : 100
                : MediaQuery.of(context).size.width,
            height: Helper.checkOrientation(context)
                ? defaultTargetPlatform == TargetPlatform.iOS
                    ? 80
                    : 100
                : defaultTargetPlatform == TargetPlatform.iOS
                    ? MediaQuery.of(context).size.height * 0.078
                    : MediaQuery.of(context).size.height * 0.095,
            margin: Helper.checkOrientation(context)
                ? EdgeInsets.fromLTRB(
                    4,
                    defaultTargetPlatform == TargetPlatform.iOS ? 5 : 10,
                    4,
                    defaultTargetPlatform == TargetPlatform.iOS ? 5 : 10)
                : EdgeInsets.fromLTRB(4, 1, 4,
                    defaultTargetPlatform == TargetPlatform.iOS ? 5 : 5),
            // height: 75,
            decoration: BoxDecoration(
              color: title.toLowerCase() == widget.selectedView.toLowerCase()
                  ? LIGHT_ORANGE_COLOR
                  : WHITE_COLOR,
              borderRadius: BorderRadius.circular(12),
              // boxShadow: const [BoxShadow(blurRadius: 0.05)],
              border: Border.all(width: 1, color: GREY_COLOR),
            ),
            child: Helper.checkOrientation(context)
                ? Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 10,
                            top: defaultTargetPlatform == TargetPlatform.iOS
                                ? 10
                                : 10),
                        child: Center(
                          child: SvgPicture.asset(
                            iconData,
                            color: title.toLowerCase() ==
                                    widget.selectedView.toLowerCase()
                                ? DARK_GREY_COLOR
                                : DARK_GREY_COLOR,
                            width: getResponsiveIconSize2(context),
                            height: MediaQuery.of(context).size.height <= 800
                                ? 22.0
                                : 40.0,
                            // width: defaultTargetPlatform == TargetPlatform.iOS
                            //     ? 20
                            //     : getResponsiveIconSize(context),
                            // height: defaultTargetPlatform == TargetPlatform.iOS
                            //     ? 20
                            //     : 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50, top: 10),
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: getTextStyle(
                              fontSize: defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? MEDIUM_PLUS_FONT_SIZE
                                  : MediaQuery.of(context).size.width * 0.01,
                              fontWeight: FontWeight.w500,
                              color: title.toLowerCase() ==
                                      widget.selectedView.toLowerCase()
                                  ? BLACK_COLOR
                                  : BLACK_COLOR,
                            ),
                          ),
                        ),
                      ),
                      Text(""),
                      hightSpacer40,
                    ],
                  )
                : Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: defaultTargetPlatform == TargetPlatform.iOS
                                ? 5
                                : 10),
                        child: Center(
                          child: SvgPicture.asset(
                            iconData,
                            color: title.toLowerCase() ==
                                    widget.selectedView.toLowerCase()
                                ? DARK_GREY_COLOR
                                : DARK_GREY_COLOR,
                            // width: defaultTargetPlatform == TargetPlatform.iOS
                            //     ? 12
                            //     : width,
                            // height: defaultTargetPlatform == TargetPlatform.iOS
                            //     ? 12
                            //     : 18,
                            width: getResponsiveIconSize2(context),
                            height: MediaQuery.of(context).size.height <= 800
                                ? 20.0
                                : 38.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 8),
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: getTextStyle(
                              fontSize:
                                  defaultTargetPlatform == TargetPlatform.iOS
                                      ? SMALL_PLUS_FONT_SIZE
                                      : LARGE_MINUS20_FONT_SIZE,
                              fontWeight: FontWeight.w700,
                              color: title.toLowerCase() ==
                                      widget.selectedView.toLowerCase()
                                  ? BLACK_COLOR
                                  : BLACK_COLOR,
                            ),
                          ),
                        ),
                      ),
                      Text(""),
                      hightSpacer40,
                    ],
                  ),
          )),
    );
  }
}
