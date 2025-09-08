import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/core/mobile/login/ui/login.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../main.dart';
import '../../home/ui/home_dashboard.dart';
import '../../home/ui/product_list_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => isUserLoggedIn ? HomeDashboard() : const Login(),
        ),
            (route) => false, // Clears all previous routes
      ),
    );

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []); // 🔥 Hide status bar
    }

    @override
    void dispose() {
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge); // ✅ Restore on exit
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MAIN_COLOR,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Stack(
            children: [
              Center(
                  child: Image.asset(
                APP_ICON_TABLET,
                width: 300,
                height: 200,
                color: WHITE_COLOR,
                fit: BoxFit.fill,
              )),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        POWERED_BY_TXT,
                        style: getTextStyle(
                            color: MENU_TABLET_BG_COLOR, fontSize: 18.0),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
