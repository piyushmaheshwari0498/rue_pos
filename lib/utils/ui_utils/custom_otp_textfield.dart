import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/configs/theme_config.dart';

import '../../constants/app_constants.dart';
import '../../utils copy/ui_utils/text_styles/custom_text_style.dart';

class CustomOTPTextField extends StatelessWidget {
  final String value;

  const CustomOTPTextField(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery
        .of(context)
        .size
        .width > 600 ? 40 : 50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: Device.get().isTablet ? size : 30,
        width: Device.get().isTablet ? size : 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          color: Colors.transparent,
          boxShadow: value.isNotEmpty
              ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Center(
          child: value.isNotEmpty
              ? Container(
            width: Device.get().isTablet ? size * 0.8 : size * 0.4,
            height: Device.get().isTablet ? size * 0.8 : size * 0.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/*
class CustomOTPTextField extends StatelessWidget {
  final String value;
  const CustomOTPTextField(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Reduced padding for better centering
      child: AnimatedContainer(
        height: 50, // Increased height for better visibility
        width: 50,  // Increased width for better spacing
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 650),
        decoration: BoxDecoration(
          border: Border.all(
            color: value.isNotEmpty ? Colors.transparent : MAIN_COLOR,
            width: 2, // Slightly thicker border for clarity
          ),
          borderRadius: BorderRadius.circular(50), // Less rounded corners
          color: value.isEmpty ? Colors.white : const Color(0xfff3fdf8),
        ),
        child: Center(
          child: Text(
            value.isNotEmpty ? '\u{002A}' : value,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: HOME_PROFILE_PIC_RADIUS,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}*/
