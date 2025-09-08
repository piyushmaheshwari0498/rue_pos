import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:nb_posx/utils%20copy/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../database/db_utils/db_constants.dart';
import '../../service/api_orders/api/api_order_service.dart';
import '../../service/api_sales/model/orderDetailsModel.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;

// ignore: must_be_immutable
class TableDineLandscapeNew extends StatefulWidget {
  // Customer? customer;
  final Function(String)? onTabSelected;

  TableDineLandscapeNew({Key? key, this.onTabSelected}) : super(key: key);

  @override
  State<TableDineLandscapeNew> createState() => _SelectTablePopupState();
}

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class _SelectTablePopupState extends State<TableDineLandscapeNew>
    with TickerProviderStateMixin {
  // late TextEditingController searchCtrl;
  // late TextEditingController _phoneCtrl;
  // Customer? customer;
  List<TbTable> tableList = [];

  List<tab.Table> list = [];
  int selectedTabIndex = 0;

  // List<Customer> filteredCustomer = [];
  List<TbTable> selectedSeats = [];

  // List<TableModel>? modelTable = [];

  late TabController controller;
  int totalTable = 0, freeTable = 0, busyTable = 0, _selectedIndex = 0;

  final int rows = 6;
  final int columns = 6;

  String _selectedBranchId = "";

  final double dotRadius = 18.0;

  @override
  void initState() {

    _fetchCustomers();

    updateTabs();

    super.initState();
  }

  void updateTabs() {
    try {
      controller = TabController(
        length: _tab.length,
        vsync: this,
      );

      setState(() {});
    } catch (on) {
      print(on); // TODO: rem
    }
  }

  final List<Tab> _tab = [];

  _fetchCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedBranchId = prefs.getString(BranchId) ?? '';
    TableCommanResponse data = await TableService.getTable(_selectedBranchId);
    list = data.data1!;
    tableList = data.data1![_selectedIndex].tbTable!;
    totalTable = data.tableCount!;
    freeTable = data.freeTable!;
    busyTable = data.busyTable!;
    // log(tableList.toString());

    for (var s in list) {
      _tab.add(Tab(text: '${s.floorNo}'));
    }

    controller = TabController(
      length: _tab.length,
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        _selectedIndex = controller.index;
        tableList = data.data1![_selectedIndex].tbTable!;
      });
      // print("Selected Index: " + controller.index.toString());
      // print("Selected Index: " + tableList.toString());
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        hightSpacer20,
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 30),
          child: Center(
            child: Text(
              "Table and Dine-in",
              style: getTextStyle(
                fontSize: Device.get().isTablet
                    ? MediaQuery.of(context).size.width * 0.01
                    : 20.0,
              ),
            ),
          ),
        ),
        TabBar(
          labelStyle: getTextStyle(
            fontSize: Device.get().isTablet
                ? MediaQuery.of(context).size.width * 0.01
                : 12.0,
          ),
          isScrollable: true,
          labelColor: Colors.black,
          controller: controller,
          tabs: _tab,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.lightBlue,
        ),

        // Use Expanded to prevent overflow
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: GridView.builder(
              itemCount: tableList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Device.get().isTablet ? columns : 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: LayoutBuilder(
                    builder: (context, box) {
                      return _tabData(
                          index, box.maxWidth, tableList[index].noofSeats!);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabData(
    int index,
    double tableSize,
    int seats,
  ) {
    final seat = tableList[index];
    final isSeatSelected = selectedSeats.contains(seat);
    final isSeatBooked = tableList[index].status == 1;
    return SizedBox(
      width: tableSize,
      height: tableSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle representing the table
          InkWell(
            onTap: () async {
              // setState(() async {
                if (isSeatBooked && tableList[index].directOrdId != 0) {
                  OrderDetailsModel orderDetailsModel = await OrdersApiService()
                      .getOrderDetailsById(
                          OrderType: 'Direct',
                          id: '${tableList[index].directOrdId}');

                  print(orderDetailsModel.orderList.toString());

                  // Store in Helper
                  Helper.activeTableOrder = orderDetailsModel;
                  Helper.activeOrderDtl = orderDetailsModel.orderList?[0].orderDtl;

                  // OR, optionally store more data
                  // Helper.activeTableOrder = {
                  //   "orderDetails": orderDetailsModel,
                  //   "tableNo": tableList[index].tableNo,
                  //   "orderId": tableList[index].directOrdId,
                  // };

                  // Now call callback to switch to New Order tab
                  widget.onTabSelected?.call("New Order");
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTableOrdersLandscape(
                              orderNo: tableList[index].directOrdNo.toString(),
                              orderId: tableList[index].directOrdId!.toInt(),
                              orderType: 'Direct',
                              sub_total: tableList[index].netAmount!.toDouble(),
                              discount: 0.0,
                              tax: 0.0,
                              total: tableList[index].netAmount!.toDouble(),
                              cash: 0,
                              due: 0.0,
                              customerName: "Walk-in Client")));*/
                } else {
                  Helper.showPopup(context, "Something wrong with Table Order");
                }
              // });
            },
            child:
                Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSeatBooked
                    ? RED_COLOR
                    : GREEN_COLOR, // Available seat color
              ),

              margin: MediaQuery.of(context).size.height <= 800
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(38),
              child: Center(
                  child: Column(
                children: [
                  // SvgPicture.asset(paymentIcon, height: 35),
                  Device.get().isTablet ? hightSpacer40 : hightSpacer5,
                  Center(
                      child: Text(
                    '${seat.noofSeats} Seats',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      color: WHITE_COLOR,
                      fontSize: Device.get().isTablet
                          ? MediaQuery.of(context).size.width * 0.015
                          : MediaQuery.of(context).size.height <= 800
                              ? MediaQuery.of(context).size.width * 0.02
                              : MediaQuery.of(context).size.width * 0.025,
                    ),
                  )),
                  // defaultTargetPlatform == TargetPlatform.iOS
                  //     ? hightSpacer5
                  //     : hightSpacer20,
                  Center(
                    child: Text(
                      '${seat.tableNo}',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: Device.get().isTablet
                            ? MediaQuery.of(context).size.width * 0.015
                            : MediaQuery.of(context).size.height <= 800
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.025,
                      ),
                    ),
                  ),
                  // defaultTargetPlatform == TargetPlatform.iOS
                  //     ? hightSpacer5
                  //     : hightSpacer20,
                  Center(
                    child: Text(
                      '${seat.balanceAmount} BD',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: Device.get().isTablet
                            ? MediaQuery.of(context).size.width * 0.015
                            : MediaQuery.of(context).size.height <= 800
                                ? MediaQuery.of(context).size.width * 0.02
                                : MediaQuery.of(context).size.width * 0.025,
                      ),
                    ),
                  ),
                  // hightSpacer30,
                ],
              )),
            ),
          ),
          // Red dots representing seats
          ..._buildSeatDots(seats, tableSize),
        ],
      ),
    );
  }

  List<Widget> _buildSeatDots(
    int seats,
    double tableSize,
  ) {
    // final double dotRadius = 5.0;
    List<Widget> dots = [];
    double angle = (2 * pi) / seats;
    double initialAngle = -pi / 5; // Starting from the top

    // Calculate positions for each seat
    int padding = 2;
    for (int i = 0; i < seats; i++) {
      double x = ((tableSize / 2 - padding) * cos(initialAngle + angle * i)) -
          (dotRadius - padding / 2) * cos(initialAngle + angle * i);
      double y = ((tableSize / 2 - padding) * sin(initialAngle + angle * i)) -
          (dotRadius - padding / 2) * sin(initialAngle + angle * i);

      print("$x,$y,$tableSize");
      dots.add(
        Positioned(
          top: tableSize / 2 + y - dotRadius,
          left: tableSize / 2 + x - dotRadius,
          child: Transform.rotate(
            angle: initialAngle + angle * i + pi / 2,
            // Rotate the dot to face center
            child: Container(
              width: Device.get().isTablet ? dotRadius * 2 : dotRadius * 1.7,
              height: Device.get().isTablet ? dotRadius * 2 : dotRadius * 1.7,
              decoration: const BoxDecoration(
                  // color: Colors.black87,
                  image: DecorationImage(
                image: AssetImage("assets/tablet_icons/chair.png"),
                fit: BoxFit.fill,
              )),
            ),
          ),
        ),
      );
    }
    return dots;
  }

  Widget _paymentModeSection() {
    return Container(
      // color: Colors.black12,
      // padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paymentOption(totalTable, "Total Table", MAIN_COLOR),
          _paymentOption(freeTable, "Available", GREEN_COLOR),
          _paymentOption(busyTable, "Busy", RED_COLOR),
        ],
      ),
    );
  }

  _paymentOption(
    int count,
    String title,
    Color main_color,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height / 10.0;
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            height: height,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(color: MAIN_COLOR),
                color: main_color,
                borderRadius: BorderRadius.circular(8)),
            padding: paddingXY(x: 5, y: 5),
            child: Center(
                child: Column(
              children: [
                // SvgPicture.asset(paymentIcon, height: 35),
                // widthSpacer(10),

                Center(
                    child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                      color: WHITE_COLOR, fontSize: LARGE_PLUS_FONT_SIZE),
                )),
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                        color: WHITE_COLOR, fontSize: LARGE_PLUS_FONT_SIZE),
                  ),
                )
              ],
            )),
          )),
    );
  }
}
