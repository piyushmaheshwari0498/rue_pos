import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';

class MultiTextFieldWidget extends StatelessWidget {
  const MultiTextFieldWidget(
      {Key? key,
      required TextEditingController txtCtrl,
      required String hintText,
      this.txtColor = DARK_GREY_COLOR,
      required this.boxDecoration,
      this.verticalContentPadding = 10,
      this.maxline = 5,
      this.prefixText = '',
      this.minline = 2,
      this.inputType = 1,
      this.password = false,
      this.isExpand = false
      })
      : _txtCtrl = txtCtrl,
        _hintText = hintText,
        super(key: key);

  final TextEditingController _txtCtrl;
  final String _hintText;
  final String prefixText;
  final int inputType;
  final bool password;
  final bool isExpand;
  final Color txtColor;
  final BoxDecoration boxDecoration;
  final double verticalContentPadding;
  final int maxline,minline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      child: TextFormField(
        style: getTextStyle(
            color: txtColor,
            fontSize: LARGE_MINUS_FONT_SIZE,
            fontWeight: FontWeight.w600),
        controller: _txtCtrl,
        cursorColor: DARK_GREY_COLOR,
        autocorrect: false,
        maxLines: maxline,
        minLines: minline,
        expands: isExpand,
        textInputAction: TextInputAction.next,
        // textAlignVertical: TextAlignVertical.bottom,
        obscureText: password,

        decoration: InputDecoration(
          hintText: _hintText,
          suffixText: prefixText+" ",
          hintStyle: getHintStyle(),
          focusColor: DARK_GREY_COLOR,
          contentPadding: paddingXY(x: 16, y: verticalContentPadding),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
