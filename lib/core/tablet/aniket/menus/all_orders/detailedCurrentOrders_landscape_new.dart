import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/helper.dart' show Helper;
import '../../../../service/api_orders/api/api_order_service.dart';
import '../../../../service/api_sales/model/orderDetailsModel.dart';

class DetailCurrentOrdersLandscapeNew extends StatefulWidget {
  final String orderNo;
  final int orderId;
  final String customerName;
  final String orderType;

  final double sub_total, discount, tax, total, cash, due;

  const DetailCurrentOrdersLandscapeNew({
    Key? key,
    required this.orderNo,
    required this.orderId,
    required this.customerName,
    required this.orderType,
    required this.sub_total,
    required this.discount,
    required this.tax,
    required this.total,
    required this.cash,
    required this.due,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailCurrentOrderState();
}

class DetailCurrentOrderState extends State<DetailCurrentOrdersLandscapeNew> {
  OrderDetailsModel? orderDetailsModel;
  late List<OrderDtl> listOrders = [];
  double sub_total = 0,
      discount = 0,
      tax = 0,
      total = 0,
      tender_amount = 0,
      change_due = 0;

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? _selectedEmployeeName;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String? branch_crno;

  @override
  void initState() {
    super.initState();
    getDetailsFromApis();
    _getDetails();
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    setState(() {
      _selectedEmployeeName = manager.name;
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

  getDetailsFromApis() async {


    orderDetailsModel = await OrdersApiService().getOrderDetailsById(
        OrderType: widget.orderType, id: '${widget.orderId}');

    discount = orderDetailsModel!.orderList![0].discount!;
    tender_amount = orderDetailsModel!.orderList![0].tenderAmount == null
        ? 0.000
        : orderDetailsModel!.orderList![0].tenderAmount!;
    total = orderDetailsModel!.orderList![0].netAmount!;
    change_due = orderDetailsModel!.orderList![0].balanceAmt!;
    // for (OrderDtl item in orderDetailsModel!.orderList![0].orderDtl!) {
    sub_total += orderDetailsModel!.orderList![0].subTotal!;
    tax += orderDetailsModel!.orderList![0].taxAmount!;
    // }

    // due = orderDetailsModel!.orderList[0].netAmount!;

    listOrders = orderDetailsModel!.orderList![0].orderDtl!;
    // print('orderDetailssss');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Order Details",
          style: getTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: LARGE_PLUS_FONT_SIZE,
              color: WHITE_COLOR),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: MAIN_COLOR,
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    // width: 500,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(9)),
                    child: Column(children: [
                      Text(
                        'Customer: ${widget.customerName} ',
                        style: getTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Device
                                .get()
                                .isTablet
                                ? LARGE_PLUS_FONT_SIZE
                                : MEDIUM_FONT_SIZE,
                            color: BLACK_COLOR),
                      ),
                      if (orderDetailsModel?.orderList != null &&
                          orderDetailsModel!.orderList!.isNotEmpty)
                        if (orderDetailsModel?.orderList?[0].tableNo == null)
                          Text(
                            '${orderDetailsModel?.orderList?[0].ordNo} ',
                            style: getTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device
                                    .get()
                                    .isTablet
                                    ? LARGE_PLUS_FONT_SIZE
                                    : MEDIUM_FONT_SIZE,
                                color: BLACK_COLOR),
                          )
                        else
                          Text(
                            '${orderDetailsModel?.orderList?[0]
                                .tableNo} - ${orderDetailsModel?.orderList?[0]
                                .ordNo} ',
                            style: getTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Device
                                    .get()
                                    .isTablet
                                    ? LARGE_PLUS_FONT_SIZE
                                    : MEDIUM_FONT_SIZE,
                                color: BLACK_COLOR),
                          )
                    ])),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: getOrdersList(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Sub Total',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          'Discount',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          'VAT',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          '${sub_total ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          '${discount ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          '${tax ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: Device
                      .get()
                      .isTablet ? 3 : 1,
                  width: double.maxFinite,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${total ?? 0.000} $appCurrency2',
                      style: getTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Device
                              .get()
                              .isTablet
                              ? LARGE_PLUS_FONT_SIZE
                              : MEDIUM_FONT_SIZE),
                    )
                  ],
                ),
                Container(
                  height: Device
                      .get()
                      .isTablet ? 3 : 1,
                  width: double.maxFinite,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Cash',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          'Change Due',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          '${tender_amount ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                        Text(
                          '${change_due ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Device
                                  .get()
                                  .isTablet
                                  ? LARGE_PLUS_FONT_SIZE
                                  : MEDIUM_FONT_SIZE),
                        ),
                      ],
                    ),

                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle cancel order
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        "Cancel Order",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // space between buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle duplicate receipt print
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
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  getOrdersList() {
    int sr_no = 1;

    setState(() {});
    return FutureBuilder<OrderDetailsModel?>(
      future: OrdersApiService().getOrderDetailsById(
          OrderType: widget.orderType, id: '${widget.orderId}'),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          // until data is fetched, show loader
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          orderDetailsModel = snapshot.data;
          // sub_total = orderDetailsModel!.orderList![0].subTotal!;
          // discount = orderDetailsModel!.orderList![0].discount!;
          // tax = orderDetailsModel!.orderList![0].taxAmount!;
          // total = orderDetailsModel!.orderList![0].netAmount!;
          // cash = orderDetailsModel!.orderList![0].netAmount!;
          listOrders = orderDetailsModel!.orderList![0].orderDtl!;

          // print(
          //     'orderDetailsModel!.orderList?: ${orderDetailsModel!.orderList?.toString()}');
          // orderList = currOrders.orderList != null?
          return Device
              .get()
              .isTablet ? Container(
            width: double.maxFinite,
            child: _getTable(sr_no))
                : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _getTable(sr_no),

          );
        } else {
          return const Center(
            child: Text("Loading..."),
          );
        }
      },
    );
  }

  Widget _getTable(int sr_no) {
    return DataTable(
      columnSpacing: 10,
      showCheckboxColumn: false,
      border: const TableBorder(
          bottom: BorderSide(color: Colors.grey, width: 1.0)),
      headingRowHeight: 80,
      dataRowHeight: 100,
      dataTextStyle:
      // const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      getTextStyle(
          fontSize: Device
              .get()
              .isTablet
              ? LARGE_PLUS_FONT_SIZE
              : MEDIUM_MINUS_FONT_SIZE,
          fontWeight: FontWeight.bold),
      headingTextStyle: TextStyle(
          fontSize: Device
              .get()
              .isTablet
              ? LARGE_PLUS_FONT_SIZE
              : MEDIUM_FONT_SIZE,
          fontWeight: FontWeight.bold,
          color: Colors.white),
      headingRowColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return Colors.green;
        }
        return MAIN_COLOR;
      }),
      dataRowColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return green, otherwise blue
        if (states.contains(MaterialState.pressed)) {
          return Colors.green;
        }
        return Colors.grey.shade300;
      }),
      columns: const [
        DataColumn(
          label: Text('Sr.No'),
        ),
        DataColumn(
          label: Text('Description'),
        ),
        DataColumn(
          label: Text('Qty'),
        ),
        DataColumn(
          label: Text('Price'),
        ),
        DataColumn(
          label: Text('total'),
        ),
      ],
      rows:
      listOrders // Loops through dataColumnText, each iteration assigning the value to element
          .map(
        ((element) =>
            DataRow(
              cells: <DataCell>[
                DataCell(Text(
                    sr_no == 0 ? '${sr_no++}' : '${sr_no++}')),
                // DataCell(Text('${element.description}')),
                DataCell(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: Device
                            .get()
                            .isTablet
                            ? 300
                            : 100), // Adjust width as needed
                    child: Text(
                      '${element.description}',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                DataCell(Text('${element.qty}')),
                // DataCell(Text('${element.subTotal} BHD')),
                // DataCell(Text('${element.rate} BHD')),
                DataCell(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: Device
                            .get()
                            .isTablet
                            ? 300
                            : 50), // Adjust width as needed
                    child: Text(
                      '${element.subTotal} BD',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: Device
                            .get()
                            .isTablet
                            ? 300
                            : 50), // Adjust width as needed
                    child: Text(
                      '${element.rate} BD',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            )),
      )
          .toList(),
    );
  }

  Future<void> _printReceipt(String msg) async {
    print("_printReceipt");
    if (selectedPrinter == "IP Printer") {
      bool printStatus = await Helper().printProductionIPDuplicateInvoice(
          context,
          printerIP!,
          orderDetailsModel!.orderList![0].orderDtl,
          total,
          tax,
          discount,
          orderDetailsModel!.orderList![0].ordNo,
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
        Helper.showToastSuccess(
            "IP ${printerIP!} Printing successful", context);
      } else {
        Helper.showToastFail("IP ${printerIP!} Printing Failed", context);
      }
    } else {
      // await SunmiPrinter.bindingPrinter();

      bool printStatus = await Helper().printProductionDuplicateInternalSunmiInvoice(
          context,
          orderDetailsModel!.orderList![0].orderDtl,
          total,
          tax,
          discount,
          orderDetailsModel!.orderList![0].deliveryFees,
          orderDetailsModel!.orderList![0].ordNo,
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
}
