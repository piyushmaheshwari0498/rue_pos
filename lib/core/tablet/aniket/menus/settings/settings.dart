import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/configs/theme_config.dart';

import 'package:nb_posx/core/tablet/aniket/menus/settings/app_version.dart';
import 'package:nb_posx/core/tablet/aniket/menus/settings/general_settings.dart';
import 'package:nb_posx/core/tablet/aniket/menus/settings/printers_settings_landscape.dart';
import 'package:nb_posx/core/tablet/aniket/menus/settings/printers_settings_landscape_copy.dart';
import 'package:nb_posx/core/tablet/aniket/menus/settings/thermal_settings.dart';
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils copy/ui_utils/padding_margin.dart';
import '../../../../../utils/helper.dart';
import '../../../widget/logout_popup.dart';
import '../../../widget/title_search_bar.dart';
import '../printerMenu/printer_menu_landscape.dart';

// import 'package:sidebarx/sidebarx.dart';

class SettingsLandscape extends StatefulWidget {
  const SettingsLandscape({super.key});

  @override
  State<SettingsLandscape> createState() => _SettingsState();
// TODO: implement createState
}

class _SettingsState extends State<SettingsLandscape> {
  @override
  late int tappedIndex;
  bool isOn = false;
  late String version;
  String name = "";
  final List<String> _listName = [
    'General',
    'Terminal',
    'Printer',
    // 'Printer Settings',
    'App-Version',
    // 'Logout'
  ];

  final List<Icon> _listIcons = [
    Icon(
      Icons.settings,
      size: 30.0,
    ),
    Icon(
      Icons.desktop_mac_sharp,
      size: 30.0,
    ),
    Icon(
      Icons.print_rounded,
      size: 30.0,
    ),
    Icon(
      Icons.info,
      size: 30.0,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppVersion();
    tappedIndex = 0;
    _getHubManager();
  }

  Future<void> _getHubManager() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;

    Helper.hubManager = manager;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DBPreferences dbPreferences = DBPreferences();
    // name = await DBPreferences().getPreference(HubUsername);

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    // // userTypeId = prefs.getInt(UserTypeId)!;
    setState(() {
      name = manager.name;
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        // backgroundColor: const Color.fromRGBO(139, 143, 124, 40.0),
        title: ListTile(
          leading: SizedBox(
            // width: defaultTargetPlatform == TargetPlatform.iOS ? 895 : 1050,
            width: Device.get().isTablet
                ? MediaQuery.of(context).size.width * 0.8
                : MediaQuery.of(context).size.width - 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: Device.get().isTablet ? 9 : 4,
                        child: Text(
                          "My Profile",
                          style: getTextStyle(
                              color: BLACK_COLOR,
                              fontSize: LARGE_MINUS20_FONT_SIZE),
                        )),
                    Spacer(),
                    Expanded(
                        flex: Device.get().isTablet
                            ? defaultTargetPlatform == TargetPlatform.iOS
                                ? 2
                                : MediaQuery.of(context).size.height <= 800
                                    ? 2
                                    : 1
                            : 3,
                        child:
                            // ElevatedButton.icon(onPressed: (){
                            //   setState(() async {
                            //     debugPrint("Logout clicked need to show popup");
                            //     await Get.defaultDialog(
                            //       // contentPadding: paddingXY(x: 0, y: 0),
                            //       title: "",
                            //       titlePadding: paddingXY(x: 0, y: 0),
                            //       // custom: Container(),
                            //       content: const LogoutPopupView(),
                            //     );
                            //   });
                            // }
                            // , icon: const Icon(
                            //   Icons.logout,
                            //   color: Colors.black,
                            // ), label: Text(
                            //   "Logout",
                            //   style: getTextStyle(
                            //       color: BLACK_COLOR,
                            //       fontSize: LARGE_MINUS_FONT_SIZE),
                            // )),

                            InkWell(
                                onTap: () {
                                  setState(() async {
                                    debugPrint(
                                        "Logout clicked need to show popup");
                                    await Get.defaultDialog(
                                      // contentPadding: paddingXY(x: 0, y: 0),
                                      title: "",
                                      titlePadding: paddingXY(x: 0, y: 0),
                                      // custom: Container(),
                                      content: const LogoutPopupView(),
                                    );
                                  });
                                },
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.logout,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                              "Logout",
                                              style: getTextStyle(
                                                  color: BLACK_COLOR,
                                                  fontSize:
                                                      LARGE_MINUS20_FONT_SIZE),
                                            )),
                                      ],
                                    ))))
                  ],
                ),
                // hightSpacer5,
                Row(
                  children: [
                     Icon(
                      Icons.person_pin,
                      color: Colors.black,
                      size: Device.get().isTablet ? 25 : 20,
                    ),
                    Text(
                      name ?? "",
                      style: getTextStyle(
                          color: BLACK_COLOR, fontSize: Device.get().isTablet ? LARGE_MINUS_FONT_SIZE : MediaQuery.of(context).size.width * 0.02),
                    ),
                  ],
                ),
                // hightSpacer10,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: Device.get().isTablet ? 6 / 14 : 2 / 18,
              child: Container(
                padding: const EdgeInsets.only(left: 10, top: 0, bottom: 10),
                child: Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Card(
                          color: tappedIndex == index
                              ? TABLET_BG_COLOR.withOpacity(0.9)
                              : Colors.white,
                          child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              // Adjust padding
                              visualDensity: const VisualDensity(vertical: 4),
                              leading: _listIcons[index],
                              title: Text(
                                _listName[index],
                                maxLines: 1,
                                style: getTextStyle(
                                    color: tappedIndex == index
                                        ? BLACK_COLOR
                                        : BLACK_COLOR,
                                    fontSize: Device.get().isTablet
                                        ? LARGE_MINUS20_FONT_SIZE
                                        : MEDIUM_FONT_SIZE,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Device.get().isTablet
                                  ? Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: tappedIndex == index
                                          ? BLACK_COLOR
                                          : BLACK_COLOR,
                                    )
                                  : Spacer(),
                              onTap: () {
                                setState(() {
                                  tappedIndex = index;
                                });
                              }),
                        );
                      })
                ]),
              ),
            ),
            Expanded(
                child: Padding(
              padding: Device.get().isTablet
                  ? EdgeInsets.fromLTRB(10,0,0,0)
                  : EdgeInsets.fromLTRB(10,0,0,0),
              child: () {
                if (tappedIndex == 0) {
                  return const GeneralSettingsLandscape();
                } else if (tappedIndex == 1) {
                  return const ThermalSettingsLandscape();
                } else if (tappedIndex == 2) {
                  return PrinterSettingsLandscape();
                }
                // else if (tappedIndex == 3) {
                //   return PrinterMenuLandscape();
                // }
                else if (tappedIndex == 3) {
                  return AppVersionLandscape(
                    version: version,
                  );
                }
                // else if (tappedIndex == 4) {
                //   return logoutMethod();
                // }
              }(),
            )),
          ],
        ),
      ),
    );
  }

  Widget logoutMethod() {
    return Center(
      child: Container(
        width: 500,
        height: 300,
        child: FittedBox(
          fit: BoxFit.contain,
          child: LogoutPopupView(),
        ),
      ),
    );
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    print("APp Version: ${version}");
  }
}
