import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/api_category.dart' as dbcat;

import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../database/db_utils/db_constants.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/order_item.dart';
import '../../../database/models/split_bill_model.dart';
import '../../../network/api_helper/api_status.dart';
import '../../../utils copy/ui_utils/textfield_border_decoration.dart';
import '../../../utils/ui_utils/keypad_button.dart';
import '../../../widgets/multitext_field_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../create_order/payment_number_screen.dart';
import '../login/transaction_pin_screen.dart';
import 'hotel_tab_screen.dart';

// ignore: must_be_immutable
class DiscountPopup extends StatefulWidget {
  // Customer? customer;
  // double amount;
  // List<OrderItem> orderItem;

  DiscountPopup({Key? key}) : super(key: key);

  @override
  State<DiscountPopup> createState() => _DiscountPopupState();
}

class _DiscountPopupState extends State<DiscountPopup> {
  double itemTotal = 0;
  late List<SplitBill> splitBillList = [];
  late List<String> paymentList = [];
  late TextEditingController orderDiscountCtrl;

  List<TextEditingController> amountRefCtrl = [];
  List<TextEditingController> splittransRefCtrl = [];

  late List<dbcat.APICategory> tabMenu = [];
  late List<dbcat.APICategory> amountMenu = [];
  late List<dbcat.APICategory> perMenu = [];
  int currenttabSelectedIndex = 0;
  int currentAmounttabSelectedIndex = 0;
  int currentPertabSelectedIndex = 0;

  // late List<Attribute> attributeList = [];

  // late List<Option> optionList = [];
  int qty = 0;
  int splitBillCount = 2;
  double totalAmount = 0.0;
  double balanceAmount = 0.0;
  late String receivedAmount;
  late GlobalKey<CashKeyboardScreenState> cashKey;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;
  double splitPaid = 0;
  double splitBal = 0;
  double splitTender = 0;

  late int selectedCashMode = 0;
  late int selectedAmountMode = 0;
  late String selectedCashText;
  late bool selectedPaymentMode;

  @override
  void initState() {
    super.initState();
    cashKey = GlobalKey();
    amountRefCtrl = [];
    splittransRefCtrl = [];
    orderDiscountCtrl = TextEditingController();
    selectedPaymentMode = false;
    // splitBillList = getList();
    selectedCashMode = -1;
    selectedCashText = "";
    receivedAmount = "";
    // splitTotalList();
    // log(splitBillList.toString());
    getTabs();
    getPerTabs();
    getAmountTabs();
  }

  Future<void> getTabs() async {
    selectedCashMode = 0;
    tabMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "Percentage",
        ar_name: "Percentage",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "Amount",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));

    tabMenu[selectedCashMode].isChecked = true;
  }

  Future<void> getPerTabs() async {
    currentPertabSelectedIndex = 0;
    perMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "5%",
        ar_name: "Percentage",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    perMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "10%",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    perMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "15%",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));

    perMenu[currentPertabSelectedIndex].isChecked = true;
  }

  Future<void> getAmountTabs() async {
    selectedAmountMode = 0;
    amountMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "1",
        ar_name: "Percentage",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    amountMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "2",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    amountMenu.add(dbcat.APICategory(
        id: 0,
        en_name: "3",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));

    amountMenu[selectedAmountMode].isChecked = true;
  }

  void splitTotalList() {
    // double val1 = widget.amount / splitBillCount;
    splitPaid = 0;
    for (SplitBill bill in splitBillList) {
      // bill.amount = val1;
      // splitBillList.contains(bill);
      splitPaid += bill.amount;
      if (splitPaid >= totalAmount) {
        splitBal = 0.000;
      } else {
        splitBal = splitPaid - totalAmount;
      }
      if (splitPaid > totalAmount) {
        splitTender = totalAmount - splitPaid;
      } else if (splitPaid < totalAmount) {
        splitTender = 0.000;
      } else {
        splitTender = 0.000;
      }
    }

    // for(SplitBill item in splitBillList)
    //   amountRefCtrl.text = "${item.amount.toStringAsPrecision(3)}";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // _configureTaxAndTotal(widget.orderItem);

    /*return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          Center(
            child: Container(
                width: defaultTargetPlatform ==
                    TargetPlatform.iOS
                    ? 630 : MediaQuery.of(context).size.width / 3 ,
                padding: paddingXY(x: 10, y: 10),
                decoration: BoxDecoration(
                  color: TABLET_BG_COLOR,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 0.05)],
                  border: Border.all(width: 1, color: GREY_COLOR),
                ),
                height: 500,
                child: Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Discount",
                              style: getTextStyle(
                                  fontSize: LARGE_PLUS_FONT_SIZE,
                                  color: WHITE_COLOR),
                            )),
                        Spacer(),
                        Row(children: [
                          Visibility(
                              visible: true,
                              child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                      padding: miniPaddingAll(),
                                      child: SvgPicture.asset(CROSS_ICON,
                                          height: 20,
                                          color: Colors.white,
                                          fit: BoxFit.contain)))),
                        ]),
                        hightSpacer20,
                      ],
                    ),
                    hightSpacer5,
                    Container(
                      padding: paddingXY(x: 0, y: 0),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 430,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        hightSpacer20,
                                    _paymentModeSection(),

                                    hightSpacer20,

                                    Container(
                                        width: 400,
                                        // height: 100,
                                        padding: horizontalSpace(),
                                        child: MultiTextFieldWidget(
                                          boxDecoration:
                                              txtFieldBorderDecoration,
                                          txtCtrl: orderDiscountCtrl,
                                          prefixText: selectedCashMode == 0 ? "%" : appCurrency2,
                                          hintText: "Discount",
                                          inputType: 2,
                                          txtColor: DARK_GREY_COLOR,
                                        )),
                                    hightSpacer20,

                                    selectedCashMode == 0
                                        ? _percentageModeSection()
                                        : _amountModeSection(),

                                    hightSpacer20,
                                    selectedCashMode != -1
                                        ? InkWell(
                                            onTap: () {
                                              // _newCustomerAPI();
                                              // customer = Customer(
                                              //     id: emailCtrl.text,
                                              //     name: nameCtrl.text ?? "Guest",
                                              //     email: emailCtrl.text,
                                              //     phone: phoneCtrl.text,
                                              //     isSynced: false,
                                              //     modifiedDateTime: DateTime.now()
                                              //   // ward: Ward(id: "01", name: "name"),
                                              //   // profileImage: Uint8List.fromList([]),
                                              // );
                                              // if (customer != null) {
                                              Get.back(
                                                  result:
                                                  selectedCashMode == 0 ? orderDiscountCtrl.text+"%" :  orderDiscountCtrl.text);
                                              // }
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Apply Discount",
                                                  textAlign: TextAlign.center,
                                                  style: getTextStyle(
                                                      fontSize: LARGE_FONT_SIZE,
                                                      color: WHITE_COLOR,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),

                                    // SizedBox(height: 100,)
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
          ),
        ]),
      ),
    );*/
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: Device.get().isTablet
                    ? defaultTargetPlatform == TargetPlatform.iOS
                        ? 630
                        : MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 1.02,
                padding: paddingXY(x: 10, y: 10),
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(blurRadius: 0.05)],
                  border: Border.all(width: 1, color: GREY_COLOR),
                ),
                height: 500,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Discount",
                            style: getTextStyle(
                              fontSize: LARGE_PLUS_FONT_SIZE,
                              color: WHITE_COLOR,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Visibility(
                              visible: true,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: miniPaddingAll(),
                                  child: SvgPicture.asset(
                                    CROSS_ICON,
                                    height: 20,
                                    color: Colors.white,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        hightSpacer20,
                      ],
                    ),
                    hightSpacer5,
                    Expanded(
                      child: Center(
                        // Centering the child content
                        child: Container(
                          padding: paddingXY(x: 0, y: 0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          width: Device.get().isTablet
                              ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 0.50,
                          // Set a fixed width to keep it centered
                          height: 430,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Centers vertically
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Centers horizontally
                            children: [
                              _paymentModeSection(),
                              hightSpacer20,
                              Container(
                                width: 400,
                                padding: horizontalSpace(),
                                child: MultiTextFieldWidget(
                                  boxDecoration: txtFieldBorderDecoration,
                                  txtCtrl: orderDiscountCtrl,
                                  prefixText: selectedCashMode == 0
                                      ? "%"
                                      : appCurrency2,
                                  hintText: "Discount",
                                  inputType: 2,
                                  txtColor: DARK_GREY_COLOR,
                                ),
                              ),
                              hightSpacer20,
                              selectedCashMode == 0
                                  ? _percentageModeSection()
                                  : _amountModeSection(),
                              hightSpacer20,
                              selectedCashMode != -1
                                  ? InkWell(
                                      onTap: () {
                                        Get.back(
                                          result: selectedCashMode == 0
                                              ? orderDiscountCtrl.text + "%"
                                              : orderDiscountCtrl.text,
                                        );
                                      },
                                      child: Container(
                                        width: Device.get().isTablet
                                            ? 380 : 200,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: MAIN_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Apply Discount",
                                            textAlign: TextAlign.center,
                                            style: getTextStyle(
                                              fontSize: LARGE_FONT_SIZE,
                                              color: WHITE_COLOR,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentModeSection() {
    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paymentOption(PAYMENT_CASH_ICON, "Percentage", 0),
          _paymentOption(PAYMENT_CARD_ICON, "Amount", 1),
        ],
      ),
    );
  }

  Widget _percentageModeSection() {
    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _perOption(PAYMENT_CASH_ICON, "5%", 0),
          SizedBox(
            width: Device.get().isTablet
                ? 30 : 15,
          ),
          _perOption(PAYMENT_CARD_ICON, "10%", 1),
          SizedBox(
            width: Device.get().isTablet
                ? 30 : 15,
          ),
          _perOption(PAYMENT_CARD_ICON, "15%", 2),
        ],
      ),
    );
  }

  Widget _amountModeSection() {
    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _amountOption(PAYMENT_CASH_ICON, "1", 0),
          SizedBox(
            width: Device.get().isTablet
                ? 30 : 15,
          ),
          _amountOption(PAYMENT_CARD_ICON, "2", 1),
          SizedBox(
            width: Device.get().isTablet
                ? 30 : 15,
          ),
          _amountOption(PAYMENT_CARD_ICON, "3", 2),
        ],
      ),
    );
  }

  _paymentOption(String paymentIcon, String title, int isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCashMode = isSelected;
          selectedCashText = title;

          tabMenu[currenttabSelectedIndex].isChecked = false;
          if (isSelected == 0) {
            currenttabSelectedIndex = 0;
          } else {
            currenttabSelectedIndex = 1;
          }

          amountMenu[currentAmounttabSelectedIndex].isChecked = false;
          perMenu[currentPertabSelectedIndex].isChecked = false;
          selectedAmountMode = 0;
          currentAmounttabSelectedIndex = 0;
          currentPertabSelectedIndex = 0;
          orderDiscountCtrl.text = "";

          tabMenu[isSelected].isChecked = true;
        });
      },
      child: Container(
        decoration: tabMenu[isSelected].isChecked
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                color: WHITE_COLOR,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(2)))
            : const BoxDecoration(
                shape: BoxShape.rectangle,
                color: TABLET_BG_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: paddingXY(x: 20, y: 20),
        child: Row(
          children: [
            // SvgPicture.asset(paymentIcon, height: 35),
            // widthSpacer(10),
            Text(
              title,
              style: getTextStyle(
                  fontSize: MEDIUM_FONT_SIZE,
                  color: tabMenu[isSelected].isChecked
                      ? BLACK_COLOR
                      : DARK_GREY_COLOR),
            )
          ],
        ),
      ),
    );
  }

  _perOption(String paymentIcon, String title, int isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedAmountMode = isSelected;
          // selectedCashText = title;

          perMenu[currentPertabSelectedIndex].isChecked = false;
          if (isSelected == 0) {
            currentPertabSelectedIndex = 0;
          } else if (isSelected == 1) {
            currentPertabSelectedIndex = 1;
          } else if (isSelected == 2) {
            currentPertabSelectedIndex = 2;
          }

          perMenu[isSelected].isChecked = true;

          orderDiscountCtrl.text =
              perMenu[isSelected].en_name.replaceAll(RegExp('%'), '');
        });
      },
      child: Container(
        width: Device.get().isTablet
            ? 100 : 80,
        decoration: perMenu[isSelected].isChecked
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                color: WHITE_COLOR,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(2)))
            : const BoxDecoration(
                shape: BoxShape.rectangle,
                color: TABLET_BG_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: Device.get().isTablet
            ? paddingXY(x: 30, y: 20) : paddingXY(x: 22, y: 12),
        child: Row(
          children: [
            // SvgPicture.asset(paymentIcon, height: 35),
            // widthSpacer(10),
            Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: getTextStyle(
                      fontSize: LARGE_MINUS_FONT_SIZE,
                      color: perMenu[isSelected].isChecked
                          ? BLACK_COLOR
                          : DARK_GREY_COLOR),
                )),
          ],
        ),
      ),
    );
  }

  _amountOption(String paymentIcon, String title, int isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedAmountMode = isSelected;
          // selectedCashText = title;

          amountMenu[currentAmounttabSelectedIndex].isChecked = false;
          if (isSelected == 0) {
            currentAmounttabSelectedIndex = 0;
          } else if (isSelected == 1) {
            currentAmounttabSelectedIndex = 1;
          } else if (isSelected == 2) {
            currentAmounttabSelectedIndex = 2;
          }

          amountMenu[isSelected].isChecked = true;

          orderDiscountCtrl.text = amountMenu[isSelected].en_name;
        });
      },
      child: Container(
        width: Device.get().isTablet
            ? 100 : 80,
        decoration: amountMenu[isSelected].isChecked
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                color: WHITE_COLOR,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(2)))
            : const BoxDecoration(
                shape: BoxShape.rectangle,
                color: TABLET_BG_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: Device.get().isTablet
            ? paddingXY(x: 43, y: 20) : paddingXY(x: 33, y: 12),
        child: Row(
          children: [
            // SvgPicture.asset(paymentIcon, height: 35),
            // widthSpacer(10),
            Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: getTextStyle(
                      fontSize: LARGE_MINUS_FONT_SIZE,
                      color: amountMenu[isSelected].isChecked
                          ? BLACK_COLOR
                          : DARK_GREY_COLOR),
                )),
          ],
        ),
      ),
    );
  }
}
