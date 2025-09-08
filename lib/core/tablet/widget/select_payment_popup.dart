import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_cart/api/api_cart_service.dart';
import 'package:nb_posx/core/service/api_cart/model/cart_response.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
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
import '../../../database/db_utils/db_hub_manager.dart';
import '../../../database/db_utils/db_preferences.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/hub_manager.dart';
import '../../../database/models/order_item.dart';
import '../../../database/models/split_bill_model.dart';
import '../../../network/api_helper/api_status.dart';
import '../../../utils copy/helper.dart';
import '../../../utils copy/helpers/sync_helper.dart';
import '../../../utils/helper.dart' as help;
import '../../../utils copy/ui_utils/textfield_border_decoration.dart';
import '../../../utils/ui_utils/keypad_button.dart';
import '../../../widgets/multitext_field_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../../service/api_cart/model/cart_data.dart';
import '../../service/api_deliveryservice/api/api_delivery_service.dart';
import '../../service/api_deliveryservice/model/delivery_service.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../create_order/payment_number_screen.dart';
import '../login/login_landscape2.dart';
import '../login/transaction_pin_screen.dart';
import 'delivery_grid.dart';
import 'hotel_tab_screen.dart';

// ignore: must_be_immutable
class SelectPaymentPopup extends StatefulWidget {
  // Customer? customer;
  double amount;
  double discount;
  double discountPer;
  double deliveryAmount;
  int customerId;
  int selectedDineMode;
  List<OrderItem> orderItem;

  SelectPaymentPopup(
      {Key? key,
      required this.amount,
      required this.deliveryAmount,
      required this.discount,
      required this.discountPer,
      required this.customerId,
      required this.selectedDineMode,
      required this.orderItem})
      : super(key: key);

  @override
  State<SelectPaymentPopup> createState() => _SelectPaymentPopupState();
}

class _SelectPaymentPopupState extends State<SelectPaymentPopup> {
  double itemTotal = 0;
  late List<SplitBill> splitBillList = [];
  late List<String> paymentList = [];
  late TextEditingController orderNoteCtrl, cardNumberCtrl, transRefCtrl;

  List<TextEditingController> amountRefCtrl = [];
  List<TextEditingController> splittransRefCtrl = [];

  // late List<Attribute> attributeList = [];

  // late List<Option> optionList = [];
  int qty = 0;
  int splitBillCount = 2;
  int selectedDineMode = 0;
  double totalAmount = 0.0;
  double balanceAmount = 0.0;
  double deliveryAmount = 0.0;
  late String receivedAmount;
  late GlobalKey<CashKeyboardScreenState> cashKey;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double discountValue = 0.0;
  double taxPercentage = 0;
  double splitPaid = 0;
  double splitBal = 0;
  double splitTender = 0;
  bool isTax = false;

  late int selectedCashMode = -1;
  late int _deliveryId = 0;
  late String selectedCashText;
  late bool selectedPaymentMode;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedEmployeeName = "";

  late List<dbcat.APICategory> tabMenu = [];
  int currenttabSelectedIndex = 0;

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String? branch_crno;

  late Future<DeliveryResponse> futureDelivery;

  @override
  void initState() {
    super.initState();
    cashKey = GlobalKey();
    amountRefCtrl = [];
    splittransRefCtrl = [];
    orderNoteCtrl = TextEditingController();
    cardNumberCtrl = TextEditingController();
    transRefCtrl = TextEditingController();
    selectedPaymentMode = false;
    splitBillList = getList();
    selectedCashMode = -1;
    selectedCashText = "Cash";
    receivedAmount = "";
    // splitTotalList();
    // log(splitBillList.toString());

    discountValue = widget.discount;
    deliveryAmount = widget.deliveryAmount;
    selectedDineMode = widget.selectedDineMode;
    getPaymentList();
    _getDetails();
    getTabs();

    if (selectedDineMode == 0) {
      futureDelivery = DeliveryApiService.getDeliveryServices();
    }
  }

  Future<void> getTabs() async {
    // selectedCashMode = -1;
    tabMenu.add(new dbcat.APICategory(
        id: 0,
        en_name: "Cash",
        ar_name: "Percentage",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new dbcat.APICategory(
        id: 0,
        en_name: "Card",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new dbcat.APICategory(
        id: 0,
        en_name: "Benefit Pay",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new dbcat.APICategory(
        id: 0,
        en_name: "Split Pay",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));

    // tabMenu[selectedCashMode].isChecked = true;
    // ✅ Only check if selectedCashMode is valid
    if (selectedCashMode >= 0 && selectedCashMode < tabMenu.length) {
      tabMenu[selectedCashMode].isChecked = true;
    }
  }

  @override
  void dispose() {
    orderNoteCtrl.dispose();
    transRefCtrl.dispose();
    cardNumberCtrl.dispose();
// getParkedOrders();
    super.dispose();
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    String ip = prefs.getString('printer_ip') ?? "";
    String printerType = prefs.getString('printer_type') ?? "No Printer";
    String branchName = prefs.getString(BranchName) ?? "";
    String add1 = prefs.getString(BranchAdd1) ?? "";
    String add2 = prefs.getString(BranchAdd2) ?? "";
    String add3 = prefs.getString(BranchAdd3) ?? "";
    String phone = prefs.getString(BranchPhone) ?? "";
    String vat = prefs.getString(BranchVAT) ?? "";
    String crno = prefs.getString(BranchCRNo) ?? "";

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedEmployeeName = manager.name;
      isTax = prefs.getBool(isTaxOn) ?? false;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';

      printerIP = ip;
      selectedPrinter = printerType;
      branch_name = branchName;
      branch_add1 = add1;
      branch_add2 = add2;
      branch_add3 = add3;
      branch_phone = phone;
      branch_vat = vat;
      branch_crno = crno;
    });
  }

  List<SplitBill> getList() {
    List<SplitBill> list = [];

    double val1 = widget.amount / splitBillCount;
    double val2 = widget.amount / splitBillCount;

    list.add(SplitBill(
        id: UniqueKey().toString(),
        payment_type: "Cash",
        amount: val1,
        transaction_no: ""));
    list.add(SplitBill(
        id: UniqueKey().toString(),
        payment_type: "Cash",
        amount: val2,
        transaction_no: ""));

    // for(SplitBill item in list)
    //  amountRefCtrl.text = "${item.amount.toStringAsPrecision(3)}";

    return list;
  }

  void addList() {
    double val1 = widget.amount / splitBillCount;

    for (SplitBill bill in splitBillList) {
      bill.amount = val1;
      splitBillList.contains(bill);
    }

    splitBillList.add(SplitBill(
        id: UniqueKey().toString(),
        payment_type: "Cash",
        amount: val1,
        transaction_no: ""));

    // for(SplitBill item in splitBillList)
    //   amountRefCtrl.text = "${item.amount.toStringAsPrecision(3)}";

    setState(() {});
  }

  void updateList() {
    double val1 = widget.amount / splitBillCount;

    for (SplitBill bill in splitBillList) {
      bill.amount = val1;
      splitBillList.contains(bill);
    }

    // for(SplitBill item in splitBillList)
    //   amountRefCtrl.text = "${item.amount.toStringAsPrecision(3)}";

    setState(() {});
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

  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    _configureTaxAndTotal(widget.orderItem);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final isTablet = Device.get().isTablet;

    return Material(
      type: MaterialType.transparency,
      child: isTablet
          ? Center(
              child: _buildTabletLayout(context),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        // child: IntrinsicHeight(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          padding: paddingXY(x: 10, y: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: GREY_COLOR),
                          ),
                          child: _buildPhoneLayout(context),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    splitTotalList();

    return Stack(
      children: [
        Center(
          child: Container(
            // width: MediaQuery.of(context).size.width,
            padding: paddingXY(x: 10, y: 10),
            decoration: BoxDecoration(
              color: MAIN_COLOR,
              border: Border.all(width: 1, color: Colors.transparent),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabletHeader(context),
                hightSpacer5,
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      // width: screenWidth, // 80% of screen width
                      height: screenHeight * 1.50, // 80% of screen height
                      color: Colors.white,
                      padding: paddingXY(x: 20, y: 20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Section - Order Items
                              SizedBox(
                                width: constraints.maxWidth * 0.40,
                                child: _cartItemListSection(),
                              ),
                              // Right Section - Payment Summary + Inputs

                              SizedBox(
                                width: constraints.maxWidth * 0.60,
                                child: _buildRightPaymentSection(),
                              ),
                              // Center(
                              //   child: Text("Right Side payment section"),
                              // ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Header Bar
  Widget _buildTabletHeader(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Text(
          "Payment",
          style: getTextStyle(
            fontSize: LARGE_PLUS_FONT_SIZE,
            color: WHITE_COLOR,
          ),
        ),
        Spacer(),
        InkWell(
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
      ],
    );
  }

  /// 🔹 Right Section (Amount + Modes + Confirm Button)
/*Widget _buildRightPaymentSection() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${totalAmount.toStringAsFixed(3)} $appCurrency2",
            style: getTextStyle(
              fontSize: screenWidth * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Total Amount",
            style: getTextStyle(
              fontSize: screenWidth * 0.01,
              fontWeight: FontWeight.w600,
            ),
          ),
          _paymentModeSection(),
          hightSpacer10,
          if (selectedCashText.isNotEmpty)
            Text(
              "$selectedCashText Payment",
              style: getTextStyle(
                fontSize: LARGE_MINUS_FONT_SIZE,
                fontWeight: FontWeight.bold,
              ),
            ),

          // ✅ Show Payment Input Widgets
          if (selectedCashMode == 0) _cashPayment(),
          if (selectedCashMode == 1) _cardNumberInput(),
          if (selectedCashMode == 2) _benefitPayInput(),
          if (selectedCashMode == 3) _splitPaymentSection(),

          hightSpacer10,
          _orderNoteField(),

          hightSpacer20,
          _confirmOrderButton(),
        ],
      ),
    );
  }*/
  /*Widget _buildRightPaymentSection() {
    // helper to parse receivedAmount safely
    double _receivedAsDouble() => double.tryParse(receivedAmount) ?? 0.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Total
          Text(
            "${totalAmount.toStringAsFixed(3)} $appCurrency2",
            style: getTextStyle(
              fontSize: screenWidth * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Total Amount",
            style: getTextStyle(
              fontSize: screenWidth * 0.01,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Payment mode buttons
          _paymentModeSection(),
          hightSpacer10,

          if (selectedCashText.isNotEmpty)
            Text(
              "$selectedCashText Payment",
              style: getTextStyle(
                fontSize: LARGE_MINUS_FONT_SIZE,
                fontWeight: FontWeight.bold,
              ),
            ),

          hightSpacer10,

          // --- Received / Due row per payment mode ---
          // Cash: Received (editable by keypad) and Balance Due
          if (selectedCashMode == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildAmountText(
                  _receivedAsDouble() > 0 ? _receivedAsDouble() : totalAmount,
                  "Received Amount",
                )),
                SizedBox(width: 20),
                Expanded(child: _buildAmountText(
                  balanceAmount,
                  "Balance Due",
                )),
              ],
            ),
            SizedBox(height: 8),
            // your keypad for entering receivedAmount
            _cashPayment(),
          ],

          // Card or Benefit Pay: treat as full payment (Received = total, Due = 0)
          if (selectedCashMode == 1 || selectedCashMode == 2) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildAmountText(
                  totalAmount,
                  "Received Amount",
                )),
                SizedBox(width: 20),
                Expanded(child: _buildAmountText(
                  0.0,
                  "Balance Due",
                )),
              ],
            ),
            SizedBox(height: 8),
            // show the relevant input field
            if (selectedCashMode == 1) _cardNumberInput(),
            if (selectedCashMode == 2) _benefitPayInput(),
          ],

          // Split Pay: show splitPaid, splitBal and tender (splitTender)
          if (selectedCashMode == 3) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: _buildAmountText(splitPaid, "Received Amount")),
                SizedBox(width: 10),
                Expanded(child: _buildAmountText(splitBal, "Balance Due")),
                SizedBox(width: 10),
                Expanded(child: _buildAmountText(splitTender, "Tender")),
              ],
            ),
            SizedBox(height: 8),
            // show split list and controls
            _SplitItemListSection(),
          ],

          hightSpacer10,
          _orderNoteField(),
          hightSpacer20,
          _confirmOrderButton(),
        ],
      ),
    );
  }*/

  Widget _buildRightPaymentSection() {
    double _receivedAsDouble() => double.tryParse(receivedAmount) ?? 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${totalAmount.toStringAsFixed(3)} $appCurrency2",
          style: getTextStyle(
            fontSize: screenWidth * 0.02,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Total Amount",
          style: getTextStyle(
            fontSize: screenWidth * 0.01,
            fontWeight: FontWeight.w600,
          ),
        ),
        _paymentModeSection(),
        hightSpacer10,
        if (selectedCashMode != -1)
          if (selectedCashText.isNotEmpty)
            Text(
              "$selectedCashText Payment",
              style: getTextStyle(
                fontSize: LARGE_MINUS_FONT_SIZE,
                fontWeight: FontWeight.bold,
              ),
            ),
        hightSpacer10,
        if (selectedCashMode == 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildAmountText(
                  _receivedAsDouble() > 0 ? _receivedAsDouble() : totalAmount,
                  "Received Amount",
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildAmountText(
                  balanceAmount,
                  "Balance Due",
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _cashPayment(),
        ],
        if (selectedCashMode == 1 || selectedCashMode == 2) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildAmountText(totalAmount, "Received Amount")),
              SizedBox(width: 20),
              Expanded(child: _buildAmountText(0.0, "Balance Due")),
            ],
          ),
          SizedBox(height: 8),
          if (selectedCashMode == 1) _cardNumberInput(),
          if (selectedCashMode == 2) _benefitPayInput(),
        ],
        if (selectedCashMode == 3) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _buildAmountText(splitPaid, "Received Amount")),
              SizedBox(width: 10),
              Expanded(child: _buildAmountText(splitBal, "Balance Due")),
              SizedBox(width: 10),
              Expanded(child: _buildAmountText(splitTender, "Tender")),
            ],
          ),
          SizedBox(height: 8),
          _SplitItemListSection(),
        ],
        if (selectedCashMode != -1) ...[
          hightSpacer10,
          _orderNoteField(),
          hightSpacer20,
          _confirmOrderButton(),
        ],
        hightSpacer20,

        /*Expanded(
          child: DeliveryGrid(
            futureDelivery: DeliveryApiService.getDeliveryServices(),
            onSelect: (service) async {
              // 👇 call another API on single click
              // await ApiService.callOnDeliverySelected(service.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${service.deliveryName} Selected")),
              );
            },
          ),
        ),*/
        if (selectedDineMode == 0) ...[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 800, // constrain width so grid stays in center
                child: DeliveryGrid(
                  futureDelivery: DeliveryApiService.getDeliveryServices(),
                  onSelect: (service) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("${service.deliveryName} Selected")),
                    );
                    print("Delivery Id ${service.id}");
                    _deliveryId = service.id;
                    placeOrderApi();
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 🔹 Card Number Input
  Widget _cardNumberInput() => Container(
        width: 250,
        padding: horizontalSpace(),
        child: TextFieldWidget(
          boxDecoration: txtFieldBorderDecoration,
          txtCtrl: cardNumberCtrl,
          hintText: "Card Number",
          txtColor: DARK_GREY_COLOR,
        ),
      );

  /// 🔹 Benefit Pay Transaction Number
  Widget _benefitPayInput() => Container(
        width: 400,
        padding: horizontalSpace(),
        child: TextFieldWidget(
          boxDecoration: txtFieldBorderDecoration,
          txtCtrl: transRefCtrl,
          hintText: "Transaction Number",
          txtColor: DARK_GREY_COLOR,
        ),
      );

  /// 🔹 Split Payment Section
  Widget _splitPaymentSection() => Row(
        children: [
          Expanded(child: _SplitItemListSection()),
        ],
      );

  /// 🔹 Order Note Field
  Widget _orderNoteField() => Container(
        width: screenWidth,
        height: screenHeight * 0.10,
        padding: horizontalSpace(),
        child: MultiTextFieldWidget(
          boxDecoration: txtFieldBorderDecoration,
          txtCtrl: orderNoteCtrl,
          hintText: "Order Note",
          txtColor: DARK_GREY_COLOR,
        ),
      );

  /// 🔹 Confirm Order Button
  Widget _confirmOrderButton() => InkWell(
        onTap: () async {
          placeOrderApi();
        },
        child: Container(
          width: screenWidth,
          height: 50,
          decoration: BoxDecoration(
            color: MAIN_COLOR,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Confirm Order",
              style: getTextStyle(
                fontSize: LARGE_FONT_SIZE,
                color: WHITE_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

  Future<void> _printReceipt(
      String msg, List<TbDirectOrderDet> listOrder) async {
    print("_printReceipt");
    if (selectedPrinter == "IP Printer") {
      bool printStatus = await help.Helper().printProductionIPInvoice(
          context,
          printerIP!,
          listOrder,
          totalAmount,
          taxAmount,
          discountValue,
          msg,
          branch_name,
          branch_add1,
          branch_add2,
          branch_add3,
          branch_phone,
          branch_vat,
          branch_crno,
          "Table 1",
          _selectedEmployeeName);
      if (printStatus) {
        help.Helper.showToastSuccess(
            "IP ${printerIP!} Printing successful", context);
      } else {
        help.Helper.showToastFail("IP ${printerIP!} Printing Failed", context);
      }
    } else {
      await SunmiPrinter.bindingPrinter();

      bool printStatus = await help.Helper()
          .printProductionInternalSunmiInvoice(
              context,
              widget.orderItem,
              totalAmount,
              taxAmount,
              discountValue,
              deliveryAmount,
              msg,
              branch_name,
              branch_add1,
              branch_add2,
              branch_add3,
              branch_phone,
              branch_vat,
              branch_crno,
              "-",
              _selectedEmployeeName);
      if (printStatus) {
        help.Helper.showToastSuccess("Internal Printing successful", context);
      } else {
        help.Helper.showToastFail("Internal Printing Failed", context);
      }
    }
  }

/*
  Widget _buildTabletLayout(BuildContext context) {
    splitTotalList();
    return Stack(children: <Widget>[
      Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            padding: paddingXY(x: 10, y: 20),
            decoration: BoxDecoration(
              color: MAIN_COLOR,
              shape: BoxShape.rectangle,
              // borderRadius: BorderRadius.circular(12),
              // boxShadow: const [BoxShadow(blurRadius: 0.05)],
              border: Border.all(width: 1, color: GREY_COLOR),
            ),
            child: Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Payment",
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
                  padding: paddingXY(x: 20, y: 20),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.890,
                  child: Row(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                            color: WHITE_COLOR,
                            width: screenWidth * 0.40,
                            height: screenHeight,
                            child: Column(
                              children: [
                                const Divider(color: Colors.black38),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order Items",
                                      style: getTextStyle(
                                          fontSize: screenWidth * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${_orderedQty()} Items",
                                      // "$qty Items",
                                      style: getTextStyle(
                                        color: MAIN_COLOR,
                                        fontSize: screenWidth * 0.01,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(color: Colors.black38),
                                _cartItemListSection(),
                              ],
                            )),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: defaultTargetPlatform == TargetPlatform.iOS
                              ? 600
                              : 750,
                          child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                Text(
                                  "${totalAmount.toStringAsFixed(3)} $appCurrency2",
                                  style: getTextStyle(
                                      fontSize: screenWidth * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Total Amount",
                                  style: getTextStyle(
                                      fontSize: screenWidth * 0.01,
                                      fontWeight: FontWeight.w600),
                                ),
                                _paymentModeSection(),
                                hightSpacer10,
                                Text(
                                  selectedCashText.isNotEmpty
                                      ? "$selectedCashText Payment"
                                      : "",
                                  style: getTextStyle(
                                      fontSize: LARGE_MINUS_FONT_SIZE,
                                      fontWeight: FontWeight.bold),
                                ),
                                selectedCashMode == 0
                                    ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      receivedAmount.isNotEmpty
                                                          ? "${double.parse(receivedAmount).toStringAsFixed(3)} "
                                                          : "${totalAmount.toStringAsFixed(3)} ",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      appCurrency2,
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                  Text(
                                                    "Received Amount",
                                                    style: getTextStyle(
                                                        fontSize:
                                                            SMALL_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      "${balanceAmount.toStringAsFixed(3)} ",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      appCurrency2,
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                  Text(
                                                    "Balance Due",
                                                    style: getTextStyle(
                                                        fontSize:
                                                            SMALL_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          selectedCashMode == 0
                                              ? _cashPayment()
                                              : Container(),
                                        ],
                                      )
                                    : Container(),

                                selectedCashMode == 1
                                    ? Container(
                                        width: 250,
                                        // height: 100,
                                        padding: horizontalSpace(),
                                        child: TextFieldWidget(
                                          boxDecoration:
                                              txtFieldBorderDecoration,
                                          txtCtrl: cardNumberCtrl,
                                          hintText: "Card Number",
                                          txtColor: DARK_GREY_COLOR,
                                        ))
                                    : Container(),

                                // hightSpacer20,
                                selectedCashMode == 2
                                    ? Container(
                                        width: 400,
                                        // height: 100,
                                        padding: horizontalSpace(),
                                        child: TextFieldWidget(
                                          boxDecoration:
                                              txtFieldBorderDecoration,
                                          txtCtrl: transRefCtrl,
                                          hintText: "Transaction Number",
                                          txtColor: DARK_GREY_COLOR,
                                        ))
                                    : Container(),

                                selectedCashMode == 3
                                    ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(children: [
                                                    Text(
                                                      // receivedAmount.isNotEmpty
                                                      //     ? "${double.parse(receivedAmount).toStringAsFixed(3)} "
                                                      //     :"${splitPaid.toStringAsFixed(3)} ",
                                                      "${splitPaid.toStringAsFixed(3)} ",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "$appCurrency2",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                  Text(
                                                    "Received Amount",
                                                    style: getTextStyle(
                                                        fontSize:
                                                            SMALL_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      "${splitBal.toStringAsFixed(3)} ",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "$appCurrency2",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                  Text(
                                                    "Balance Due",
                                                    style: getTextStyle(
                                                        fontSize:
                                                            SMALL_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      "${splitTender.toStringAsFixed(3)} ",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "$appCurrency2",
                                                      style: getTextStyle(
                                                          fontSize:
                                                              LARGE_MINUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ]),
                                                  Text(
                                                    "Tender",
                                                    style: getTextStyle(
                                                        fontSize:
                                                            SMALL_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          // Split List
                                          _SplitItemListSection(),
                                        ],
                                      )
                                    : Container(),

                                hightSpacer10,
                                selectedCashMode != -1
                                    ? Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.10,
                                        padding: horizontalSpace(),
                                        child: MultiTextFieldWidget(
                                          boxDecoration:
                                              txtFieldBorderDecoration,
                                          txtCtrl: orderNoteCtrl,
                                          hintText: "Order Note",
                                          txtColor: DARK_GREY_COLOR,
                                        ))
                                    : Container(),
                                hightSpacer20,
                                selectedCashMode != -1
                                    ? InkWell(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                content: const Text(
                                                    "Are you sure to confirm this Order"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        // Navigator.pop(context,true);
                                                        // Navigator.of(context, rootNavigator: true).pop();
                                                        // dispose();
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        // Navigator.of(context, rootNavigator: true).pop();
                                                        // dispose();
                                                        List<TbDirectOrderPayment>
                                                            listPayment = [];
                                                        List<TbDirectOrderDet>
                                                            listOrder = [];
                                                        List<TbDirectOrderTopping>
                                                            listOrderTopping =
                                                            [];

                                                        TbDirectOrderPayment
                                                            payment =
                                                            TbDirectOrderPayment();

                                                        for (int i = 0;
                                                            i <
                                                                widget.orderItem
                                                                    .length;
                                                            i++) {
                                                          TbDirectOrderDet
                                                              items =
                                                              TbDirectOrderDet();
                                                          items.itemId =
                                                              int.parse(widget
                                                                  .orderItem[i]
                                                                  .id);
                                                          items.product = widget
                                                              .orderItem[i]
                                                              .name;
                                                          items.description =
                                                              widget
                                                                  .orderItem[i]
                                                                  .description;
                                                          items.selprodimg =
                                                              null;
                                                          items.selprodprice =
                                                              widget
                                                                  .orderItem[i]
                                                                  .price
                                                                  .toString();
                                                          items.rate = widget
                                                              .orderItem[i]
                                                              .price
                                                              .toString();
                                                          items.remarks = widget
                                                                  .orderItem[i]
                                                                  .message
                                                                  .isNotEmpty
                                                              ? true
                                                              : false;
                                                          items.name = "";
                                                          items.extraDesc = "";
                                                          items.nameonBox = "";
                                                          items.variationRemarks =
                                                              widget
                                                                  .orderItem[i]
                                                                  .message;
                                                          items.toppingAmount =
                                                              "";
                                                          items.itemStatus = 0;
                                                          items.selcode = null;
                                                          items.qty = widget
                                                              .orderItem[i]
                                                              .orderedQuantity
                                                              .toInt();
                                                          items.taxPercentage =
                                                              widget
                                                                  .orderItem[i]
                                                                  .tax
                                                                  .toInt();
                                                          items.taxCode = widget
                                                              .orderItem[i]
                                                              .taxCode;
                                                          items.tbDirectOrderDtlAssorted =
                                                              [];

                                                          if (widget
                                                              .orderItem[i]
                                                              .attributes
                                                              .isNotEmpty) {
                                                            for (int a = 0;
                                                                a <
                                                                    widget
                                                                        .orderItem[
                                                                            i]
                                                                        .attributes
                                                                        .length;
                                                                a++) {
                                                              Attribute attr = widget
                                                                  .orderItem[i]
                                                                  .attributes[a];
                                                              TbDirectOrderTopping
                                                                  topping =
                                                                  TbDirectOrderTopping();
                                                              topping.id =
                                                                  attr.id;
                                                              topping.toppingId =
                                                                  attr.toppingId;
                                                              topping.name =
                                                                  attr.name;
                                                              topping.rate =
                                                                  attr.rate;
                                                              topping.qty = attr
                                                                  .qty
                                                                  .toInt();
                                                              topping.checked =
                                                                  true;

                                                              listOrderTopping
                                                                  .add(topping);
                                                              items.tbDirectOrderTopping =
                                                                  listOrderTopping;
                                                            }
                                                          } else {
                                                            items.tbDirectOrderTopping =
                                                                [];
                                                          }
                                                          listOrder.add(items);
                                                        }
                                                        if (selectedCashMode !=
                                                            3) {
                                                          switch (
                                                              selectedCashMode) {
                                                            case 0:
                                                              payment.modeofPay =
                                                                  1;
                                                              payment.amount =
                                                                  receivedAmount
                                                                      .toString();
                                                              payment.cardNo =
                                                                  "";
                                                              break;
                                                            case 1:
                                                              payment.modeofPay =
                                                                  2;
                                                              payment.amount =
                                                                  totalAmount
                                                                      .toString();
                                                              payment.cardNo =
                                                                  cardNumberCtrl
                                                                      .text;
                                                              break;
                                                            case 2:
                                                              payment.modeofPay =
                                                                  3;
                                                              payment.amount =
                                                                  totalAmount
                                                                      .toString();
                                                              payment.cardNo =
                                                                  transRefCtrl
                                                                      .text;
                                                              break;
                                                          }
                                                          listPayment
                                                              .add(payment);
                                                        } else {
                                                          // List<TbDirectOrderPayment>
                                                          //     listPayment2 =
                                                          //     [];

                                                          for (int i = 0;
                                                              i <
                                                                  splitBillList
                                                                      .length;
                                                              i++) {
                                                            TbDirectOrderPayment
                                                                payment2 =
                                                                TbDirectOrderPayment();
                                                            switch (splitBillList[
                                                                    i]
                                                                .payment_type) {
                                                              case "Cash":
                                                                payment2
                                                                    .modeofPay = 1;
                                                                // log("splitBillList Payments : ${splitBillList[i].payment_type.toString()}");
                                                                break;
                                                              case "Card":
                                                                payment2
                                                                    .modeofPay = 2;
                                                                break;
                                                              case "Benefit Pay":
                                                                payment2
                                                                    .modeofPay = 3;
                                                                break;
                                                            }
                                                            payment2.amount =
                                                                splitBillList[i]
                                                                    .amount
                                                                    .toString();
                                                            payment2.cardNo =
                                                                splitBillList[i]
                                                                    .transaction_no;

                                                            // log("Payments : ${splitBillList[i]
                                                            //     .payment_type.toString()}");
                                                            // log("Payments : ${payment2.toString()}");
                                                            listPayment
                                                                .add(payment2);
                                                            // log("Payments List1 : ${listPayment.toString()}");
                                                          }
                                                          log("Payments List1 : ${listPayment.toString()}");
                                                          // listPayment.addAll(listPayment2);
                                                          // listPayment.addAll(listPayment);
                                                        }

                                                        String payMode = "";
                                                        if (selectedCashMode ==
                                                            0)
                                                          payMode = "1";
                                                        else if (selectedCashMode ==
                                                            1)
                                                          payMode = "2";
                                                        else if (selectedCashMode ==
                                                            2)
                                                          payMode = "3";
                                                        else if (selectedCashMode ==
                                                            3) payMode = "1";

                                                        Helper.showLoaderDialog(
                                                            context);

                                                        CartResponse cart = await CartApiService().insCartTakeAway(
                                                            branchId:
                                                                _selectedBranchId,
                                                            counterId:
                                                                _selectedCounterId,
                                                            clientId:
                                                                "${widget.customerId}",
                                                            payStatus: "1",
                                                            modeOfPay: payMode,
                                                            status: "4",
                                                            orderStatus: "1",
                                                            createrId:
                                                                _selectedEmployeeId,
                                                            subTotal:
                                                                subTotalAmount,
                                                            taxAmount:
                                                                taxAmount,
                                                            discountAmount:
                                                                widget.discount,
                                                            netAmount:
                                                                totalAmount,
                                                            balanceAmt:
                                                                balanceAmount,
                                                            tenderAmount:
                                                                splitTender,
                                                            orderItem:
                                                                listOrder,
                                                            paymentItem:
                                                                listPayment);

                                                        Navigator.pop(context);

                                                        Helper.hideLoader(
                                                            context);
                                                        if (cart.status == 1) {
                                                          Navigator.of(context)
                                                              .pop(cart);
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop(cart);
                                                        }
                                                      },
                                                      child: const Text('OK')),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: screenWidth,
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
                                              "Confirm Order",
                                              textAlign: TextAlign.center,
                                              style: getTextStyle(
                                                  fontSize: LARGE_FONT_SIZE,
                                                  color: WHITE_COLOR,
                                                  fontWeight: FontWeight.w600),
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
    ]);
  }
*/

  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      children: [
        // Top bar (fixed)
        Row(
          children: [
            Spacer(),
            Text(
              "Payment",
              style: getTextStyle(
                  fontSize: LARGE_PLUS_FONT_SIZE, color: BLACK_COLOR),
            ),
            Spacer(),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: miniPaddingAll(),
                child: SvgPicture.asset(
                  CROSS_ICON,
                  height: 20,
                  color: Colors.black,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        hightSpacer10,

        // Scrollable body + bottom button
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order items list
                      Container(
                        padding: paddingXY(x: 8, y: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: GREY_COLOR),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: Colors.black38),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order Items",
                                    style: getTextStyle(
                                        fontSize: MEDIUM_FONT_SIZE,
                                        fontWeight: FontWeight.bold)),
                                Text("${_orderedQty()} Items",
                                    style: getTextStyle(
                                        fontSize: MEDIUM_FONT_SIZE,
                                        color: MAIN_COLOR)),
                              ],
                            ),
                            Divider(color: Colors.black38),
                            SizedBox(height: 10),
                            _cartItemListSection_mob(),
                            const Divider(color: Colors.black38),
                            widget.orderItem.isEmpty
                                ? const SizedBox()
                                : _subtotalSection("Subtotal",
                                    "${subTotalAmount.toStringAsFixed(3)} $appCurrency2"),
                            widget.orderItem.isEmpty
                                ? const SizedBox()
                                : _subtotalSection(
                                    // "Discount", "- $discountValue $appCurrency2",
                                    widget.discountPer == 0.0
                                        ? "Discount"
                                        : "Discount (${widget.discountPer}%)",
                                    "- ${discountValue.toStringAsPrecision(3)} $appCurrency2",
                                    isDiscount: true),
                            widget.orderItem.isEmpty
                                ? const SizedBox()
                                : _subtotalSection("Tax ($taxPercentage%)",
                                    "${taxAmount.toStringAsFixed(3)} $appCurrency2"),
                            const Divider(
                              color: Colors.black,
                              thickness: 2.0,
                            ),
                            widget.orderItem.isEmpty
                                ? const SizedBox()
                                : _totalSection("Total",
                                    "${totalAmount.toStringAsFixed(3)} $appCurrency2"),
                          ],
                        ),
                      ),

                      /*hightSpacer10,

                      // Total summary
                      Text(
                        "${totalAmount.toStringAsFixed(3)} $appCurrency2",
                        style: getTextStyle(
                            fontSize: LARGE_FONT_SIZE,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total Amount",
                        style: getTextStyle(
                            fontSize: SMALL_PLUS_FONT_SIZE,
                            fontWeight: FontWeight.w600),
                      ),*/

                      hightSpacer10,
                      _paymentModeSection(),

                      if (selectedCashText.isNotEmpty)
                        Padding(
                          padding: verticalSpace(),
                          child: Text(
                            "$selectedCashText Payment",
                            style: getTextStyle(
                                fontSize: LARGE_MINUS_FONT_SIZE,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      if (selectedCashMode == 0) ...[
                        SizedBox(width: 50),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Spacer(flex: 1),
                              _buildAmountText(
                                  receivedAmount.isNotEmpty
                                      ? double.parse(receivedAmount)
                                      : totalAmount,
                                  "Received Amount"),
                              Spacer(flex: 1),
                              _buildAmountText(balanceAmount, "Balance Due"),
                              Spacer(flex: 1),
                            ],
                          ),
                        ),
                        SizedBox(width: 50),
                        _cashPayment(),
                      ],

                      if (selectedCashMode == 1)
                        Padding(
                          padding: horizontalSpace(),
                          child: TextFieldWidget(
                            boxDecoration: txtFieldBorderDecoration,
                            txtCtrl: cardNumberCtrl,
                            hintText: "Card Number",
                            txtColor: DARK_GREY_COLOR,
                          ),
                        ),

                      if (selectedCashMode == 2)
                        Padding(
                          padding: horizontalSpace(),
                          child: TextFieldWidget(
                            boxDecoration: txtFieldBorderDecoration,
                            txtCtrl: transRefCtrl,
                            hintText: "Transaction Number",
                            txtColor: DARK_GREY_COLOR,
                          ),
                        ),

                      // if (selectedCashMode == 3) _SplitItemListSection_mob(),
                      selectedCashMode == 3
                          ? Column(
                              children: [
                                // const SizedBox(
                                //   width: 50,
                                // ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: [
                                          Row(children: [
                                            Text(
                                              // receivedAmount.isNotEmpty
                                              //     ? "${double.parse(receivedAmount).toStringAsFixed(3)} "
                                              //     :"${splitPaid.toStringAsFixed(3)} ",
                                              "${splitPaid.toStringAsFixed(3)} ",
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              appCurrency2,
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                          Text(
                                            "Received Amount",
                                            style: getTextStyle(
                                                fontSize: SMALL_PLUS_FONT_SIZE,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Column(
                                        children: [
                                          Row(children: [
                                            Text(
                                              "${splitBal.toStringAsFixed(3)} ",
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "$appCurrency2",
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                          Text(
                                            "Balance Due",
                                            style: getTextStyle(
                                                fontSize: SMALL_PLUS_FONT_SIZE,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Column(
                                        children: [
                                          Row(children: [
                                            Text(
                                              "${splitTender.toStringAsFixed(3)} ",
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              appCurrency2,
                                              style: getTextStyle(
                                                  fontSize:
                                                      LARGE_MINUS_FONT_SIZE,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                          Text(
                                            "Tender",
                                            style: getTextStyle(
                                                fontSize: SMALL_PLUS_FONT_SIZE,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ]),
                                // SizedBox(
                                //   width: 50,
                                // ),
                                Row(children: [
                                  // Split List
                                  _SplitItemListSection(),
                                ]),
                              ],
                            )
                          : Container(),

                      hightSpacer10,

                      MultiTextFieldWidget(
                        boxDecoration: txtFieldBorderDecoration,
                        txtCtrl: orderNoteCtrl,
                        hintText: "Order Note",
                        txtColor: DARK_GREY_COLOR,
                      ),
                      hightSpacer10,
                      // Fixed Confirm button at bottom
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                // your confirm logic
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: MAIN_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Confirm Order",
                                    style: getTextStyle(
                                      fontSize: LARGE_FONT_SIZE,
                                      color: WHITE_COLOR,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            hightSpacer20,
                          ],
                        ),
                      ),

                      hightSpacer30,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountText(double amount, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${amount.toStringAsFixed(3)} ",
              style: getTextStyle(
                  fontSize: LARGE_MINUS_FONT_SIZE, fontWeight: FontWeight.bold),
            ),
            Text(
              appCurrency2,
              style: getTextStyle(
                  fontSize: LARGE_MINUS_FONT_SIZE, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          label,
          style: getTextStyle(
              fontSize: SMALL_PLUS_FONT_SIZE, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _cashPayment() {
    return Container(
      padding: paddingXY(x: 20, y: 20),
      color: Colors.white,
      width: defaultTargetPlatform == TargetPlatform.iOS
          ? 350
          : Device.get().isTablet
              ? 500
              : 600,
      // height: 200,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Spacer(),
          // const SizedBox(height: 100),
          // hightSpacer50,
          /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CustomOTPTextField(field1),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedContainer(
                      height: 25,
                      width: 120,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 650),
                      child: Center(
                          child: Text(
                        field1.isNotEmpty ? field1 : field2 ,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: getTextStyle(
                            fontSize: LARGE_ULTRA_PLUS_SIZE,
                            fontWeight: FontWeight.bold),
                      ))))
            ],
          ),*/
          // const Spacer(),
          // const SizedBox(height: 50),
          // hightSpacer50,
          // const Spacer(),

          Row(
            children: [
              buildNumberButton('1'),
              buildNumberButton('2'),
              buildNumberButton('3')
            ],
          ),
          Row(
            children: [
              buildNumberButton('4'),
              buildNumberButton('5'),
              buildNumberButton('6')
            ],
          ),
          Row(
            children: [
              buildNumberButton('7'),
              buildNumberButton('8'),
              buildNumberButton('9')
            ],
          ),
          Row(
            children: [
              buildNumberButton("."),
              buildNumberButton('0'),
              buildClearButton()
            ],
          ),

          // const SizedBox(height: 100),
          // Center(
          //   child: CustomButton(
          //     onPressed: widget.onPressed,
          //     text: widget.buttonText,
          //   ),
          // )
        ],
      )),
    );
  }

  Widget _paymentModeSection() {
    return Container(
      // color: Colors.black12,

      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // defaultTargetPlatform == TargetPlatform.iOS ? Spacer(flex: 1,) : Spacer(flex: 1,),
          _paymentOption(PAYMENT_CASH_ICON, "Cash", 0),
          // Spacer(flex: 1,),
          _paymentOption(PAYMENT_CARD_ICON, "Card", 1),
          // Spacer(flex: 1,),
          _paymentOption(PAYMENT_CARD_ICON, "Benefit Pay", 2),
          // Spacer(flex: 1,),
          _paymentOption(PAYMENT_CARD_ICON, "Split Pay", 3),
          // defaultTargetPlatform == TargetPlatform.iOS ? Spacer(flex: 8,) : Spacer(flex: 1,),
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
          } else if (isSelected == 1) {
            currenttabSelectedIndex = 1;
          } else if (isSelected == 2) {
            currenttabSelectedIndex = 2;
          } else if (isSelected == 3) {
            currenttabSelectedIndex = 3;
          }

          tabMenu[isSelected].isChecked = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color:
                    tabMenu[isSelected].isChecked ? Colors.red : Colors.black,
                width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        padding: Device.get().isTablet
            ? defaultTargetPlatform == TargetPlatform.iOS
                ? paddingXY(x: 10, y: 6)
                : paddingXY(x: 15, y: 6)
            : paddingXY(x: 5, y: 5),
        child: Row(
          children: [
            SvgPicture.asset(paymentIcon,
                height: Device.get().isTablet
                    ? defaultTargetPlatform == TargetPlatform.iOS
                        ? 30
                        : 35
                    : 20),
            Device.get().isTablet ? widthSpacer(10) : widthSpacer(5),
            Text(
              title,
              style: getTextStyle(
                  fontSize: Device.get().isTablet
                      ? MEDIUM_FONT_SIZE
                      : SMALL_PLUS_FONT_SIZE),
            )
          ],
        ),
      ),
    );
  }

  int _orderedQty() {
    double totalQty = 0.0;
    for (var product in widget.orderItem) {
      totalQty += product.orderedQuantity;
    }

    return totalQty.toInt();
  }

  /*Widget _cartItemListSection() {
    return widget.orderItem.isEmpty
        ? Expanded(
            child: Center(
              child: Image.asset(EMPTY_CART_TAB_IMAGE),
            ),
          )
        : Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (OrderItem item in widget.orderItem) itemListWidget(item),
                  const Divider(color: Colors.black38),
                  widget.orderItem.isEmpty
                      ? const SizedBox()
                      : _subtotalSection("Subtotal",
                          "${subTotalAmount.toStringAsFixed(3)} $appCurrency2"),
                  widget.orderItem.isEmpty
                      ? const SizedBox()
                      : _subtotalSection(
                          // "Discount", "- $discountValue $appCurrency2",
                          widget.discountPer == 0.0
                              ? "Discount"
                              : "Discount (${widget.discountPer}%)",
                          "- ${discountValue.toStringAsPrecision(3)} $appCurrency2",
                          isDiscount: true),
                  widget.orderItem.isEmpty
                      ? const SizedBox()
                      : _subtotalSection("Tax ($taxPercentage%)",
                          "${taxAmount.toStringAsFixed(3)} $appCurrency2"),
                  const Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  widget.orderItem.isEmpty
                      ? const SizedBox()
                      : _totalSection("Total",
                          "${totalAmount.toStringAsFixed(3)} $appCurrency2"),
                ],
              ),
            ));
  }*/
  Widget _cartItemListSection() {
    if (widget.orderItem.isEmpty) {
      return Center(
        child: Image.asset(EMPTY_CART_TAB_IMAGE),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (OrderItem item in widget.orderItem) itemListWidget(item),
          const Divider(color: Colors.black38),
          _subtotalSection(
              "Subtotal", "${subTotalAmount.toStringAsFixed(3)} $appCurrency2"),
          _subtotalSection(
              widget.discountPer == 0.0
                  ? "Discount"
                  : "Discount (${widget.discountPer}%)",
              "- ${discountValue.toStringAsPrecision(3)} $appCurrency2",
              isDiscount: true),
          _subtotalSection("Tax ($taxPercentage%)",
              "${taxAmount.toStringAsFixed(3)} $appCurrency2"),
          _subtotalSection("Delivery charges",
              "${deliveryAmount.toStringAsPrecision(3)} $appCurrency2",
              isDiscount: true),
          const Divider(color: Colors.black, thickness: 2.0),
          _totalSection(
              "Total", "${totalAmount.toStringAsFixed(3)} $appCurrency2"),
        ],
      ),
    );
  }

  Widget _cartItemListSection_mob() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.orderItem.length, (index) {
        final item = widget.orderItem[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.name,
                  style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
                ),
              ),
              Text(
                "${item.orderedQuantity} x ${item.price.toStringAsFixed(2)}",
                style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _subtotalSection(title, amount, {bool isDiscount = false}) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDiscount ? RED_COLOR : BLACK_COLOR,
                  fontSize: screenWidth * 0.015),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? RED_COLOR : BLACK_COLOR,
                  fontSize: screenWidth * 0.015),
            ),
          ],
        ),
      );

  Widget _totalSection(title, amount) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w700,
                  color: BLACK_COLOR,
                  fontSize: screenWidth * 0.02),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w700, fontSize: screenWidth * 0.02),
            ),
          ],
        ),
      );

  Widget itemListWidget(OrderItem item) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return GestureDetector(
        onTap: () {
          // _handleTap();
          // _updateItemToCart(item);
        },
        child: Container(

            //  width: double.infinity,
            // height: 100,

            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                        // height: 120,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                            item.name,
                            style: getTextStyle(
                                fontWeight: FontWeight.bold,
                                color: BLACK_COLOR,
                                fontSize: screenWidth * 0.01),
                          )),
                          Text(
                            "${item.orderedQuantity} (${item.price} $appCurrency2)",
                            style: getTextStyle(
                                fontSize: screenWidth * 0.01,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.end,
                          ),
                          Text("\t\t"),
                          Text(
                            "${_itemTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2",
                            style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                color: BLACK_COLOR,
                                fontSize: screenWidth * 0.01),
                          ),
                        ]),
                        // hightSpacer5,
                        ///////////////////////////////////////////////
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${_getItemVariants(item.attributes)}\n",
                              style: getTextStyle(
                                  fontSize: SMALL_PLUS_FONT_SIZE,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 50,
                              softWrap: false,
                            )),
                        // hightSpacer10,
                      ],
                    )),
                  ),
                ],
              ),
            )));
  }

  /*Widget _SplitItemListSection() {
    return Expanded(
        flex: 10,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              hightSpacer10,
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        splitBillCount += 1;
                        addList();
                        splitTotalList();
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          textAlign: TextAlign.center,
                          style: getTextStyle(
                              fontSize: LARGE_FONT_SIZE,
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: splitBillList.length,
                  itemBuilder: (BuildContext context, int index) {
                    amountRefCtrl.add(TextEditingController());
                    splittransRefCtrl.add(TextEditingController());
                    return splititemListWidget(splitBillList[index], index);
                  }),
            ],
          ),
        ));
  }*/
  Widget _SplitItemListSection() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hightSpacer10,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                setState(() {
                  splitBillCount += 1;
                  addList();
                  splitTotalList();
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Add",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: LARGE_FONT_SIZE,
                      color: WHITE_COLOR,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: splitBillList.length,
            itemBuilder: (BuildContext context, int index) {
              amountRefCtrl.add(TextEditingController());
              splittransRefCtrl.add(TextEditingController());
              return splititemListWidget(splitBillList[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _SplitItemListSection_mob() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                setState(() {
                  splitBillCount += 1;
                  addList();
                  splitTotalList();
                });
              },
              child: Container(
                alignment: Alignment.centerRight,
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: MAIN_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Add",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        fontSize: LARGE_FONT_SIZE,
                        color: WHITE_COLOR,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // optional
            // physics: ScrollPhysics(),
            itemCount: splitBillList.length,
            itemBuilder: (BuildContext context, int index) {
              amountRefCtrl.add(TextEditingController());
              splittransRefCtrl.add(TextEditingController());
              return splititemListWidget(splitBillList[index], index);
            }),
      ],
    );
    /* Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(splitBillList.length, (index) {
        final item = splitBillList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.payment_type,
                  style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
                ),
              ),
              Text(
                "${item.amount.toStringAsFixed(2)}",
                style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
              ),
            ],
          ),
        );
      }),
    );*/
  }

  Widget splititemListWidget(SplitBill item, int index) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    // amountRefCtrl.add(new TextEditingController());
    amountRefCtrl[index].text = "${item.amount.toStringAsPrecision(3)}";
    return GestureDetector(
        onTap: () {
          // _handleTap();
          // _updateItemToCart(item);
        },
        child: Container(

            //  width: double.infinity,
            // height: 100,

            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                        // height: 120,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          GestureDetector(
                            child: Text(
                              item.payment_type,
                              style: getTextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: BLACK_COLOR,
                                  fontSize: Device.get().isTablet
                                      ? screenWidth * 0.01
                                      : screenWidth * 0.03),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                          alertShowPaymentType(item, index),
                                      title: Center(
                                          child: Text(
                                        'Payment Mode',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Device.get().isTablet
                                                ? screenWidth * 0.01
                                                : screenWidth * 0.03),
                                      )),
                                    );
                                  });
                            },
                          ),
                          SizedBox(
                            width: Device.get().isTablet ? 80 : 20,
                          ),
                          /*Text(
                            "${item.amount.toStringAsPrecision(3)} $appCurrency2",
                            style: getTextStyle(
                                fontSize: SMALL_PLUS_FONT_SIZE,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.end,
                          ),*/
                          Container(
                            width: 100,
                            // height: 100,
                            padding: horizontalSpace(),
                            child: GestureDetector(
                              child: TextField(
                                enabled: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,3}'))
                                ],
                                controller: amountRefCtrl[index],
                                decoration: const InputDecoration(
                                    hintText: '0.000', suffixText: "BD"),
                                onChanged: (value) {
                                  item.amount = value.isNotEmpty
                                      ? double.parse(value)
                                      : 0.000;
                                  splitBillList.contains(item);
                                  log(splitBillList.toString());
                                  // splitTotalList();
                                },
                                onEditingComplete: () {
                                  splitTotalList();
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  // _isEnabled = !_isEnabled;
                                });
                              },
                            ),
                          ),
                          // Text("\t\t"),
                          SizedBox(
                            width: 20,
                          ),
                          item.payment_type != "Cash"
                              ? Container(
                                  width: 120,
                                  // height: 100,
                                  padding: horizontalSpace(),
                                  child: GestureDetector(
                                    child: TextField(
                                      enabled: true,
                                      keyboardType: TextInputType.text,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(
                                      //       RegExp(r'^(\d+)?\.?\d{0,3}'))
                                      // ],
                                      controller: splittransRefCtrl[index],
                                      decoration: const InputDecoration(
                                          hintText: 'No.', suffixText: ""),
                                      onChanged: (value) {
                                        item.transaction_no =
                                            value.isNotEmpty ? value : "";
                                        splitBillList.contains(item);
                                        log(splitBillList.toString());
                                        // splitTotalList();
                                      },
                                      onEditingComplete: () {
                                        splitTotalList();
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        // _isEnabled = !_isEnabled;
                                      });
                                    },
                                  ),
                                )
                              : Container(),

                          SizedBox(
                            width: 20,
                          ),
                          splitBillList.length > 2
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (splitBillList.length > 2) {
                                        splitBillCount -= 1;
                                        splitBillList.remove(item);
                                        updateList();
                                        splitTotalList();
                                      }
                                    });
                                  },
                                  child: splitBillList.length >= 2
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
                                          child: SvgPicture.asset(
                                            DELETE_IMAGE,
                                            color: Colors.black,
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      : Container(),
                                )
                              : Container(),
                        ]),
                      ],
                    )),
                  ),
                ],
              ),
            )));
  }

  _configureTaxAndTotal(List<OrderItem> items) {
    totalAmount = 0.0;
    subTotalAmount = 0.0;
    taxAmount = 0.0;
    totalItems = 0;
    taxPercentage = 0;
    for (OrderItem item in items) {
      //taxPercentage = taxPercentage + (item.tax * item.orderedQuantity);
      // log('Tax Percentage after adding ${item.name} :: $taxPercentage');
      // log("${item.price} ${item.orderedQuantity}$subTotalAmount");
      // subTotalAmount = subTotalAmount + (item.price * item.orderedQuantity);
      taxPercentage += item.tax!;
      subTotalAmount = subTotalAmount + (item.price * item.orderedQuantity);
      taxAmount += (subTotalAmount * taxPercentage) / 100;
      // log('SubTotal after adding ${item.name} :: $subTotalAmount');
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          //taxPercentage = taxPercentage + attribute.tax;
          // log('Tax Percentage after adding ${attribute.name} :: $taxPercentage');
          // if (attribute.options.isNotEmpty) {
          //   for (var options in attribute.options) {
          if (attribute.qty != 0) {
            //taxPercentage = taxPercentage + options.tax;
            subTotalAmount = subTotalAmount + attribute.rate * attribute.qty;
            // log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
          }
        }
        // }
        // }
      }
    }

    if (!isTax) {
      subTotalAmount = subTotalAmount - taxAmount;
      log("_itemTotal ${taxAmount}");
      // total = total - taxAmount;
    }

    //taxAmount = (subTotalAmount / 100) * taxPercentage;
    totalAmount = subTotalAmount + taxAmount - discountValue;
    //return taxPercentage;
    setState(() {});
  }

  double _itemTotal(
      double rate, double qty, List<Attribute> attr, OrderItem item) {
    double subtotal = 0.0;
    double itemtotal = 0.0;
    double total = 0.0;
    // for (var product in widget.orderList) {

    // if (attr.isNotEmpty) {
    itemtotal = qty * rate;
    for (var attribute in attr) {
      if (attribute.qty != 0) {
        subtotal += attribute.rate * attribute.qty;
      }
    }
    // total = itemtotal + subtotal;
    if (isTax) {
      total = itemtotal + subtotal;
    } else {
      total = itemtotal + subtotal;
      taxAmount = (total * item.tax) / 100;
      log("_itemTotal ${taxAmount}");
      total = total - taxAmount;
    }
    // }

    return total;
  }

  String _getItemVariants(List<Attribute> itemVariants) {
    String variants = '';
    double attrTotal = 0.0;
    if (itemVariants.isNotEmpty) {
      for (var variantData in itemVariants) {
        // for (var selectedOption in variantData.options) {
        if (variantData.qty != 0) {
          // variants = variants.isEmpty
          //     ?
          attrTotal = (variantData.rate * variantData.qty).toPrecision(2);
          variants +=
              '=> ${variantData.name} [${variantData.rate.toPrecision(2)} $appCurrency2 x ${variantData.qty} = ${attrTotal}]\n';
          // : "$variants, ${variantData.name} [$appCurrency ${variantData.rate.toStringAsFixed(3)}] [x ${variantData.qty}]\n";
        }
        // }
      }
    }
    return variants;
  }

  Widget buildNumberButton(String text) => KeypadButton(
        onPressed: () => setState(() {
          if (text == ".") {
            if (receivedAmount.isEmpty) {
              receivedAmount = "0";
            } else {
              receivedAmount = receivedAmount + text;
            }
          } else {
            receivedAmount = receivedAmount + text;
          }

          // receivedAmount = receivedAmount.isNotEmpty ? receivedAmount.substring(0, receivedAmount.length - 1) : totalAmount.toString();
          //
          // log(receivedAmount);

          balanceAmount = receivedAmount.isNotEmpty
              ? double.parse(receivedAmount) - totalAmount
              : 0.0;

          // Get.back(result: field1);
        }),
        /* child: Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            // duration: const Duration(milliseconds: 650),
            decoration: BoxDecoration(
              border: Border.all(color: TABLET_BG_COLOR, width: 1),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Center(
              child: Text(text,
                  style: getTextStyle(
                      fontSize: LARGE_ULTRA_PLUS_SIZE,
                      fontWeight: FontWeight.bold)),
            )),*/
        child: buildButtonContainer(
          child: Text(
            text,
            style: getTextStyle(
              fontSize: Device.get().isTablet
                  ? MediaQuery.of(context).size.width * 0.022
                  : MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget buildButtonContainer({required Widget child}) => Container(
        height: Device.get().isTablet ? 110 : 60,
        // Adjust as per your design (previously 120)
        width: Device.get().isTablet ? 110 : 60,
        margin: Device.get().isTablet ? EdgeInsets.all(10) : EdgeInsets.all(5),
        // Space between buttons
        decoration: BoxDecoration(
          color: TABLET_BG_COLOR, // Background color (matches design)
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      );

  Widget buildClearButton() => KeypadButton(
        onPressed: () => setState(
          () {
            // if (field4.isNotEmpty) {
            //   field4 = '';
            // } else if (field3.isNotEmpty) {
            //   field3 = '';
            // } else if (field2.isNotEmpty) {
            //   field2 = '';
            // } else if (field1.isNotEmpty) {
            receivedAmount = receivedAmount.isNotEmpty
                ? receivedAmount.substring(0, receivedAmount.length - 1)
                : totalAmount.toString();

            log(receivedAmount);

            balanceAmount = receivedAmount.isNotEmpty
                ? double.parse(receivedAmount) - totalAmount
                : 0.0;

            // widget.cashKey.currentState?.field1 = field1;

            // }
          },
        ),
        child: const Icon(Icons.backspace_outlined),
      );

  Widget alertShowPaymentType(SplitBill item, int index) {
    return Container(
      width: 100,
      height: 300,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: paymentList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                paymentList[index],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Device.get().isTablet ? 25 : 20),
              ),
              onTap: () {
                // selectedBranch(
                //     '${_arrBranch?[index].name}', '${_arrBranch?[index].id}');
                // _getDetails();

                setState(() {
                  item.payment_type = paymentList[index];
                  splitBillList.contains(item);
                });
                Navigator.of(context).pop();
              },
            );
          }),
    );
  }

  void getPaymentList() {
    paymentList.add("Cash");
    paymentList.add("Card");
    paymentList.add("Benefit Pay");
  }

  Future<void> placeOrderApi() async {
    late CartResponse cart;
    try {
      Helper.showLoaderDialog(context);

      List<TbDirectOrderPayment> listPayment = [];
      List<TbDirectOrderDet> listOrder = [];

      // 🔹 Build Order Items
      for (var orderItem in widget.orderItem) {
        List<TbDirectOrderTopping> listOrderTopping =
            []; // ✅ Fixed: unique per item

        final items = TbDirectOrderDet()
          ..itemId = int.parse(orderItem.id)
          ..product = orderItem.name
          ..description = orderItem.description
          ..selprodimg = null
          ..selprodprice = orderItem.price.toString()
          ..rate = orderItem.price.toString()
          ..remarks = orderItem.message.isNotEmpty
          ..name = ""
          ..extraDesc = ""
          ..nameonBox = ""
          ..variationRemarks = orderItem.message
          ..toppingAmount = ""
          ..itemStatus = 0
          ..selcode = null
          ..qty = orderItem.orderedQuantity.toInt()
          ..taxPercentage = orderItem.tax.toInt()
          ..taxCode = orderItem.taxCode
          ..tbDirectOrderDtlAssorted = [];

        // 🔹 Attributes -> Toppings
        for (var attr in orderItem.attributes) {
          final topping = TbDirectOrderTopping()
            ..id = attr.id
            ..toppingId = attr.toppingId
            ..name = attr.name
            ..rate = attr.rate
            ..qty = attr.qty.toInt()
            ..checked = true;
          listOrderTopping.add(topping);
        }
        items.tbDirectOrderTopping = listOrderTopping;
        listOrder.add(items);
      }

      // 🔹 Build Payments
      if (_deliveryId != 0) {
        listPayment.clear();
        final payment = TbDirectOrderPayment()
          ..modeofPay = 8
          ..amount = totalAmount
          ..cardNo = "";
        listPayment.add(payment);
      } else {
        if (selectedCashMode != 3) {
          final payment = TbDirectOrderPayment()
            ..modeofPay = (selectedCashMode == 0)
                ? 1
                : (selectedCashMode == 1)
                    ? 2
                    : 3
            // ..amount = (selectedCashMode == 0
            //     ? double.tryParse(receivedAmount) ?? 0.0
            //     : totalAmount).toStringAsFixed(3) as double?
            ..amount = (selectedCashMode == 0
                ? double.tryParse(receivedAmount) ?? 0.0
                : totalAmount)
            ..cardNo = (selectedCashMode == 1)
                ? cardNumberCtrl.text
                : (selectedCashMode == 2)
                    ? transRefCtrl.text
                    : "";
          listPayment.add(payment);
        } else {
          for (var split in splitBillList) {
            final payment = TbDirectOrderPayment()
              ..modeofPay = (split.payment_type == "Cash")
                  ? 1
                  : (split.payment_type == "Card")
                      ? 2
                      : 3
              // ..amount = (split.amount ?? 0.0).toStringAsFixed(3) as double?
              ..amount = split.amount ?? 0.0
              ..cardNo = split.transaction_no ?? "";
            listPayment.add(payment);
          }
        }
      }

      // 🔹 Pay Mode (first payment type)
      String payMode = _deliveryId != 0
          ? "8"
          : listPayment.isNotEmpty
              ? listPayment.first.modeofPay.toString()
              : "1";

      // 🔹 API Call fpr TakeAway
      /* final cart = await CartApiService().insCartTakeAway(
              branchId: _selectedBranchId,
              counterId: _selectedCounterId,
              clientId: "${widget.customerId}",
              payStatus: "1",
              modeOfPay: payMode,
              status: "4",
              orderStatus: "1",
              createrId: _selectedEmployeeId,
              subTotal: subTotalAmount,
              taxAmount: taxAmount,
              discountAmount: widget.discount,
              netAmount: totalAmount,
              balanceAmt: balanceAmount,
              tenderAmount: splitTender,
              orderItem: listOrder,
              paymentItem: listPayment,
            );*/

      //API Call for POS Order
       cart = await CartApiService().insCartPOS(
        branchId: _selectedBranchId,
        deliveryId: _deliveryId,
        counterId: _selectedCounterId,
        clientId: "${widget.customerId}",
        payStatus: "1",
        modeOfPay: payMode,
        status: "4",
        orderStatus: "1",
        createrId: _selectedEmployeeId,
        subTotal: subTotalAmount,
        taxAmount: taxAmount,
        discountAmount: widget.discount,
        netAmount: totalAmount,
        balanceAmt: balanceAmount,
        tenderAmount: splitTender,
        orderItem: listOrder,
        paymentItem: listPayment,
        deliveryAmount: deliveryAmount,
      );

      _printReceipt(cart.orderNo!, listOrder);

      Navigator.pop(context); // close loader
      Navigator.of(context).pop(cart); // return cart result
    } catch (e) {
      // Navigator.pop(context); // close loader if error
      Helper.hideLoader(context);
      debugPrint("Error confirming order: $e");
      _showDialog(context, "Failed to confirm order: ${cart.message!}");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to confirm order: $e")),
      // );

    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () async {
              if(message!.contains("logout and Open shift")){
                Navigator.pop(context);
                await SyncHelper().logoutFlow();
                Get.offAll(() => const LoginLandscape2());
              }else{
                Navigator.pop(context);
              }
            }
          )
        ],
      ),
    );
  }
}
