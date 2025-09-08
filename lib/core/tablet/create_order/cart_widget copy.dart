import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/core/tablet/create_order/create_order_landscape2.dart';
import 'package:nb_posx/core/tablet/create_order/sale_successful_popup_widget.dart';
import 'package:nb_posx/core/tablet/widget/item_remark_popup.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/db_utils/db_hub_manager.dart';
import '../../../database/db_utils/db_order_item.dart';
import '../../../database/db_utils/db_parked_order.dart';
import '../../../database/db_utils/db_preferences.dart';
import '../../../database/db_utils/db_sale_order.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/hub_manager.dart';
import '../../../database/models/option.dart';
import '../../../database/models/park_order.dart';
import '../../../database/models/sale_order.dart';
import '../../../network/api_constants/api_paths.dart';
import '../../../widgets/item_options2.dart';
import '../../service/api_cart/api/api_cart_service.dart';
import '../../service/api_cart/model/cart_data.dart';
import '../../service/api_cart/model/cart_response.dart';
import '../../service/api_cashier/api/api_cashier_common.dart';
import '../../service/api_cashier/model/addAndWithdrawCash.dart';
import '../../service/api_common/api/api_common_service.dart';
import '../../service/api_common/model/locationModel.dart';
import '../../service/api_common/model/tableLocationModel.dart';
import '../../service/api_table/model/table_model.dart' as tab;
import '../../service/api_table/model/table_model.dart';
import '../../service/create_order/api/create_sales_order.dart';
import '../home_tablet.dart';
import '../widget/create_customer_popup.dart';
import '../widget/delivery_popup.dart';
import '../widget/discount_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/select_payment_popup.dart';
import '../widget/select_table_popup.dart';

// ignore: must_be_immutable
class CartWidget extends StatefulWidget {
  Customer? customer;
  List<OrderItem> orderList;

  //List<OrderItem> orderList;
  Function onNewOrder, onHome, onPrintReceipt;
  Function(int i, double total) onCartUpdate;

  CartWidget({
    Key? key,
    this.customer,
    required this.orderList,
    required this.onNewOrder,
    required this.onHome,
    required this.onPrintReceipt,
    required this.onCartUpdate,
  }) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  Customer? selectedCustomer;

  // TableModel? selectedTable;
  tab.TbTable? selectedTable;
  TableLocation? selectedLocation;
  ParkOrder? currentCart;
  late bool selectedCashMode;
  int selectedDineMode = 0;
  late bool isOrderProcessed;
  String customerName = "Walk-in";
  String tableName = "-";
  String locationName = "-";
  double discountValue = 0.0;
  double discountPer = 0.0;
  double deliveryAmount = 0.0;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;
  int qty = 0;
  late bool fetchingData;
  List<ParkOrder> orderFromLocalDB = [];
  List<ParkOrder> parkedOrders = [];
  bool isPaymentOn = false;
  bool isTax = false;
  bool isCashierLogin = false;
  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedEmployeeName = "";

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String? branch_crno;

  AddWithdrawCash _addWithdrawCash = AddWithdrawCash();

  @override
  void initState() {
    fetchingData = true;
    isOrderProcessed = false;
    selectedCashMode = true;
    selectedCustomer = null;
    customerName = "Walk-in";
    selectedTable = null;
    tableName = "-";
    // selectedCustomer = widget.customer;

    // if(selectedCustomer != null){
    //   customerName = selectedCustomer!.name;
    // }else{
    // }
    log('Customer: ${customerName}');
    _getDetails();
    super.initState();
  }

  /*Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;
    DBPreferences dbPreferences = DBPreferences();
    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() async {
      isPaymentOn = prefs.getBool(isPayment) ?? false;
      _selectedEmployeeId = manager.id;
      isTax = prefs.getBool(isTaxOn) ?? false;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
      isCashierLogin =
          await dbPreferences.getPreference(isNewCashierLogin) ?? false;

      printerIP = prefs.getString('printer_ip') ?? "";
      selectedPrinter = prefs.getString('printer_type') ?? "No Printer";
      branch_name = prefs.getString(BranchName) ?? "";
      branch_add1 = prefs.getString(BranchAdd1) ?? "";
      branch_add2 = prefs.getString(BranchAdd2) ?? "";
      branch_add3 = prefs.getString(BranchAdd3) ?? "";
      branch_phone = prefs.getString(BranchPhone) ?? "";
      branch_vat = prefs.getString(BranchVAT) ?? "";
    });
  }*/

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;
    DBPreferences dbPreferences = DBPreferences();

    // Await all async calls first
    bool paymentOn = prefs.getBool(isPayment) ?? false;
    String employeeId = manager.id;
    String employeeName = manager.name;
    bool taxOn = prefs.getBool(isTaxOn) ?? false;
    String branch = prefs.getString(BranchName) ?? '';
    String branchId = prefs.getString(BranchId) ?? '';
    String counter = prefs.getString(CounterName) ?? '';
    String counterId = prefs.getString(CounterId) ?? '';
    bool cashierLogin =
        await dbPreferences.getPreference(isNewCashierLogin) ?? false;

    String ip = prefs.getString('printer_ip') ?? "";
    String printerType = prefs.getString('printer_type') ?? "No Printer";
    String branchName = prefs.getString(BranchName) ?? "";
    String add1 = prefs.getString(BranchAdd1) ?? "";
    String add2 = prefs.getString(BranchAdd2) ?? "";
    String add3 = prefs.getString(BranchAdd3) ?? "";
    String phone = prefs.getString(BranchPhone) ?? "";
    String vat = prefs.getString(BranchVAT) ?? "";
    String crno = prefs.getString(BranchCRNo) ?? "";

    // Now update state synchronously
    setState(() {
      isPaymentOn = paymentOn;
      _selectedEmployeeId = employeeId;
      _selectedEmployeeName = employeeName;
      isTax = taxOn;
      _selectedBranch = branch;
      _selectedBranchId = branchId;
      _selectedCounter = counter;
      _selectedCounterId = counterId;
      isCashierLogin = cashierLogin;

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

  @override
  void dispose() {
    // _prepareCart();
    selectedCustomer = null;
    customerName = "Walk-in";
    selectedTable = null;
    tableName = "-";
// getParkedOrders();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _configureTaxAndTotal(widget.orderList);
    // _getDetails();
    log('isPaymentOn: ${isPaymentOn}');
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: Device.get().isTablet
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.9,
          padding:
              Device.get().isTablet ? EdgeInsets.all(10) : EdgeInsets.all(20),
          color: Colors.transparent,
          height: Device.get().isTablet ? Get.height : 1080,
          child: Column(
            children: [
              _selectedCustomerSection(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart",
                    style: getTextStyle(
                        fontSize: Device.get().isTablet
                            ? MediaQuery.of(context).size.width * 0.01
                            : MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_orderedQty()} Items",
                    style: getTextStyle(
                      color: MAIN_COLOR,
                      fontSize: Device.get().isTablet
                          ? MediaQuery.of(context).size.width * 0.01
                          : MediaQuery.of(context).size.width * 0.03,
                    ),
                  )
                ],
              ),
              const Divider(color: Colors.black38),

              // This makes the cart list scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      widget.orderList.isEmpty
                          ? Column(children: [
                              Center(child: Image.asset(EMPTY_CART_TAB_IMAGE))
                            ])
                          : Column(
                              children: [
                                _customerOption(customerName),
                                hightSpacer10,
                                _DineModeSection(),
                                hightSpacer10,
                                if (selectedDineMode == 2) ...[
                                  _tableOption(tableName),
                                  hightSpacer10,
                                  _locationOption(locationName)
                                ],
                                for (OrderItem item in widget.orderList)
                                  itemListWidget2(item),
                              ],
                            ),
                    ],
                  ),
                ),
              ),

              Device.get().isTablet ? hightSpacer1 : hightSpacer4,
              // This ensures the cart summary always stays at the bottom
              widget.orderList.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        Device.get().isTablet ? hightSpacer10 : hightSpacer4,
                        _promoCodeSection(),
                        hightSpacer10,
                        _deliverySection(),
                        _subtotalSection("Subtotal",
                            "${subTotalAmount.toStringAsFixed(3)} $appCurrency2"),
                        _subtotalSection(
                            discountPer == 0.0
                                ? "Discount"
                                : "Discount ($discountPer%)",
                            "- ${discountValue.toStringAsPrecision(3)} $appCurrency2",
                            isDiscount: true),
                        _subtotalSection("Tax ($taxPercentage%)",
                            "${taxAmount.toStringAsFixed(3)} $appCurrency2"),
                        _subtotalSection(
                            deliveryAmount == 0.0
                                ? "Delivery"
                                : "Delivery ($deliveryAmount)",
                            "${deliveryAmount.toStringAsPrecision(3)} $appCurrency2",
                            isDiscount: true),
                        _totalSection("Total",
                            "${totalAmount.toStringAsFixed(3)} $appCurrency2"),
                        Device.get().isTablet ? hightSpacer1 : hightSpacer10,
                        Row(
                          children: [
                            Visibility(
                              visible: isPaymentOn,
                              child: Expanded(
                                  flex: 100, child: _showPaymentButton()),
                            ),
                            Expanded(
                              child: selectedDineMode == 2
                                  ? _showCartButton()
                                  : Container(),
                            ),
                          ],
                        ),
                        Device.get().isTablet ? hightSpacer1 : hightSpacer40,
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void showOpeningBalanceDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController remarksController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.3, // 30% of screen width
            // height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Open Shift",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "Please enter opening amount",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Amount",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Remarks",
                  ),
                ),
                // Spacer(), // Pushes buttons to the bottom
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      // Handle "Start Sales" action
                      _addWithdrawCash = await startDay(
                          amountController.text, remarksController.text);

                      if (_addWithdrawCash.status == 1 &&
                          _addWithdrawCash.result == "Success") {
                        Navigator.pop(context);
                        DBPreferences dbPreferences = DBPreferences();

                        // Do async work first
                        await dbPreferences.savePreference(
                            isNewCashierLogin, false);

                        // Then update state synchronously
                        setState(() {
                          isCashierLogin = false;
                        });
                        _handlePaymentPopup();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              content: Text(_addWithdrawCash.message!),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          },
                        );
                      }
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
                    // ),
                    child: Text(
                      "Start Sales",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<AddWithdrawCash> startDay(String amount, String remark) async {
    return CashierApiService().startDay(
      amount: amount,
      branchId: _selectedBranchId,
      userId: _selectedEmployeeId,
      counterId: _selectedCounterId,
      remarks: remark,
    );
  }

  int _orderedQty() {
    double totalQty = 0.0;
    for (var product in widget.orderList) {
      totalQty += product.orderedQuantity;
    }

    return totalQty.toInt();
  }

  double _itemTotal(
      double rate, double qty, List<Attribute> attr, OrderItem item) {
    double subtotal = 0.0;
    double itemtotal = 0.0;
    double total = 0.0;
    // for (var product in widget.orderList) {
    double taxAmount = 0;
    // if (attr.isNotEmpty) {
    itemtotal = qty * rate;
    for (var attribute in attr) {
      if (attribute.qty != 0) {
        subtotal += attribute.rate * attribute.qty;
      }
    }

    if (isTax) {
      total = itemtotal + subtotal;
    } else {
      total = itemtotal + subtotal;
      taxAmount = (total * item.tax) / 100;
      log("_itemTotal ${taxAmount}");
      total = total - taxAmount;
    }
    // taxAmount = (total * taxPercentage) / 100;
    // total = total + taxAmount;
    // }

    return total;
  }

  double _itemTaxTotal(
      double rate, double qty, List<Attribute> attr, OrderItem item) {
    double subtotal = 0.0;
    double itemtotal = 0.0;
    double total = 0.0;
    // for (var product in widget.orderList) {
    double taxAmount = 0;
    // if (attr.isNotEmpty) {
    itemtotal = qty * rate;
    for (var attribute in attr) {
      if (attribute.qty != 0) {
        subtotal += attribute.rate * attribute.qty;
      }
    }

    total = itemtotal + subtotal;
    taxAmount = (total * taxPercentage) / 100;
    if (isTax) {
      total = total + taxAmount;
    } else {
      total = taxAmount;
    }
    // }

    return total;
  }

  _handleTablePopup() async {
    selectedTable = null;
    tableName = "-";
    final result = await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SelectTablePopup(
          // customer: selectedTable,
          ),
    );
    if (result.runtimeType == String) {
      selectedTable = await Get.defaultDialog(
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        // custom: Container(),
        content: SelectTablePopup(
            // phoneNo: result,
            ),
      );
    }
    if (result != null) {
      selectedTable = result;
      if (selectedTable != null) {
        tableName = selectedTable!.tableNo.toString();
      }

      debugPrint("Table selected ${selectedTable.toString()}");
    }
    setState(() {});
  }

  _handleLocationPopup() async {
    TableLocationModel? locationModel =
        await CommonApiService().getTableLocationList(_selectedBranchId);

    selectedLocation = null;
    locationName = "-";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: alertShowLocation(locationModel),
            title: Center(
                child: Text(
              'Location',
              style: getTextStyle(
                  fontSize: Device.get().isTablet ? 40.0 : 20.0,
                  fontWeight: FontWeight.bold),
            )),
          );
        });
    // if (result != null) {
    //   selectedLocation = result;
    //   if (selectedLocation != null) {
    //     locationName = selectedLocation!.location.toString();
    //   }
    //
    //   debugPrint("Location selected");
    // }
    setState(() {});
  }

  Widget alertShowLocation(TableLocationModel locationModel) {
    // print('allBranchModel DATA : ${_counterModel.counter?.length}');

    final List<TableLocation>? _arrLocation = locationModel!.tableLocation!;

    return Container(
      width: 500,
      height: 500,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _arrLocation?.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${_arrLocation?[index].location}',
                style: getTextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Device.get().isTablet ? 25.0 : 18.0),
              ),
              onTap: () {
                // selectedBranch(
                //     '${_arrBranch?[index].name}', '${_arrBranch?[index].id}');
                selectedLocation = _arrLocation![index];
                log(selectedLocation.toString());
                if (selectedLocation != null) {
                  locationName = selectedLocation!.location.toString();
                }
                Navigator.of(context).pop();
                setState(() {});
              },
            );
          }),
    );
  }

  _handleRemarkPopup(OrderItem item) async {
    discountValue = 0.0;
    discountPer = 0.0;
    final result = await Get.defaultDialog(
      backgroundColor: Colors.transparent,

      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 10, y: 10),
      // custom: Container(),
      content: ItemRemarkPopup(
        // customer: selectedTable,
        message: item.message,
      ),
    );

    if (result != null) {
      if (result.toString().isEmpty) {
        item.message = "";
        widget.orderList.contains(item);
      } else {
        debugPrint("Remark Val ${result}");
        item.message = result;
        widget.orderList.contains(item);
      }

      // _configureTaxAndTotal(widget.orderList);
      // if (selectedTable != null) {
      //   tableName = selectedTable!.tableNo.toString();
      // }

      debugPrint("Remark added");
    }

    setState(() {});
  }

  _handleDiscountPopup() async {
    // discountValue = 0.0;
    // discountPer = 0.0;
    final result = await Get.defaultDialog(
      backgroundColor: Colors.transparent,

      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 10, y: 10),
      // custom: Container(),
      content: DiscountPopup(
          // customer: selectedTable,
          ),
    );

    if (result != null) {
      if (result.toString().contains("%")) {
        var r = result.toString().replaceAll("%", '');
        debugPrint("Discount Per ${r}");
        discountPer = double.parse(r);
        double dis_factor = (discountPer / 100);

        discountValue = subTotalAmount * dis_factor;
      } else {
        debugPrint("Discount Val ${result}");
        discountPer = 0.0;
        discountValue = double.parse(result);
      }

      _configureTaxAndTotal(widget.orderList);
      // if (selectedTable != null) {
      //   tableName = selectedTable!.tableNo.toString();
      // }

      debugPrint("Discount added");
    }

    setState(() {});
  }

  _handleDeliveryPopup() async {
    deliveryAmount = 0.0;
    final result = await Get.defaultDialog(
      backgroundColor: Colors.transparent,

      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 10, y: 10),
      // custom: Container(),
      content: DeliveryPopup(
          // customer: selectedTable,
          ),
    );

    if (result != null) {
      debugPrint("Delivery Val ${result}");
      deliveryAmount = double.parse(result);

      _configureTaxAndTotal(widget.orderList);
      // if (selectedTable != null) {
      //   tableName = selectedTable!.tableNo.toString();
      // }

      debugPrint("Delivery added");
    }

    setState(() {});
  }

  /*_handlePaymentPopup() async {
    final result =
        await Navigator.of(context).push(MaterialPageRoute<CartResponse>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return SelectPaymentPopup(
          amount: totalAmount,
          discount: discountValue,
          discountPer: discountPer,
          customerId:
              selectedCustomer != null ? int.parse(selectedCustomer!.id) : 186,
          orderItem: widget.orderList,
        );
      },
    ));

    // if (!context.mounted) return;

    if (result!.status == 1) {
      _showDialog(1, result.orderNo!);
    } else {
      _showDialog(0, result.message!);
    }
    debugPrint("Table selected $result");
    setState(() {});
  }*/

  _handlePaymentPopup() async {
    final result = await showDialog<CartResponse>(
      context: context,
      barrierDismissible: false, // prevent closing on tap outside
      builder: (BuildContext context) {
        return Dialog(
          // insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // almost fullscreen
            width: MediaQuery.of(context).size.width, // half width
            child: SelectPaymentPopup(
              amount: totalAmount,
              discount: discountValue,
              discountPer: discountPer,
              customerId: selectedCustomer != null
                  ? int.parse(selectedCustomer!.id)
                  : 186,
              selectedDineMode: selectedDineMode,
              orderItem: widget.orderList,
              deliveryAmount: deliveryAmount,
            ),
          ),
        );
      },
    );

    if (result != null) {
      if (result.status == 1) {
        _showDialog(1, result.orderNo!);
      } else {
        _showDialog(0, result.message!);
      }
      debugPrint("Table selected $result");
      setState(() {});
    }
  }

  // Future<void> _handlePaymentPopup() async {
  //   final result = await Navigator.push<CartResponse>(
  //     context,
  //     MaterialPageRoute(
  //       fullscreenDialog: true, // page style like a dialog
  //       builder: (context) => Scaffold(
  //         backgroundColor: Colors.white,
  //         body: SafeArea(
  //           child: SelectPaymentPopup(
  //             amount: totalAmount,
  //             discount: discountValue,
  //             discountPer: discountPer,
  //             customerId: selectedCustomer != null
  //                 ? int.parse(selectedCustomer!.id)
  //                 : 186,
  //             orderItem: widget.orderList,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   if (result != null) {
  //     if (result.status == 1) {
  //       _showDialog(1, result.orderNo!);
  //     } else {
  //       _showDialog(0, result.message!);
  //     }
  //     debugPrint("Table selected $result");
  //     setState(() {});
  //   }
  // }

  _handleCartPopup() async {
    List<TbDirectOrderPayment> listPayment = [];
    List<TbDirectOrderDet> listOrder = [];
    List<TbDirectOrderTopping> listOrderTopping = [];

    TbDirectOrderPayment payment = TbDirectOrderPayment();

    for (int i = 0; i < widget.orderList.length; i++) {
      TbDirectOrderDet items = TbDirectOrderDet();
      items.itemId = int.parse(widget.orderList[i].id);
      items.product = widget.orderList[i].name;
      items.description = widget.orderList[i].description;
      items.selprodimg = null;
      items.selprodprice = widget.orderList[i].price.toString();
      items.rate = widget.orderList[i].price.toString();
      items.remarks = widget.orderList[i].message.isNotEmpty ? true : false;
      items.name = "";
      items.extraDesc = "";
      items.nameonBox = "";
      items.variationRemarks = widget.orderList[i].message;
      items.toppingAmount = "";
      items.itemStatus = 0;
      items.selcode = null;
      items.qty = widget.orderList[i].orderedQuantity.toInt();
      items.taxPercentage = widget.orderList[i].tax.toInt();
      items.taxCode = widget.orderList[i].taxCode;
      items.tbDirectOrderDtlAssorted = [];

      if (widget.orderList[i].attributes.isNotEmpty) {
        for (int a = 0; a < widget.orderList[i].attributes.length; a++) {
          Attribute attr = widget.orderList[i].attributes[a];
          TbDirectOrderTopping topping = TbDirectOrderTopping();
          topping.id = attr.id;
          topping.toppingId = attr.toppingId;
          topping.name = attr.name;
          topping.rate = attr.rate;
          topping.qty = attr.qty.toInt();
          topping.checked = true;

          listOrderTopping.add(topping);
          items.tbDirectOrderTopping = listOrderTopping;
        }
      } else {
        items.tbDirectOrderTopping = [];
      }
      listOrder.add(items);
    }

    Helper.showLoaderDialog(context);

    debugPrint("Table selected ${selectedTable!.id}");

    CartResponse cart = await CartApiService().insCartDineOrder(
        branchId: _selectedBranchId,
        counterId: _selectedCounterId,
        clientId: "186",
        payStatus: "0",
        modeOfPay: "1",
        status: "1",
        orderStatus: "0",
        createrId: _selectedEmployeeId,
        subTotal: subTotalAmount,
        taxAmount: taxAmount,
        discountAmount: discountValue,
        netAmount: totalAmount,
        balanceAmt: 0.000,
        tenderAmount: 0.000,
        orderItem: listOrder,
        paymentItem: [],
        TableId: selectedTable!.id!,
        TableLocationId: selectedLocation!.id!,
        DirectOrdId: selectedTable!.directOrdId!);

    Helper.hideLoader(context);

    if (cart!.status == 1) {
      // _showDialog(1, cart.orderNo!);
      Helper.showSnackBar(context, cart.message!);
      selectedCustomer = null;
      selectedTable = null;
      selectedLocation = null;
      tableName = "";
      locationName = "";
      widget.onNewOrder();
      // dispose();
    } else {
      _showDialog(0, cart.message!);
    }
    debugPrint("Table selected ${cart.message}");

    setState(() {});
  }

  _showDialog(int status, String msg) async {
    if (status == 1) {
      var response = await Get.defaultDialog(
        barrierDismissible: true,
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        // custom: Container(),
        content: SaleSuccessfulPopup(
          order_no: msg,
          amount: totalAmount.toStringAsPrecision(3),
          items: widget.orderList.length,
          orderList: widget.orderList,
        ),
      );

      if (response == "home") {
        selectedCustomer = null;
        widget.onNewOrder();
      } else if (response == "print_receipt") {
        _printReceipt(msg, widget.orderList);
      } else if (response == "new_order") {
        selectedCustomer = null;
        widget.onNewOrder();
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(content: Text(msg), actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok')),
            ]);
          });
    }

    setState(() {
      if (status == 1) {
        // setState(() async {

        DbOrderItem().deleteProducts();
        widget.orderList = [];
        log("Cart List ${widget.orderList.toString()}");
        final selectedTab = "New Order".obs;

        // });
      }
    });
  }

  Future<void> _printReceipt(String msg, List<OrderItem> listOrder) async {
    print("_printReceipt");
    // if (selectedPrinter == "IP Printer") {
    //   bool printStatus = await Helper().printProductionIPInvoice(
    //       context,
    //       printerIP!,
    //       listOrder,
    //       totalAmount,
    //       taxAmount,
    //       discountValue,
    //       msg,
    //       branch_name,
    //       branch_add1,
    //       branch_add2,
    //       branch_add3,
    //       branch_phone,
    //       branch_vat,
    //       branch_crno,
    //       "Table 1",
    //       _selectedEmployeeName);
    //   if (printStatus) {
    //     Helper.showToastSuccess(
    //         "IP ${printerIP!} Printing successful", context);
    //   } else {
    //     Helper.showToastFail("IP ${printerIP!} Printing Failed", context);
    //   }
    // } else {
    await SunmiPrinter.bindingPrinter();

    bool printStatus = await Helper().printProductionInternalSunmiInvoice(
        context,
        listOrder,
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
      Helper.showToastSuccess("Internal Printing successful", context);
      selectedCustomer = null;
      widget.onNewOrder();
    } else {
      Helper.showToastFail("Internal Printing Failed", context);
    }
    // }
  }

  _handleCart() async {
    if (selectedCashMode == true) {
      // Helper.showPopupForTablet(context, "Coming Soon..");
      if (selectedTable != null && selectedLocation != null) {
        _handleCartPopup();
      } else if (selectedTable != null) {
        _handleLocationPopup();
      } else {
        _handleTablePopup();
      }
    } else {
      _prepareCart();
      if (currentCart != null) {
        {
          await _placeOrderHandler();

          // to be showed on successfull order placed
          _showOrderPlacedSuccessPopup();
        }
      } else {
        Helper.showPopupForTablet(context, "Please add items in cart");
      }
    }
  }

  _showCartButton() {
    return InkWell(
      onTap: () async {
        isCashierLogin ? showOpeningBalanceDialog(context) : _handleCart();
      },
      child: Container(
        width: double.infinity,
        padding: Device.get().isTablet ? paddingXY(y: 18) : paddingXY(y: 10),
        margin: paddingXY(y: 10, x: 5),
        decoration: BoxDecoration(
            color: widget.orderList.isNotEmpty
                ? MAIN_COLOR
                : MAIN_COLOR.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Save",
          textAlign: TextAlign.center,
          style:
              getTextStyle(color: WHITE_COLOR, fontSize: LARGE_MINUS_FONT_SIZE),
        ),
      ),
    );
  }

  _showPaymentButton() {
    return InkWell(
      onTap: () async {
        // if (selectedCashMode == true) {
        //   // Helper.showPopupForTablet(context, "Coming Soon..");

        isCashierLogin
            ? showOpeningBalanceDialog(context)
            : _handlePaymentPopup();
        // } else {
        //   _prepareCart();
        //   if (currentCart != null) {
        //     {
        //       await _placeOrderHandler();
        //
        //       // to be showed on successfull order placed
        //       _showOrderPlacedSuccessPopup();
        //     }
        //   } else {
        //     Helper.showPopupForTablet(context, "Please add items in cart");
        //   }
        // }
      },
      child: Container(
        width: double.infinity,
        padding: Device.get().isTablet ? paddingXY(y: 18) : paddingXY(y: 10),
        margin: paddingXY(y: 10, x: 5),
        decoration: BoxDecoration(
            color: widget.orderList.isNotEmpty
                ? MAIN_COLOR
                : MAIN_COLOR.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Pay",
          textAlign: TextAlign.center,
          style:
              getTextStyle(color: WHITE_COLOR, fontSize: LARGE_MINUS_FONT_SIZE),
        ),
      ),
    );
  }

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    // product.price = product.price;
    if (product.orderedQuantity == 0) {
      product.orderedQuantity = 1;
    }
    var res = await showDialog(
        context: context,
        builder: (context) {
          return ItemOptions2(
            orderItem: product,
            // attribute: attribute,
          );
        });
    if (res == true) {
      // widget.orderList.add(product);

      // widget.orderList.remove(product);
      // widget.orderList.add(product);
      // DbOrderItem().deleteProducts();
      widget.orderList.clear();
      widget.orderList = await DbOrderItem().updateInventory(product);

      // log("Update Cart Item ${widget.orderList.toString()}");
      // widget.orderList.remove(product);
      // widget.orderList = await DbOrderItem().getAllProducts();
    }

    setState(() {});
  }

  Widget itemListWidget(OrderItem item) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return GestureDetector(
        onTap: () {
          // _handleTap();
          // _updateItemToCart(item);
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            //  width: double.infinity,
            // height: 100,

            margin: const EdgeInsets.only(bottom: 8, top: 15, right: 8),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      width: 55,
                      height: 55,
                      child: item.productImageUrl!.isEmpty
                          ? Image.asset(
                              'assets/images/rue_no_img.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              fit: BoxFit.cover,
                              "$RUE_IMAGE_BASE_PATH${item.productImageUrl}"),
                    ),
                  ),
                  // Image.asset(BURGAR_IMAGE),
                  // widthSpacer(10),
                  Expanded(
                    child: SizedBox(
                        // height: 120,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    item.name,
                                    style: getTextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: BLACK_COLOR,
                                        fontSize: Device.get().isTablet
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01),
                                  ))),
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.orderList.remove(item);
                                _configureTaxAndTotal(widget.orderList);
                                // await DbOrderItem().deleteProductById(int.parse(item.id));
                                widget.onCartUpdate(
                                    widget.orderList.length, totalAmount);
                                Helper.showToastInfo(
                                    "Item removed from Cart", context);
                              });
                            },
                            child: Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: SvgPicture.asset(
                                  DELETE_IMAGE,
                                  color: Colors.black,
                                  width: Device.get().isTablet ? 25 : 15,
                                  height: Device.get().isTablet ? 25 : 15,
                                ),
                              ),
                            ),
                          )
                        ]),

                        item.attributes.isNotEmpty
                            ? hightSpacer10
                            : hightSpacer5,
                        ///////////////////////////////////////////////

                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "${_getItemVariants(item.attributes)}\n x ${item.orderedQuantity} (${item.price} $appCurrency2)",
                                      style: getTextStyle(
                                          fontSize: Device.get().isTablet
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 50,
                                      softWrap: false,
                                    ))),
                            Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // widget.orderList.remove(item);
                                      _handleRemarkPopup(item);
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
                                    child: Icon(
                                      Icons.message_outlined,
                                      color: item.message.isEmpty
                                          ? Colors.black
                                          : Colors.green,
                                      size: Device.get().isTablet ? 25 : 15,
                                    ),
                                  ),
                                )),
                          ],
                        ),

                        hightSpacer15,
                        /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${_itemTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2 ",
                                style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: GREEN_COLOR,
                                    fontSize: MEDIUM_PLUS_FONT_SIZE),
                              ),

                              Text(
                                isTax
                                    ? "(+"
                                        "${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)"
                                    : "(-"
                                        "${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)",
                                style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: RED_COLOR,
                                    fontSize: MEDIUM_FONT_SIZE),
                              ),
                              const Spacer(
                                flex: 10,
                              ),
                              // const Icon(Icons.delete)
                              Container(
                                  alignment: Alignment.topRight,
                                  width: 150,
                                  // defaultTargetPlatform ==
                                  //         TargetPlatform.iOS
                                  //     ? 150
                                  //     : 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: MAIN_COLOR,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          BORDER_CIRCULAR_RADIUS_06)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (item.orderedQuantity > 1) {
                                              item.orderedQuantity =
                                                  item.orderedQuantity - 1;

                                              for (int i = 0;
                                                  i < item.attributes.length;
                                                  i++) {
                                                String inString = (item
                                                            .attributes[i].moq *
                                                        item.orderedQuantity)
                                                    .toStringAsFixed(
                                                        2); // '2.35'
                                                double inDouble =
                                                    double.parse(inString)
                                                        .toPrecision(2); // 2.35
                                                item.attributes[i].qty =
                                                    inDouble;
                                              }
                                            } else {
                                              widget.orderList.remove(item);
                                              Helper.showToastInfo(
                                                  "Item removed from Cart",
                                                  context);
                                              _configureTaxAndTotal(
                                                  widget.orderList);
                                              // await DbOrderItem().deleteProductById(int.parse(item.id));
                                              widget.onCartUpdate(
                                                  widget.orderList.length,
                                                  totalAmount);
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? 20
                                                : 25,
                                          )),
                                      greySizedBox,
                                      Container(
                                          // color: MAIN_COLOR.withOpacity(0.1),
                                          padding: defaultTargetPlatform ==
                                                  TargetPlatform.iOS
                                              ? EdgeInsets.fromLTRB(5, 0, 5, 0)
                                              : EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Text(
                                            item.orderedQuantity
                                                .toInt()
                                                .toString(),
                                            style: getTextStyle(
                                              fontSize: MEDIUM_PLUS_FONT_SIZE,
                                              fontWeight: FontWeight.w600,
                                              color: MAIN_COLOR,
                                            ),
                                          )),
                                      greySizedBox,
                                      ///////////////
                                      InkWell(
                                          onTap: () {
                                            item.orderedQuantity =
                                                item.orderedQuantity + 1;

                                            for (int i = 0;
                                                i < item.attributes.length;
                                                i++) {
                                              String inString = (item
                                                          .attributes[i].moq *
                                                      item.orderedQuantity)
                                                  .toStringAsFixed(2); // '2.35'
                                              double inDouble =
                                                  double.parse(inString)
                                                      .toPrecision(2); // 2.35
                                              item.attributes[i].qty = inDouble;
                                            }
                                            _configureTaxAndTotal(
                                                widget.orderList);
                                            widget.onCartUpdate(
                                                widget.orderList.length,
                                                totalAmount);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? 20
                                                : 25,
                                          )),
                                    ],
                                  )),
                              Spacer(),
                            ]),*/
                        Row(
                          children: [
                            // Expanded for the first text (Total)
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.zero,
                                // Remove any default padding
                                child: Text(
                                  "${_itemTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2",
                                  style: getTextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: GREEN_COLOR,
                                      fontSize: Device.get().isTablet
                                          ? MediaQuery.of(context).size.width *
                                              0.01
                                          : MediaQuery.of(context).size.width *
                                              0.01),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                            ),
                            // Expanded for the second text (Tax)
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  isTax
                                      ? "(+${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)"
                                      : "(-${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)",
                                  style: getTextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: RED_COLOR,
                                      fontSize: Device.get().isTablet
                                          ? MediaQuery.of(context).size.width *
                                              0.01
                                          : MediaQuery.of(context).size.width *
                                              0.01),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Fixed container for plus/minus buttons
                            Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: MAIN_COLOR),
                                    borderRadius: BorderRadius.circular(
                                        BORDER_CIRCULAR_RADIUS_06),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (item.orderedQuantity > 1) {
                                              item.orderedQuantity =
                                                  item.orderedQuantity - 1;
                                              for (int i = 0;
                                                  i < item.attributes.length;
                                                  i++) {
                                                String inString = (item
                                                            .attributes[i].moq *
                                                        item.orderedQuantity)
                                                    .toStringAsFixed(2);
                                                double inDouble =
                                                    double.parse(inString)
                                                        .toPrecision(2);
                                                item.attributes[i].qty =
                                                    inDouble;
                                              }
                                            } else {
                                              widget.orderList.remove(item);
                                              Helper.showToastInfo(
                                                  "Item removed from Cart",
                                                  context);
                                              _configureTaxAndTotal(
                                                  widget.orderList);
                                              widget.onCartUpdate(
                                                  widget.orderList.length,
                                                  totalAmount);
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? 20
                                                : 25,
                                          )),
                                      greySizedBox,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(
                                          item.orderedQuantity
                                              .toInt()
                                              .toString(),
                                          style: getTextStyle(
                                            fontSize: Device.get().isTablet
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                            fontWeight: FontWeight.w600,
                                            color: MAIN_COLOR,
                                          ),
                                        ),
                                      ),
                                      greySizedBox,
                                      InkWell(
                                          onTap: () {
                                            item.orderedQuantity =
                                                item.orderedQuantity + 1;
                                            for (int i = 0;
                                                i < item.attributes.length;
                                                i++) {
                                              String inString =
                                                  (item.attributes[i].moq *
                                                          item.orderedQuantity)
                                                      .toStringAsFixed(2);
                                              double inDouble =
                                                  double.parse(inString)
                                                      .toPrecision(2);
                                              item.attributes[i].qty = inDouble;
                                            }
                                            _configureTaxAndTotal(
                                                widget.orderList);
                                            widget.onCartUpdate(
                                                widget.orderList.length,
                                                totalAmount);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? 20
                                                : 25,
                                          )),
                                    ],
                                  ),
                                )),
                            const SizedBox(width: 10),
                          ],
                        )
                      ],
                    )),
                  ),
                ],
              ),
            )));
  }

  Widget itemListWidget2(OrderItem item) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(),
      // empty left-swipe background
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: Device.get().isTablet
            ? EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.symmetric(horizontal: 10),
        margin: Device.get().isTablet
            ? EdgeInsets.only(bottom: 5, top: 10, right: 8)
            : EdgeInsets.only(bottom: 8, top: 15, right: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        OrderItem removedItem = item;
        int index = widget.orderList.indexOf(item);

        setState(() {
          widget.orderList.removeAt(index);
          _configureTaxAndTotal(widget.orderList);
          widget.onCartUpdate(widget.orderList.length, totalAmount);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Item removed from cart"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "UNDO",
              onPressed: () {
                setState(() {
                  widget.orderList.insert(index, removedItem);
                  _configureTaxAndTotal(widget.orderList);
                  widget.onCartUpdate(widget.orderList.length, totalAmount);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        // height: Device.get().isPhone ? 150 : 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(1, 1),
            ),
          ],
        ),
        margin: Device.get().isTablet
            ? EdgeInsets.only(bottom: 2, top: 10, right: 5)
            : EdgeInsets.only(top: 5),
        child: Padding(
          padding:
              Device.get().isTablet ? EdgeInsets.all(5) : EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 55,
                  height: 55,
                  child: item.productImageUrl!.isEmpty
                      ? Image.asset('assets/images/rue_no_img.png',
                          fit: BoxFit.cover)
                      : Image.network(
                          "$RUE_IMAGE_BASE_PATH${item.productImageUrl}",
                          fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            item.name,
                            style: getTextStyle(
                                fontWeight: FontWeight.bold,
                                color: BLACK_COLOR,
                                fontSize: Device.get().isTablet
                                    ? MediaQuery.of(context).size.width * 0.01
                                    : MediaQuery.of(context).size.width * 0.02),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _handleRemarkPopup(item);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                            child: Icon(
                              Icons.message_outlined,
                              color: item.message.isEmpty
                                  ? Colors.black
                                  : Colors.green,
                              size: Device.get().isTablet
                                  ? MediaQuery.of(context).size.width * 0.015
                                  : MediaQuery.of(context).size.width * 0.0500,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    item.attributes.isNotEmpty ? hightSpacer10 : hightSpacer5,
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${_getItemVariants(item.attributes)}\n x ${item.orderedQuantity} (${item.price} $appCurrency2)",
                              style: getTextStyle(
                                  fontSize: Device.get().isTablet
                                      ? MediaQuery.of(context).size.width * 0.01
                                      : MediaQuery.of(context).size.width *
                                          0.02,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 50,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    item.attributes.isNotEmpty ? hightSpacer15 : hightSpacer5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: Device.get().isTablet ? 2 : 2,
                          child: Text(
                            "${_itemTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2",
                            style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                color: GREEN_COLOR,
                                fontSize: Device.get().isTablet
                                    ? MediaQuery.of(context).size.width * 0.01
                                    : MediaQuery.of(context).size.width *
                                        0.0200),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          flex: Device.get().isTablet ? 2 : 2,
                          child: Text(
                            isTax
                                ? "(+${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)"
                                : "(-${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)",
                            style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                color: RED_COLOR,
                                fontSize: Device.get().isTablet ? 12.0 : 7.0),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Device.get().isTablet
                            ? SizedBox(width: 10)
                            : SizedBox(width: 2),
                        /*Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: MAIN_COLOR),
                              borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (item.orderedQuantity > 1) {
                                      item.orderedQuantity -= 1;
                                      for (int i = 0; i < item.attributes.length; i++) {
                                        String inString = (item.attributes[i].moq * item.orderedQuantity).toStringAsFixed(2);
                                        double inDouble = double.parse(inString).toPrecision(2);
                                        item.attributes[i].qty = inDouble;
                                      }
                                    } else {
                                      widget.orderList.remove(item);
                                      Helper.showToastInfo("Item removed from Cart", context);
                                    }
                                    _configureTaxAndTotal(widget.orderList);
                                    widget.onCartUpdate(widget.orderList.length, totalAmount);
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.remove, size: 25),
                                ),
                                greySizedBox,
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    item.orderedQuantity.toInt().toString(),
                                    style: getTextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.01,
                                      fontWeight: FontWeight.w600,
                                      color: MAIN_COLOR,
                                    ),
                                  ),
                                ),
                                greySizedBox,
                                InkWell(
                                  onTap: () {
                                    item.orderedQuantity += 1;
                                    for (int i = 0; i < item.attributes.length; i++) {
                                      String inString = (item.attributes[i].moq * item.orderedQuantity).toStringAsFixed(2);
                                      double inDouble = double.parse(inString).toPrecision(2);
                                      item.attributes[i].qty = inDouble;
                                    }
                                    _configureTaxAndTotal(widget.orderList);
                                    widget.onCartUpdate(widget.orderList.length, totalAmount);
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.add, size: 25),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Expanded(
                          flex: Device.get().isTablet ? 3 : 3,
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: Device.get().isTablet ? 170 : 180,
                            height: Device.get().isTablet ? 80 : 50,
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: MAIN_COLOR),
                            //   borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (item.orderedQuantity > 1) {
                                      item.orderedQuantity -= 1;
                                      for (int i = 0;
                                          i < item.attributes.length;
                                          i++) {
                                        String inString =
                                            (item.attributes[i].moq *
                                                    item.orderedQuantity)
                                                .toStringAsFixed(2);
                                        double inDouble = double.parse(inString)
                                            .toPrecision(2);
                                        item.attributes[i].qty = inDouble;
                                      }
                                    } else {
                                      widget.orderList.remove(item);
                                      Helper.showToastInfo(
                                          "Item removed from Cart", context);
                                    }
                                    _configureTaxAndTotal(widget.orderList);
                                    widget.onCartUpdate(
                                        widget.orderList.length, totalAmount);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: Device.get().isTablet ? 50 : 30,
                                    height: Device.get().isTablet ? 50 : 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MAIN_COLOR.withOpacity(0.1),
                                    ),
                                    child: Icon(Icons.remove,
                                        size: Device.get().isTablet ? 25 : 20,
                                        color: MAIN_COLOR),
                                  ),
                                ),
                                // greySizedBox,
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    item.orderedQuantity.toInt().toString(),
                                    style: getTextStyle(
                                      fontSize: Device.get().isTablet
                                          ? MediaQuery.of(context).size.width *
                                              0.012
                                          : MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.w600,
                                      color: MAIN_COLOR,
                                    ),
                                  ),
                                ),
                                // greySizedBox,
                                InkWell(
                                  onTap: () {
                                    item.orderedQuantity += 1;
                                    for (int i = 0;
                                        i < item.attributes.length;
                                        i++) {
                                      String inString =
                                          (item.attributes[i].moq *
                                                  item.orderedQuantity)
                                              .toStringAsFixed(2);
                                      double inDouble =
                                          double.parse(inString).toPrecision(2);
                                      item.attributes[i].qty = inDouble;
                                    }
                                    _configureTaxAndTotal(widget.orderList);
                                    widget.onCartUpdate(
                                        widget.orderList.length, totalAmount);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: Device.get().isTablet ? 50 : 30,
                                    height: Device.get().isTablet ? 50 : 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MAIN_COLOR.withOpacity(0.1),
                                    ),
                                    child: Icon(Icons.add,
                                        size: Device.get().isTablet ? 25 : 20,
                                        color: MAIN_COLOR),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Device.get().isTablet
                            ? SizedBox(width: 10)
                            : SizedBox(width: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget itemListWidget2(OrderItem item) {
    final Widget greySizedBox = SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 8, top: 15, right: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        // Optionally check if swipe starts from the edge (already default behavior)
        bool confirmed = false;
        OrderItem removedItem = item;
        int index = widget.orderList.indexOf(item);

        setState(() {
          widget.orderList.remove(item);
          _configureTaxAndTotal(widget.orderList);
          widget.onCartUpdate(widget.orderList.length, totalAmount);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Item removed from cart"),
            action: SnackBarAction(
              label: "UNDO",
              onPressed: () {
                setState(() {
                  widget.orderList.insert(index, removedItem);
                  _configureTaxAndTotal(widget.orderList);
                  widget.onCartUpdate(widget.orderList.length, totalAmount);
                });
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(1, 1),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 8, top: 15, right: 8),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 55,
                  height: 55,
                  child: item.productImageUrl!.isEmpty
                      ? Image.asset('assets/images/rue_no_img.png', fit: BoxFit.cover)
                      : Image.network(
                      "$RUE_IMAGE_BASE_PATH${item.productImageUrl}",
                      fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  item.name,
                                  style: getTextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: BLACK_COLOR,
                                      fontSize: MediaQuery.of(context).size.width * 0.01),
                                ))),
                      ]),
                      item.attributes.isNotEmpty ? hightSpacer10 : hightSpacer5,
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "${_getItemVariants(item.attributes)}\n x ${item.orderedQuantity} (${item.price} $appCurrency2)",
                                    style: getTextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.01,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 50,
                                    softWrap: false,
                                  ))),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _handleRemarkPopup(item);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
                                child: Icon(
                                  Icons.message_outlined,
                                  color: item.message.isEmpty ? Colors.black : Colors.green,
                                  size: MediaQuery.of(context).size.width * 0.015,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      hightSpacer15,
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.zero,
                              child: Text(
                                "${_itemTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2",
                                style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: GREEN_COLOR,
                                    fontSize: MediaQuery.of(context).size.width * 0.01),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.zero,
                              child: Text(
                                isTax
                                    ? "(+${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)"
                                    : "(-${_itemTaxTotal(item.orderedQuantity, item.price, item.attributes, item).toStringAsFixed(2)} $appCurrency2)",
                                style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: RED_COLOR,
                                    fontSize: MediaQuery.of(context).size.width * 0.01),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 3,
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 150,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(color: MAIN_COLOR),
                                  borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          if (item.orderedQuantity > 1) {
                                            item.orderedQuantity -= 1;
                                            for (int i = 0; i < item.attributes.length; i++) {
                                              String inString =
                                              (item.attributes[i].moq *
                                                  item.orderedQuantity)
                                                  .toStringAsFixed(2);
                                              double inDouble =
                                              double.parse(inString)
                                                  .toPrecision(2);
                                              item.attributes[i].qty = inDouble;
                                            }
                                          } else {
                                            widget.orderList.remove(item);
                                                        Helper.showToastInfo("Item removed from Cart", context);
                                            _configureTaxAndTotal(widget.orderList);
                                            widget.onCartUpdate(widget.orderList.length, totalAmount);
                                          }
                                          setState(() {});
                                        },
                                        child: Icon(Icons.remove, size: 25)),
                                    greySizedBox,
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        item.orderedQuantity.toInt().toString(),
                                        style: getTextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.01,
                                          fontWeight: FontWeight.w600,
                                          color: MAIN_COLOR,
                                        ),
                                      ),
                                    ),
                                    greySizedBox,
                                    InkWell(
                                        onTap: () {
                                          item.orderedQuantity += 1;
                                          for (int i = 0; i < item.attributes.length; i++) {
                                            String inString =
                                            (item.attributes[i].moq *
                                                item.orderedQuantity)
                                                .toStringAsFixed(2);
                                            double inDouble =
                                            double.parse(inString)
                                                .toPrecision(2);
                                            item.attributes[i].qty = inDouble;
                                          }
                                          _configureTaxAndTotal(widget.orderList);
                                          widget.onCartUpdate(widget.orderList.length, totalAmount);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.add, size: 25)),
                                  ],
                                ),
                              )),
                          const SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

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
          // : "$variants, ${variantData.name} [$appCurrency ${variantData.rate.toStringAsFixed(2)}] [x ${variantData.qty}]\n";
        }
        // }
      }
    }
    return variants;
  }

  Widget _promoCodeSection() {
    return InkWell(
        onTap: () {
          setState(() {
            // selectedCashMode = !selectedCashMode;
            // if (selectedCustomer == null) {
            if (discountValue == 0.0) {
              _handleDiscountPopup();
            } else {
              discountValue = 0.0;
              discountPer = 0.0;
              _configureTaxAndTotal(widget.orderList);
            }
            // }
          });
        },
        child: Container(
          // height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              // color: MAIN_COLOR.withOpacity(0.1),
              // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.5)),
              color: Colors.redAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR,
                    fontSize: Device.get().isTablet
                        ? MediaQuery.of(context).size.width * 0.01
                        : MediaQuery.of(context).size.width * 0.02),
              ),
              Row(
                children: [
                  Text(
                    discountPer == 0.0
                        ? "${discountValue.toStringAsPrecision(3)} $appCurrency2"
                        : "$discountPer %",
                    style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontSize: Device.get().isTablet
                          ? MediaQuery.of(context).size.width * 0.01
                          : MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Visibility(
                    visible: discountValue != 0.0 ? true : false,
                    child: Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _deliverySection() {
    return InkWell(
        onTap: () {
          setState(() {
            // selectedCashMode = !selectedCashMode;
            // if (selectedCustomer == null) {
            if (deliveryAmount == 0.0) {
              _handleDeliveryPopup();
            } else {
              deliveryAmount = 0.0;
              _configureTaxAndTotal(widget.orderList);
            }
            // }
          });
        },
        child: Container(
          // height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
              // color: MAIN_COLOR.withOpacity(0.1),
              // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.5)),
              color: Colors.redAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery",
                style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR,
                    fontSize: Device.get().isTablet
                        ? MediaQuery.of(context).size.width * 0.01
                        : MediaQuery.of(context).size.width * 0.02),
              ),
              Row(
                children: [
                  Text(
                    deliveryAmount != 0.0
                        ? "${deliveryAmount.toStringAsPrecision(3)} $appCurrency2"
                        : "0.00 $appCurrency2",
                    style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontSize: Device.get().isTablet
                          ? MediaQuery.of(context).size.width * 0.01
                          : MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Visibility(
                    visible: deliveryAmount != 0.0 ? true : false,
                    child: Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ));
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
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.02,
              ),
            ),
            Text(
              amount,
              style: getTextStyle(
                fontWeight: FontWeight.w600,
                color: isDiscount ? RED_COLOR : BLACK_COLOR,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.02,
              ),
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
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.02,
              ),
            ),
            Text(
              amount,
              style: getTextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.02,
              ),
            ),
          ],
        ),
      );

  Widget _DineModeSection() {
    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: _dineOption(TAKEAWAY_ICON, "Delivery", 0),
          ),
          const SizedBox(width: 20), // Add space between buttons
          Expanded(
            flex: 1,
            child: _dineOption(TAKEAWAY_ICON, "Take Away", 1),
          ),
          const SizedBox(width: 20), // Add space between buttons
          Visibility(
            visible: false,
            child: Expanded(
              flex: 1,
              child: _dineOption(DINEIN_ICON, "Dine-In", 2),
            ),
          ),
        ],
      ),
    );
  }

  _customerOption(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          // selectedCashMode = !selectedCashMode;
          if (selectedCustomer == null) {
            // _handleCustomerPopup();
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer:",
              style: getTextStyle(
                fontWeight: FontWeight.w300,
                color: BLACK_COLOR,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            Text(
              title,
              style: getTextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tableOption(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          // selectedCashMode = !selectedCashMode;
          // if (selectedCustomer == null) {
          _handleTablePopup();
          // }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.only(top: 6, left: 8, right: 8, bottom: 6),
        // Padding(
        //   padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Table No.:",
              style: getTextStyle(
                fontWeight: FontWeight.w300,
                color: BLACK_COLOR,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            Text(
              title,
              style: getTextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _locationOption(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          // selectedCashMode = !selectedCashMode;
          // if (selectedCustomer == null) {
          _handleLocationPopup();
          // }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.only(top: 6, left: 8, right: 8, bottom: 6),
        // Padding(
        //   padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location:",
              style: getTextStyle(
                fontWeight: FontWeight.w300,
                color: BLACK_COLOR,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            Text(
              title,
              style: getTextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dineOption(String dineIcon, String title, int isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedDineMode = isSelected;
        });
      },
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border.all(
        //         color: selectedDineMode == 0 ? Colors.black : MAIN_COLOR,
        //         width: 0.5),
        //     color: selectedDineMode == 0 ? Colors.white : MAIN_COLOR.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(8)),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedDineMode == isSelected ? MAIN_COLOR : Colors.black,
            width: 0.5,
          ),
          color: selectedDineMode == isSelected
              ? MAIN_COLOR.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: paddingXY(x: 10, y: 6),
        child: Row(
          children: [
            Image.asset(dineIcon, height: Device.get().isTablet ? 35 : 25),
            Device.get().isTablet ? widthSpacer(10) : widthSpacer(8),
            Text(
              title,
              style: getTextStyle(
                fontSize: Device.get().isTablet
                    ? MEDIUM_FONT_SIZE
                    : MediaQuery.of(context).size.width * 0.02,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _selectedCustomerSection() {
    //log('Selected customer from parent widget :: ${widget.customer}');
    selectedCustomer = widget.customer;
    return selectedCustomer != null
        ? InkWell(
            //   onTap: () => _handleCustomerPopup(),
            child: CustomerTile(
              isCheckBoxEnabled: false,
              isDeleteButtonEnabled: false,
              customer: selectedCustomer,
              isHighlighted: true,
              isSubtitle: true,
              isNumVisible: false,
            ),
          )
        : Container();
  }

  /* void _calculateOrderAmount() {
    double amount = 0;
    for (var item in currentCart!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    currentCart!.orderAmount = amount;
  }*/

  void _showOrderPlacedSuccessPopup() async {
    var response = await Get.defaultDialog(
      barrierDismissible: true,
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SaleSuccessfulPopup(
        order_no: "",
        amount: "0.0",
        items: 0,
        orderList: widget.orderList,
      ),
    );

    // _printReceipt("");

    if (response == "home") {
      selectedCustomer = null;
      widget.onNewOrder();
    } else if (response == "print_receipt") {
      selectedCustomer = null;
      widget.onNewOrder();
    } else if (response == "new_order") {
      selectedCustomer = null;
      widget.onNewOrder();
    }
  }

  Future<bool> _placeOrderHandler() async {
    DateTime currentDateTime = DateTime.now();
    String date =
        DateFormat('EEEE d, LLLL y').format(currentDateTime).toString();
    log('Date : $date');
    String time = DateFormat().add_jm().format(currentDateTime).toString();
    // log('Time : $time');
    String orderId = await Helper.getOrderId();
    // log('Order No : $orderId');

    double totalAmount = Helper().getTotal(currentCart!.items);
    HubManager manager = await DbHubManager().getManager() as HubManager;
    SaleOrder saleOrder = SaleOrder(
        id: orderId,
        orderAmount: totalAmount,
        date: date,
        time: time,
        customer: widget.customer!,
        manager: Helper.hubManager!,
        items: currentCart!.items,
        transactionId: '',
        paymentMethod: "Cash",
        //TODO:: Need to check when payment gateway is implemented
        paymentStatus: "Paid",
        transactionSynced: false,
        parkOrderId:
            "${currentCart!.transactionDateTime.millisecondsSinceEpoch}",
        tracsactionDateTime: currentDateTime);

    debugPrint("Inside:Create OrderApi");

    CreateOrderService().createOrder(saleOrder).then((value) {
      if (value.status!) {
        // print("create order response::::YYYYY");
        SaleOrder order = saleOrder;
        order.transactionSynced = true;
        order.id = value.message;

        DbSaleOrder()
            .createOrder(order)
            .then((value) => debugPrint('order sync and saved to db'));
      } else {
        DbSaleOrder()
            .createOrder(saleOrder)
            .then((value) => debugPrint('order saved to db'));
      }
    }).whenComplete(() {
      DbParkedOrder().deleteOrder(currentCart!);
    });

    return true;
  }

  void _prepareCart() {
    if (isOrderProcessed) {
      return;
    }
    if (widget.orderList.isNotEmpty) {
      currentCart = ParkOrder(
        id: "0",
        date: Helper.getCurrentDate(),
        time: Helper.getCurrentTime(),
        customer: selectedCustomer!,
        manager: Helper.hubManager!,
        items: widget.orderList,
        orderAmount: totalAmount,
        transactionDateTime: DateTime.now(),
      );
      //_calculateOrderAmount();
      DbParkedOrder().saveOrder(currentCart!);
      Helper.activeParkedOrder = null;
    } else {
      selectedCustomer = null;
      customerName = 'Walk-in';
    }
  }

  Future<void> getParkedOrders() async {
    orderFromLocalDB = await DbParkedOrder().getOrders();

    parkedOrders = orderFromLocalDB.reversed.toList();
    fetchingData = false;
    setState(() {});
  }

  //TODO:: Siddhant - Need to correct the tax calculation logic here.
  _configureTaxAndTotal(List<OrderItem> items) {
    totalAmount = 0.0;
    subTotalAmount = 0.0;
    taxAmount = 0.0;
    totalItems = 0;
    taxPercentage = 0;
    double subTotalDisplay = 0.0;
    for (OrderItem item in items) {
      taxPercentage += item.tax!;
      subTotalAmount = subTotalAmount + (item.price * item.orderedQuantity);

      // taxAmount += (subTotalAmount * taxPercentage) / 100;
      taxAmount = _calculateVatProduct(item.price,item.tax,taxAmount,item.orderedQuantity) - discountValue; //Vat Calculation
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          if (attribute.qty != 0) {
            subTotalAmount = subTotalAmount + attribute.rate * attribute.qty;
          }
        }
        // }
        // }
      }
    }

    // Apply discount to subtotal once
    // subTotalAmount -= discountValue;

    if (!isTax) {
      subTotalAmount -= taxAmount;
    }

    // if(discountValue != 0.0) {
    //   log("DiscountTotal: ${discountValue}");
    //   subTotalDisplay = subTotalAmount - discountValue;
    //   subTotalAmount = subTotalDisplay;
    //   log("Subtotal: ${subTotalAmount - discountValue}");
    //   log("Subtotal: ${subTotalDisplay.toStringAsFixed(3)}");
    //   // log("SubTotal: ${subTotalAfterDiscount}");
    // }

    totalAmount = subTotalAmount + taxAmount ;



    log("Total: ${totalAmount}");

    setState(() {});
  }


  double _calculateVatProduct(double price,double taxPer,double taxAmount,double qty){
    double num1 = 100 + taxPer;

    return (taxAmount+((price*qty))*taxPer/num1);
  }

  // double _calculateDiscount(double cartTotal,double discount){
  //   double num1 = cartTotal * 10;
  //
  //   return (taxAmount+((price*qty))*taxPer/num1);
  // }
}
