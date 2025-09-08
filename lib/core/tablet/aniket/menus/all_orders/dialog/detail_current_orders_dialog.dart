import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/tablet/widget/cancel_order_popup.dart';
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
import '../../../../../../configs/theme_config.dart';
import '../../../../../../database/db_utils/db_constants.dart';
import '../../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../../database/db_utils/db_preferences.dart';
import '../../../../../../database/models/hub_manager.dart';
import '../../../../../../utils copy/ui_utils/padding_margin.dart';
import '../../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../service/api_orders/api/api_order_service.dart';
import '../../../../../service/api_sales/model/orderDetailsModel.dart';

class DetailCurrentOrdersDialogContent extends StatefulWidget {
  final String orderNo;
  final int orderId;
  final int status;
  final String customerName;
  final String orderType;
  final double sub_total;
  final double discount;
  final double tax;
  final double total;
  final double cash;
  final double due;
  final VoidCallback? onOrderCancelled;

  const DetailCurrentOrdersDialogContent({
    super.key,
    required this.orderNo,
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.orderType,
    required this.sub_total,
    required this.discount,
    required this.tax,
    required this.total,
    required this.cash,
    required this.due,
    this.onOrderCancelled,
  });

  @override
  State<DetailCurrentOrdersDialogContent> createState() =>
      _DetailCurrentOrdersDialogContentState();
}

class _DetailCurrentOrdersDialogContentState
    extends State<DetailCurrentOrdersDialogContent> {
  OrderDetailsModel? orderDetailsModel;
  List<OrderDtl> listOrders = [];

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String? branch_crno;
  String? _selectedEmployeeName;

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();
    _selectedEmployeeName = manager.name;
    setState(() {
      printerIP = prefs.getString('printer_ip') ?? "";
      selectedPrinter = prefs.getString('printer_type') ?? "No Printer";
      branch_name = prefs.getString(BranchName) ?? "";
      branch_add1 = prefs.getString(BranchAdd1) ?? "";
      branch_add2 = prefs.getString(BranchAdd2) ?? "";
      branch_add3 = prefs.getString(BranchAdd3) ?? "";
      branch_phone = prefs.getString(BranchPhone) ?? "";
      branch_vat = prefs.getString(BranchVAT) ?? "";
      branch_crno = prefs.getString(BranchCRNo) ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _getDetails(); // ✅ Call API here, only once
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header with title and close button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: MAIN_COLOR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Balancer for IconButton
                  const Expanded(
                    child: Text(
                      'Order Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Scrollable content with padding
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Padding only for content
                  child: Column(
                    children: [
                      const Divider(),
                      _infoRow("Order No", widget.orderNo),
                      // _infoRow("Order ID", widget.orderId.toString()),
                      _infoRow("Customer", widget.customerName),
                      _infoRow("Order Type", widget.orderType),
                      const SizedBox(height: 16),
                      const Divider(),
                      FutureBuilder<OrderDetailsModel?>(
                        future: OrdersApiService().getOrderDetailsById(
                            OrderType: widget.orderType,
                            id: '${widget.orderId}'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            orderDetailsModel = snapshot.data;
                            listOrders = snapshot.data!.orderList![0].orderDtl!;

                            return _buildOrderTable(listOrders);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("Failed to load order items"),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      _subtotalSection(
                          "Subtotal", widget.sub_total.toStringAsFixed(2)),
                      _subtotalSection(
                          "Discount", "-${widget.discount.toStringAsFixed(2)}",
                          isDiscount: true),
                      _subtotalSection("Tax", widget.tax.toStringAsFixed(2)),
                      _subtotalSection("Total", widget.total.toStringAsFixed(2),
                          isTotal: true),
                      _subtotalSection("Cash", widget.cash.toStringAsFixed(2)),
                      _subtotalSection("Due", widget.due.toStringAsFixed(2)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.status != 5) // 👈 Hide cancel order if status == 5
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Cancel order logic
                        final result = await _handleCancelOrderPopup(context, widget.orderId);
                        print("button click status $result");
                        if (result == true) {
                          // 🔥 Forward result to parent
                          Navigator.pop(context);
                          widget.onOrderCancelled?.call(); // 👈 parent ko bolna list reload kar
                          // Get.back(result: true);

                        }
                      },
                      icon: const Icon(Icons.cancel, color: Colors.black),
                      label: const Text(
                        "Cancel Order",
                        style: TextStyle(color: MAIN_COLOR),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Button fill
                        foregroundColor: Colors.black,
                        // Ripple & text color (for safety)
                        side: BorderSide(color: MAIN_COLOR, width: 2),
                        // Border
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (widget.status != 5) const SizedBox(width: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      // Print duplicate receipt logic
                      _printReceipt("");
                    },
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text(
                      "Duplicate Receipt",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MAIN_COLOR,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subtotalSection(title, amount,
          {bool isDiscount = false, bool isTotal = false}) =>
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // Align the whole row to right
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.2, // Adjust width as needed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Space between label and amount
                children: [
                  Text(
                    "$title:",
                    textAlign: TextAlign.left,
                    style: getTextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDiscount ? RED_COLOR : BLACK_COLOR,
                      fontSize: isTotal
                          ? MediaQuery.of(context).size.width * 0.02
                          : MediaQuery.of(context).size.width * 0.0150,
                    ),
                  ),
                  Text(
                    amount,
                    textAlign: TextAlign.right,
                    style: getTextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDiscount ? RED_COLOR : BLACK_COLOR,
                      fontSize: isTotal
                          ? MediaQuery.of(context).size.width * 0.02
                          : MediaQuery.of(context).size.width * 0.0150,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _infoRow(String label, String value, {bool alignRight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.12, // Fixed width for label
            child: Text(
              '$label:',
              textAlign: alignRight ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.0150,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.0150,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTable(List<OrderDtl> orders) {
    int srNo = 1;
    return Container(
      width: MediaQuery.of(context).size.width, // Adjusted to your dialog width
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(MAIN_COLOR),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        columnSpacing: 16.0,
        // Reduced to fit better without scrolling
        columns: const [
          DataColumn(
              label: Text(
            'Sr.No',
            style: TextStyle(fontSize: LARGE_MINUS_FONT_SIZE),
          )),
          DataColumn(
              label: Text(
            'Description',
            style: TextStyle(fontSize: LARGE_MINUS_FONT_SIZE),
          )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.start,
              label: Text(
                'Qty',
                style: TextStyle(fontSize: LARGE_MINUS_FONT_SIZE),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.start,
              label: Text(
                'Price',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: LARGE_MINUS_FONT_SIZE),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.start,
              label: Text(
                'Total',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: LARGE_MINUS_FONT_SIZE),
              )),
        ],
        rows: orders.map((e) {
          return DataRow(cells: [
            DataCell(Text(
              '${srNo++}',
              style: TextStyle(fontSize: MY_ACCOUNT_ICON_PADDING_RIGHT),
            )),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360, // Wider cell for description
                ),
                child: Text(
                  '${e.description}',
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: MY_ACCOUNT_ICON_PADDING_RIGHT),
                ),
              ),
            ),
            DataCell(ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100, // Wider cell for description
                ),
                child: Text(
                  '${e.qty?.toInt()}',
                  style: TextStyle(fontSize: MY_ACCOUNT_ICON_PADDING_RIGHT),
                ))),
            // Remove decimal
            DataCell(ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100, // Wider cell for description
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '${e.subTotal?.toStringAsFixed(2)} BD',
                  style: TextStyle(fontSize: MY_ACCOUNT_ICON_PADDING_RIGHT),
                ))),
            DataCell(ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100, // Wider cell for description
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '${e.rate?.toStringAsFixed(2)} BD',
                  style: TextStyle(fontSize: MY_ACCOUNT_ICON_PADDING_RIGHT),
                ))),
          ]);
        }).toList(),
      ),
    );
  }

  Future<void> _printReceipt(String msg) async {
    print("_printReceipt");
    if (selectedPrinter == "IP Printer") {
      bool printStatus = await Helper().printProductionIPDuplicateInvoice(
          context,
          printerIP!,
          orderDetailsModel!.orderList![0].orderDtl,
          orderDetailsModel!.orderList![0].netAmount,
          orderDetailsModel!.orderList![0].taxAmount,
          orderDetailsModel!.orderList![0].discount,
          msg,
          branch_name,
          branch_add1,
          branch_add2,
          branch_add3,
          branch_phone,
          branch_vat,
          branch_crno,
          orderDetailsModel!.orderList![0].tableNo == null ? "" : orderDetailsModel!.orderList![0].tableNo,
          "Server Name");
      if (printStatus) {
        Helper.showToastSuccess(
            "IP ${printerIP!} Printing successful", context);
      } else {
        Helper.showToastFail("IP ${printerIP!} Printing Failed", context);
      }
    } else {
      // await SunmiPrinter.bindingPrinter();

      bool printStatus = await Helper()
          .printProductionDuplicateInternalSunmiInvoice(
              context,
              orderDetailsModel!.orderList![0].orderDtl,
              orderDetailsModel!.orderList![0].netAmount,
              orderDetailsModel!.orderList![0].taxAmount,
              orderDetailsModel!.orderList![0].discount,
          orderDetailsModel!.orderList![0].deliveryFees,
              msg,
              branch_name,
              branch_add1,
              branch_add2,
              branch_add3,
              branch_phone,
              branch_vat,
          branch_crno,
          orderDetailsModel!.orderList![0].tableNo == null ? "" : orderDetailsModel!.orderList![0].tableNo,
          _selectedEmployeeName);
      if (printStatus) {
        Helper.showToastSuccess("Internal Printing successful", context);
      } else {
        Helper.showToastFail("Internal Printing Failed", context);
      }
    }
  }

  /*_handleCancelOrderPopup() async {
    int orderId = widget.orderId;
    final result = await Get.defaultDialog(
      backgroundColor: Colors.transparent,

      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 10, y: 10),
      // custom: Container(),
      content: CancelOrderPopup(
        orderId: orderId,
        // customer: selectedTable,
      ),
    );

    if (result == true) {
      Navigator.pop(context, true); // 🔥 Yeh parent dialog ko result dega
    }

    // setState(() {});
  }*/
  Future<bool?> _handleCancelOrderPopup(BuildContext context, int orderId) async {
    final result = await Get.defaultDialog<bool>(
      backgroundColor: Colors.transparent,
      title: "",
      titlePadding: const EdgeInsets.all(10),
      content: CancelOrderPopup(orderId: orderId),
    );

    return result; // 🔥 yahan sirf return kar, dobara Get.back mat maar
  }
}
