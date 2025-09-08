import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/core/service/api_orders/api/api_order_service.dart';
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../service/api_orders/model/CurrentOrdersModel.dart';
import 'detailedCurrentOrders_landscape.dart';
import 'detailedCurrentOrders_landscape_new.dart';
import 'dialog/showOrderDetailsDialog.dart';

class CurrentOrdersLandscapeNew extends StatefulWidget {
  const CurrentOrdersLandscapeNew({super.key});

  @override
  State<CurrentOrdersLandscapeNew> createState() => _CurrentOrdersState();
// TODO: implement createState
}

class _CurrentOrdersState extends State<CurrentOrdersLandscapeNew> {
  // late Future<CurrentOrdersModel> currOrders;

  int _currentSegment = 1;
  var _paidStatus = false;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedTypeId = "";

  @override
  void initState() {
    super.initState();
    List<OrderList> orderList = [];

    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        // backgroundColor: const Color.fromRGBO(139, 143, 124, 40.0),
        title: Text(
          'Orders',
          style: getTextStyle(
              fontSize: Device.get().isTablet ? LARGE_PLUS_FONT_SIZE : 14.0,
              color: BLACK_COLOR),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomSlidingSegmentedControl<int>(
              isStretch: true,
              // height: 50,
              isShowDivider: true,
              initialValue: 1,
              children: {
                1: Text(
                  'All',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Device.get().isTablet
                          ? LARGE_PLUS_FONT_SIZE
                          : SMALL_PLUS_FONT_SIZE,
                      color: BLACK_COLOR),
                ),
                2: Text(
                  'Take Away',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Device.get().isTablet
                          ? LARGE_PLUS_FONT_SIZE
                          : SMALL_PLUS_FONT_SIZE,
                      color: BLACK_COLOR),
                ),
                3: Text(
                  'Stores',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Device.get().isTablet
                          ? LARGE_PLUS_FONT_SIZE
                          : SMALL_PLUS_FONT_SIZE,
                      color: BLACK_COLOR),
                ),
                4: Text(
                  'Open',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Device.get().isTablet
                          ? LARGE_PLUS_FONT_SIZE
                          : SMALL_PLUS_FONT_SIZE,
                      color: BLACK_COLOR),
                ),
                5: Text(
                  'Close',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Device.get().isTablet
                          ? LARGE_PLUS_FONT_SIZE
                          : SMALL_PLUS_FONT_SIZE,
                      color: BLACK_COLOR),
                ),
              },
              decoration: BoxDecoration(
                color: CupertinoColors.opaqueSeparator,
                borderRadius: BorderRadius.circular(8),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInToLinear,
              onValueChanged: (v) {
                setState(() {
                  _currentSegment = v;
                });
              },
            ),
          ),
          Expanded(
              // Wrap in Expanded so it takes up remaining space
              child: getOrdersList(_currentSegment))
        ],
      ),
    );
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });
  }

  /* getOrdersList(int indTapped) {
    // setState(() {});
    return FutureBuilder<CurrentOrdersModel?>(
      future: OrdersApiService().getAllOrders(indTapped, _selectedBranchId,
          _selectedEmployeeId, _selectedCounterId, (-1).toString()),
      builder: (context, snapshot) {
        print("getOrdersList data: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          // until data is fetched, show loader
          return Center(
              child: Container(
                  height: 100,
                  width: 100,
                  child: const CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          CurrentOrdersModel? currOrders = snapshot.data;
          print(
              'currOrders!.orderList?.length: ${currOrders!.orderList?.length.toString()}');
          // orderList = currOrders.orderList != null?
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.maxFinite,
              child: currOrders.status != 0 ?
              DataTable(
                  showCheckboxColumn: false,
                  border: const TableBorder(
                      bottom: BorderSide(color: Colors.grey, width: 1.0)),
                  headingRowHeight: 35,
                  dataRowHeight: 100,
                  dataTextStyle:
                      // const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      getTextStyle(fontSize: LARGE_MINUS20_FONT_SIZE),
                  headingTextStyle: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: LARGE_MINUS20_FONT_SIZE,
                      color: WHITE_COLOR),
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
                    return Colors.grey.shade200;
                  }),
                  columns: const [
                    DataColumn(
                      label: Text('Order No.'),
                    ),
                    DataColumn(
                      label: Text('Customer'),
                    ),
                    DataColumn(
                      label: Text('Date/Time'),
                    ),
                    DataColumn(
                      label: Text('Amount'),
                    ),
                    DataColumn(
                      label: Text('Delivery'),
                    ),
                    DataColumn(
                      label: Text('Order'),
                    ),
                    DataColumn(
                      label: Text('Status'),
                    ),
                  ],
                  rows: currOrders
                          .orderList! // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  onSelectChanged: (selected) {
                                    if (selected!) {
                                      // print('row-selected: ${element.id}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailCurrentOrdersLandscape(
                                                      orderNo: element.orderNo!,
                                                      orderId: element.id!,
                                                      orderType:
                                                          element.orderType!,
                                                      sub_total:
                                                          element.subTotal!,
                                                      discount:
                                                          element.discount!,
                                                      tax: element.taxAmount!,
                                                      total: element.netAmount!,
                                                      cash: element.netAmount!,
                                                      due: 0.0,
                                                      customerName:
                                                          element.customer!)));
                                      // _openOrderDetailDialog(element.id!,
                                      //     element.orderNo!, element.customer!);
                                    }
                                  },
                                  cells: <DataCell>[
                                    DataCell(Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                            currOrders.orderList!.isNotEmpty
                                                ? '${element.orderNo}'
                                                : "No data",
                                            style: getTextStyle(
                                                fontSize:
                                                    LARGE_MINUS_FONT_SIZE,
                                                color: BLACK_COLOR),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            if (element.payStatus == 'Not Paid')
                                              Container(
                                                width: 90,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Text(
                                                  ' ${element.payStatus} ',
                                                  style: getTextStyle(
                                                    color: WHITE_COLOR,
                                                    fontSize:
                                                        MEDIUM_PLUS_FONT_SIZE,
                                                  ),
                                                ),
                                              ),
                                            if (element.payStatus == 'Paid')
                                              Container(
                                                width: 50,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Text(
                                                  ' ${element.payStatus} ',
                                                  style: getTextStyle(
                                                    color: WHITE_COLOR,
                                                    fontSize:
                                                        MEDIUM_PLUS_FONT_SIZE,
                                                  ),
                                                ),
                                              ),
                                            hightSpacer5,

                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                ' ${element.customer} ',
                                                style: getTextStyle(
                                                  color: WHITE_COLOR,
                                                  fontSize:
                                                      MEDIUM_PLUS_FONT_SIZE,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    DataCell(Text(
                                      '${element.customer}',
                                    )),
                                    DataCell(Text('${element.orderDate}')),
                                    DataCell(Text(
                                        currOrders.orderList!.isNotEmpty
                                            ? '${element.netAmount} BD'
                                            : 'Data not found')),
                                    DataCell(Text('${element.delivery}')),
                                    DataCell(Text('${element.orderType}')),
                                    DataCell(
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          softWrap: true,
                                          maxLines: 1,
                                          ' ${element.statusText.toString()} ',
                                          style: getTextStyle(
                                            color: WHITE_COLOR,
                                            fontSize:
                                            MEDIUM_PLUS_FONT_SIZE,
                                          ),
                                        ),
                                      )),
                                  ],
                                )),
                          )
                          .toList()) : Container(child: const Center(child:Text(
                  'Data not found'))),
            ),
          );
        } else {
          return const Center(
            child: Text("Loading..."),

          );
        }
      },
    );
  }*/
  getOrdersList(int indTapped) {
    // setState(() {});
    return FutureBuilder<CurrentOrdersModel?>(
      future: OrdersApiService().getAllOrders(indTapped, _selectedBranchId,
          _selectedEmployeeId, _selectedCounterId, (-1).toString()),
      builder: (context, snapshot) {
        print("getOrdersList data: ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loader while fetching
          return const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          // Handle API error case
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle case where no data is received at all
          return const Center(child: Text("No data available."));
        }

        CurrentOrdersModel? currOrders = snapshot.data;

        if (currOrders!.orderList == null || currOrders.orderList!.isEmpty) {
          // Show "No data found" when orderList is empty
          return const Center(child: Text("No orders found."));
        }

        // Display DataTable if there is data
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              showCheckboxColumn: false,
              border: const TableBorder(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
              ),
              headingRowHeight: 35,
              dataRowHeight: Device.get().isTablet ? 100 : 80,
              dataTextStyle: getTextStyle(
                  fontSize: Device.get().isTablet
                      ? LARGE_MINUS20_FONT_SIZE
                      : MEDIUM_FONT_SIZE),
              headingTextStyle: getTextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Device.get().isTablet
                    ? LARGE_MINUS20_FONT_SIZE
                    : MEDIUM_FONT_SIZE,
                color: WHITE_COLOR,
              ),
              headingRowColor: MaterialStateProperty.resolveWith((states) {
                return MAIN_COLOR;
              }),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                return Colors.grey.shade200;
              }),
              columns: [
                DataColumn(label: Text('Order No.')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Date/Time')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Delivery')),
                DataColumn(label: Text('Order')),
                DataColumn(label: Text('Status')),
              ],
              rows: currOrders.orderList!
                  .map((element) => DataRow(
                        onSelectChanged: (selected) async {
                          if (selected!) {
                            if (Device.get().isTablet) {
                              // showOrderDetailsDialog(
                              //   context,
                              //   orderNo: element.orderNo!,
                              //   orderId: element.id!,
                              //   status: element.status!,
                              //   orderType: element.orderType!,
                              //   subTotal: element.subTotal!,
                              //   discount: element.discount!,
                              //   tax: element.taxAmount!,
                              //   total: element.netAmount!,
                              //   cash: element.netAmount!,
                              //   due: 0.0,
                              //   customerName: element.customer!,
                              // );
                              await showOrderDetailsDialog(
                                context,
                                orderNo: element.orderNo!,
                                orderId: element.id!,
                                status: element.status!,
                                orderType: element.orderType!,
                                subTotal: element.subTotal!,
                                discount: element.discount!,
                                tax: element.taxAmount!,
                                total: element.netAmount!,
                                cash: element.netAmount!,
                                due: 0.0,
                                customerName: element.customer!,
                                onOrderCancelled: () {
                                  print("Cancel callback triggered ✅");
                                  setState(() {
                                    getOrdersList(_currentSegment);
                                  });
                                },
                              );

                              // if (result == true) {
                              //   print("Cancel hua ✅, list reload karte hain...");
                              //   setState(() {
                              //     getOrdersList(_currentSegment);
                              //   });
                              // }

                              setState(() {});
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailCurrentOrdersLandscapeNew(
                                            orderNo: element.orderNo!,
                                            orderId: element.id!,
                                            orderType: element.orderType!,
                                            sub_total: element.subTotal!,
                                            discount: element.discount!,
                                            tax: element.taxAmount!,
                                            total: element.netAmount!,
                                            cash: element.netAmount!,
                                            due: 0.0,
                                            customerName: element.customer!,
                                          )));
                            }
                          }
                        },
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: Device.get().isTablet
                                      ? 300
                                      : 80), // Adjust width as needed
                              child: Text(
                                '${element.orderNo}',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: Device.get().isTablet
                                      ? 300
                                      : 100), // Adjust width as needed
                              child: Text(
                                '${element.customer}',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: Device.get().isTablet
                                      ? 300
                                      : 100), // Adjust width as needed
                              child: Text(
                                '${element.orderDate}',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          // DataCell(Text('${element.orderNo}')),
                          // DataCell(Text('${element.customer}')),
                          // DataCell(Text('${element.orderDate}')),
                          DataCell(Text('${element.netAmount} BD')),
                          DataCell(Text(element.delivery ?? "N/A")),
                          DataCell(Text('${element.orderType}')),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              ' ${element.statusText} ',
                              style: getTextStyle(
                                color: WHITE_COLOR,
                                fontSize: Device.get().isTablet
                                    ? LARGE_PLUS_FONT_SIZE
                                    : 13.0,
                              ),
                            ),
                          )),
                        ],
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
