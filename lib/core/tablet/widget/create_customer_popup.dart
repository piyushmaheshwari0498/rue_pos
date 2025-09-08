import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/utils/helper.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../database/db_utils/db_customer.dart';
import '../../service/select_customer/api/create_customer.dart';

// ignore: must_be_immutable
class CreateCustomerPopup extends StatefulWidget {
  String phoneNo;
  CreateCustomerPopup({Key? key, required this.phoneNo}) : super(key: key);

  @override
  State<CreateCustomerPopup> createState() => _CreateCustomerPopupState();
}

class _CreateCustomerPopupState extends State<CreateCustomerPopup> {
  late TextEditingController phoneCtrl, emailCtrl, nameCtrl;
  Customer? customer;
  bool customerFound = false;

  @override
  void initState() {
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    emailCtrl = TextEditingController();

    phoneCtrl.text = widget.phoneNo;

    super.initState();
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              CROSS_ICON,
              color: BLACK_COLOR,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          children: [
            Text(
              "Add Customer",
              style: getTextStyle(
                  fontSize: LARGE_PLUS_FONT_SIZE,
                  fontWeight: FontWeight.bold,
                  color: BLACK_COLOR),
            ),
            hightSpacer30,
            Container(
                width: 400,
                // height: 100,
                padding: horizontalSpace(),
                child: widget.phoneNo.isEmpty ? TextFieldWidget(
                  boxDecoration: txtFieldBorderDecoration,
                  txtCtrl: phoneCtrl,
                  hintText: "Enter phone no.",
                  txtColor: DARK_GREY_COLOR,
                )
                    : IgnorePointer(
                    child: TextFieldWidget(
                  boxDecoration: txtFieldBorderDecoration,
                  txtCtrl: phoneCtrl,
                  hintText: "Enter phone no.",
                  txtColor: DARK_GREY_COLOR,
                ))),
            hightSpacer20,
            Container(
                width: 400,
                // height: 100,
                padding: horizontalSpace(),
                child: TextFieldWidget(
                  boxDecoration: txtFieldBorderDecoration,
                  txtCtrl: nameCtrl,
                  hintText: "Enter name",
                  txtColor: DARK_GREY_COLOR,
                )),
            hightSpacer20,
            Container(
                width: 400,
                // height: 100,
                padding: horizontalSpace(),
                child: TextFieldWidget(
                  boxDecoration: txtFieldBorderDecoration,
                  txtCtrl: emailCtrl,
                  hintText: "Enter email (optional)",
                  txtColor: DARK_GREY_COLOR,
                )),
            hightSpacer40,
            InkWell(
              onTap: () {
                _newCustomerAPI();
                customer = Customer(
                    id: emailCtrl.text,
                    name: nameCtrl.text ?? "Guest",
                    email: emailCtrl.text,
                    phone: phoneCtrl.text,
                    isSynced: false,
                    modifiedDateTime: DateTime.now()
                    // ward: Ward(id: "01", name: "name"),
                    // profileImage: Uint8List.fromList([]),
                    );
                if (customer != null) {
                  Get.back(result: customer);
                }
              },
              child: Container(
                width: 380,
                height: 50,
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  // phoneCtrl.text.length == 10 && nameCtrl.text.isNotEmpty
                  //     ? MAIN_COLOR
                  //     : MAIN_COLOR.withOpacity(0.3),
                  // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Add & Create Order",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        fontSize: LARGE_FONT_SIZE,
                        color: WHITE_COLOR,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ]));
  }

  Future<void> _newCustomerAPI() async {
    // CommanResponse response = await CreateCustomer()
    //     .createNew(phoneCtrl.text, nameCtrl.text, emailCtrl.text);
    // if (response.status!) {
    // } else {
      Customer tempCustomer = Customer(
          // profileImage: image,
          // ward: Ward(id: "1", name: "1"),
          email: emailCtrl.text.trim(),
          id: phoneCtrl.text.trim(),
          name: nameCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          isSynced: false,
          modifiedDateTime: DateTime.now());
      List<Customer> customers = [];
      customers.add(tempCustomer);
      await DbCustomer().addCustomers(customers);
    // }
  }
}
