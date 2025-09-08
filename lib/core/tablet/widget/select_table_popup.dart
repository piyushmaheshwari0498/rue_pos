import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
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
import '../../../network/api_helper/api_status.dart';
import '../../service/api_table/api/table_api_service.dart';
import '../../service/api_table/model/table_comman_response.dart';
import '../../service/select_customer/api/get_customer.dart';

import 'package:nb_posx/core/service/api_table/model/table_model.dart' as tab;
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

import 'hotel_tab_screen.dart';

// ignore: must_be_immutable
class SelectTablePopup extends StatefulWidget {
  // Customer? customer;
  SelectTablePopup({Key? key}) : super(key: key);

  @override
  State<SelectTablePopup> createState() => _SelectTablePopupState();
}

class TabsConfig {
  static List<String> tabs = [];
  static int selectedTabIndex = 0;
}

class _SelectTablePopupState extends State<SelectTablePopup>
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

  final double dotRadius = 15.0;

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
  String _selectedBranchId = "";

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
    controller.dispose();
    // searchCtrl.dispose();
    // _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        // width: size.width / 2.5,
        // height: size.height * 0.80,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              //on close
              if (selectedSeats.isNotEmpty) {
                Get.back(result: selectedSeats[0]);
              } else {
                Get.back(result: null);
              }
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 0, top: 0),
                child:
                    // SvgPicture.asset(
                    //   CROSS_ICON,
                    //   color: BLACK_COLOR,
                    //   width: 20,
                    //   height: 20,
                    // ),
                    Text(
                  "Done",
                  style: getTextStyle( fontSize: Device.get().isTablet
                      ? MediaQuery.of(context).size.width * 0.01
                      : 12.0,),
                )),
          ),
        ),
        Center(
            child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Center(
                  child: Text(
                    "Select Table",
                    style: getTextStyle( fontSize: Device.get().isTablet
                        ? MediaQuery.of(context).size.width * 0.01
                        : 12.0,),
                  ),
                ))),

        TabBar(
          labelStyle: getTextStyle( fontSize: Device.get().isTablet
              ? MediaQuery.of(context).size.width * 0.01
              : 12.0,),
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
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Column(children: [
              Container(
                width: Device.get().isTablet
                    ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width,
                height: Device.get().isTablet
                    ? MediaQuery.of(context).size.height / 1.85
                    : MediaQuery.of(context).size.height / 1.65,
                child: GridView.builder(
                  itemCount: tableList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Device.get().isTablet ? columns : 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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

        _paymentModeSection(),
      ],

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     TabsConfig.tabs.add('New tab ${TabsConfig.tabs.length}');
      //     // setState(() {});
      //     updateTabs();
      //   },
      // ),
    ));
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
                if (!isSeatBooked) {
                  if (selectedSeats.isNotEmpty) {
                    if (isSeatSelected) {
                      selectedSeats.remove(seat);
                    } else {
                      selectedSeats.clear();
                      selectedSeats.add(seat);
                    }
                  } else {
                    selectedSeats.clear();
                    selectedSeats.add(seat);
                  }
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
                    : isSeatSelected
                        ? Colors.blue // Selected seat color
                        : GREEN_COLOR, // Available seat color
              ),

              // color: isSeatBooked
              //     ? RED_COLOR
              //     : isSeatSelected
              //         ? Colors.blue // Selected seat color
              //         : GREEN_COLOR, // Available seat color
              margin: Device.get().isTablet
                  ? MediaQuery.of(context).size.height <= 800
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(38) : const EdgeInsets.all(35),
              child: Center(
                  child: Column(
                children: [
                  // SvgPicture.asset(paymentIcon, height: 35),
                  Device.get().isTablet
                      ? defaultTargetPlatform == TargetPlatform.iOS
                      ? hightSpacer10
                      : hightSpacer20 : hightSpacer10,
                  Center(
                      child: Text(
                    '${seat.noofSeats} Seats',
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      color: WHITE_COLOR,
                      fontSize: Device.get().isTablet
                          ? MediaQuery.of(context).size.height <= 800
                              ? MediaQuery.of(context).size.width * 0.01
                              : MediaQuery.of(context).size.width * 0.015
                          : MediaQuery.of(context).size.width * 0.015,
                    ),
                  )),
                  Device.get().isTablet
                      ? defaultTargetPlatform == TargetPlatform.iOS
                      ? hightSpacer10
                      : hightSpacer20 : hightSpacer10,
                  Center(
                    child: Text(
                      '${seat.tableNo}',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: Device.get().isTablet
                            ? MediaQuery.of(context).size.height <= 800
                                ? MediaQuery.of(context).size.width * 0.01
                                : MediaQuery.of(context).size.width * 0.015
                            : MediaQuery.of(context).size.width * 0.015,
                      ),
                    ),
                  ),
                  Device.get().isTablet
                      ? defaultTargetPlatform == TargetPlatform.iOS
                      ? hightSpacer10
                      : hightSpacer20 : hightSpacer10,
                  Center(
                    child: Text(
                      '${seat.balanceAmount} BD',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        color: WHITE_COLOR,
                        fontSize: Device.get().isTablet
                            ? MediaQuery.of(context).size.height <= 800
                                ? MediaQuery.of(context).size.width * 0.01
                                : MediaQuery.of(context).size.width * 0.015
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
    /*return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.78,
            // padding: horizontalSpace(),
            //changes needed to be done here(malvika)
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10, // Adjust the number of columns as needed
              ),
              itemCount: tableList.length,
              itemBuilder: (context, index) {
                final seat = tableList[index];
                final isSeatSelected = selectedSeats.contains(seat);
                final isSeatBooked = tableList[index].status == 1;

                return Stack(children: [

                  InkWell(
                    onTap: () {
                      setState(() {
                        if (!isSeatBooked) {
                          if (selectedSeats.isNotEmpty) {
                            if (isSeatSelected) {
                              selectedSeats.remove(seat);
                            } else {
                              selectedSeats.clear();
                              selectedSeats.add(seat);
                            }
                          } else {
                            selectedSeats.clear();
                            selectedSeats.add(seat);
                          }
                        }
                      });
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/app_icon/4table.png',
                          fit: BoxFit.fitHeight,
                          //
                          width: 100,
                          height: 800,
                          color: isSeatBooked
                              ? RED_COLOR
                              : isSeatSelected
                              ? Colors.blue // Selected seat color
                              : GREEN_COLOR,
                        )),
                  ),

                  Container(
                    decoration:  BoxDecoration(
                        shape: BoxShape.circle, color: MAIN_COLOR.withOpacity(0.4)),

                    // color: isSeatBooked
                    //     ? RED_COLOR
                    //     : isSeatSelected
                    //         ? Colors.blue // Selected seat color
                    //         : GREEN_COLOR, // Available seat color
                    margin: const EdgeInsets.all(12),
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
                              color: BLACK_COLOR,
                              fontSize: SMALL_PLUS_FONT_SIZE),
                        )),
                        // hightSpacer5,
                        Center(
                          child: Text(
                            '${seat.tableNo}',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                                color: BLACK_COLOR, fontSize: MEDIUM_FONT_SIZE),
                          ),
                        ),
                        // hightSpacer5,
                        Center(
                          child: Text(
                            '${seat.balanceAmount} BD',
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                                color: BLACK_COLOR,
                                fontSize: MEDIUM_FONT_SIZE),
                          ),
                        ),
                        hightSpacer10,
                      ],
                    )),
                  ),
                  // _buildSeatDots(seat!.noofSeats,seat!.noofSeats),
                ]);
              },
            ),
          ),
        ],
      ),
    );*/
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
    int padding = 15;
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
              // width: dotRadius * 2,
              // height: dotRadius * 2,
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
    double height = MediaQuery.of(context).size.height / 15.0;
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            height: Device.get().isTablet ? height : 50,
            width: Device.get().isTablet ? 300 : 80,
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
                    color: WHITE_COLOR,
                    fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.025,
                  ),
                )),
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      color: WHITE_COLOR,
                      fontSize:  Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.020,
                    ),
                  ),
                )
              ],
            )),
          )),
    );
  }
}

class TableWidget extends StatelessWidget {
  final double tableSize;
  final double dotRadius;
  final int seats;

  const TableWidget(
      {super.key,
      required this.tableSize,
      required this.dotRadius,
      required this.seats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tableSize,
      height: tableSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle representing the table
          Container(
            alignment: Alignment.center,
            // margin: const EdgeInsets.all(10),
            width: Device.get().isTablet ? 200 : 150,
            height: Device.get().isTablet ? 200 : 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          // Red dots representing seats
          ..._buildSeatDots(),
        ],
      ),
    );
  }

  List<Widget> _buildSeatDots() {
    List<Widget> dots = [];
    double angle = (2 * pi) / seats;
    double initialAngle = -pi / 2; // Starting from the top

    // Calculate positions for each seat
    int padding = 5;
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
              width: Device.get().isTablet ? dotRadius * 2 : dotRadius * 1.7,
              height: Device.get().isTablet ? dotRadius * 2 : dotRadius * 1.7,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),
        ),
      );
    }
    return dots;
  }
}
