import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../utils/ui_utils/textfield_border_decoration.dart';

// ignore: must_be_immutable
class SearchWidgetTablet extends StatefulWidget {
  final String? searchHint;
  final TextEditingController? searchTextController;
  Function(String changedtext)? onTextChanged;
  Function(String text)? onSubmit;
  TextInputType keyboardType;
  List<TextInputFormatter>? inputFormatter;
  FocusNode? focusNode;
  SearchWidgetTablet(
      {Key? key,
      this.searchHint,this.focusNode,
      this.searchTextController,
      this.onTextChanged,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.inputFormatter})
      : super(key: key);

  @override
  State<SearchWidgetTablet> createState() => _SearchWidgetTabletState();
}

class _SearchWidgetTabletState extends State<SearchWidgetTablet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: searchTxtFieldBorderDecoration,
      child: TextField(
        focusNode: widget.focusNode,
        style: getTextStyle(
            fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
        cursorColor: BLACK_COLOR,
        controller: widget.searchTextController,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: widget.searchHint ?? SEARCH_HINT_TXT,
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          isDense: true,
          enabledBorder: OutlineInputBorder(),
          hintTextDirection: TextDirection.ltr,
          // prefixIconColor: BLACK_COLOR,
          iconColor: BLACK_COLOR,
          prefix: Padding(padding: leftSpace(x: 10)),
          suffixIcon: SvgPicture.asset(
            SEARCH_IMAGE,
            width: 40,

            colorBlendMode: BlendMode.hue,
            color: TABLET_BG_COLOR,
          ),
          
          // suffixIcon: widget.searchTextController!.text.isNotEmpty
          //     ? IconButton(
          //         onPressed: () {
          //           setState(() {
          //             widget.searchTextController!.text = "";
          //           });
          //         },
          //         icon: Padding(
          //           padding: rightSpace(),
          //           child: const Icon(
          //             Icons.close,
          //             color: DARK_GREY_COLOR,
          //           ),
          //         ))
          //     : null,
          hintStyle: getHintStyle(),
          focusColor: LIGHT_GREY_COLOR,
          border: InputBorder.none,
        ),
        onSubmitted: (text) => widget.onSubmit!(text),
        onChanged: (updatedText) => widget.onTextChanged!(updatedText),
        inputFormatters: widget.inputFormatter,
      ),
    );
  }
}
