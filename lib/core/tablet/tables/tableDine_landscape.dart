import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:nb_posx/utils%20copy/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../../database/db_utils/db_constants.dart';
import '../../../main.dart';
import '../../../network/api_helper/api_status.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import '../aniket/menus/all_orders/detailedCurrentOrders_landscape.dart';
import 'detailedTableOrders_landscape.dart';

// ignore: must_be_immutable
class TableDineLandscape extends StatefulWidget {
  // Customer? customer;
  TableDineLandscape({Key? key}) : super(key: key);

  @override
  State<TableDineLandscape> createState() => _SelectTablePopupState();
}

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class _SelectTablePopupState extends State<TableDineLandscape>
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
    // if (widget.customer != null) {
    //   customer = widget.customer!;
    // }
    // searchCtrl = TextEditingController();
    // // _phoneCtrl = TextEditingController();
    // if (customer != null) {
    //   searchCtrl.text = customer!.phone;
    // }

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
    // controller.dispose();
    // searchCtrl.dispose();
    // _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*return Column(
      children: <Widget>[
        hightSpacer20,
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                "Table and Dine-in",
                style: getTextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                ),
              ),
            )),
        TabBar(
          labelStyle: getTextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.01,
          ),
          isScrollable: true,
          labelColor: Colors.black,
          // controller: TabController(
          //   length: _tab.length,
          //   vsync: this,
          // ),
          controller: controller,
          tabs: _tab,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.lightBlue,
        ),

        // _tabData(),

        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: isTabletMode
                    // ? MediaQuery.of(context).size.height / 1.350
                    ? MediaQuery.of(context).size.height <= 800
                        ? MediaQuery.of(context).size.height / 1.190
                        : MediaQuery.of(context).size.height / 1.110
                    : MediaQuery.of(context).size.height * 0.9,
                child: GridView.builder(
                  itemCount: tableList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: LayoutBuilder(
                        builder: (context, box) {
                          // print(box.biggest.toString());
                          return _tabData(
                              index, box.maxWidth, tableList[index].noofSeats!);
                          //   TableWidget(
                          //   tableSize: box.maxWidth,
                          //   dotRadius: dotRadius,
                          //   seats: tableList[index].noofSeats!, // Assuming each table has (index + 1) * 2 seats
                          // );
                        },
                      ),
                    );
                  },
                ),
              ),
            ])),

        // TabScreen(),
        // Center(
        //   child: Row(
        //     children: [
        //
        //       for (var l in list) _floorModeSection(l.floorNo!),
        //     ],
        //   ),
        // ),

        // _paymentModeSection(),
      ],

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     TabsConfig.tabs.add('New tab ${TabsConfig.tabs.length}');
      //     // setState(() {});
      //     updateTabs();
      //   },
      // ),
    );*/
    return Column(
      children: <Widget>[
        hightSpacer20,
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(
            child: Text(
              "Table and Dine-in",
              style: getTextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.01,
              ),
            ),
          ),
        ),
        TabBar(
          labelStyle: getTextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.01,
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
                crossAxisCount: columns,
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
            onTap: () {
              setState(() {
                if (isSeatBooked && tableList[index].directOrdId != 0) {
                  Navigator.push(
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
                              customerName: "Walk-in Client")));
                }else{
                  Helper.showPopup(context, "Something wrong with Table Order");
                }
              });
            },
            child:
                // Container(
                //   alignment: Alignment.center,
                //   // margin: const EdgeInsets.all(10),
                //   width: 200,
                //   height: 200,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.grey[300],
                //   ),
                // ),
                Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSeatBooked
                    ? RED_COLOR
                    : GREEN_COLOR, // Available seat color
              ),

              // color: isSeatBooked
              //     ? RED_COLOR
              //     : isSeatSelected
              //         ? Colors.blue // Selected seat color
              //         : GREEN_COLOR, // Available seat color
              margin: MediaQuery.of(context).size.height <= 800
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(38),
              child: Center(
                  child: Column(
                children: [
                  // SvgPicture.asset(paymentIcon, height: 35),
                  hightSpacer20,
                  Center(
                      child: Text(
                    '${seat.noofSeats} Seats',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      color: WHITE_COLOR,
                      fontSize: MediaQuery.of(context).size.height <= 800
                          ? MediaQuery.of(context).size.width * 0.01
                          : MediaQuery.of(context).size.width * 0.015,
                    ),
                  )),
                  defaultTargetPlatform == TargetPlatform.iOS
                      ? hightSpacer10
                      : hightSpacer20,
                  Center(
                    child: Text(
                      '${seat.tableNo}',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: MediaQuery.of(context).size.height <= 800
                            ? MediaQuery.of(context).size.width * 0.01
                            : MediaQuery.of(context).size.width * 0.015,
                      ),
                    ),
                  ),
                  defaultTargetPlatform == TargetPlatform.iOS
                      ? hightSpacer10
                      : hightSpacer20,
                  Center(
                    child: Text(
                      '${seat.balanceAmount} BD',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: MediaQuery.of(context).size.height <= 800
                            ? MediaQuery.of(context).size.width * 0.01
                            : MediaQuery.of(context).size.width * 0.015,
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

      print("$x,$y");
      dots.add(
        Positioned(
          top: tableSize / 2 + y - dotRadius,
          left: tableSize / 2 + x - dotRadius,
          child: Transform.rotate(
            angle: initialAngle + angle * i + pi / 2,
            // Rotate the dot to face center
            child: Container(
              width: dotRadius * 2,
              height: dotRadius * 2,
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
