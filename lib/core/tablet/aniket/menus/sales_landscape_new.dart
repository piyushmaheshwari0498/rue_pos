// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/core/service/api_sales/api/api_sales_service.dart';
import 'package:nb_posx/core/service/api_sales/sales_overview.dart';
import 'package:nb_posx/core/tablet/aniket/menus/all_orders/receiptData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../utils copy/ui_utils/spacer_widget.dart';
import '../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../utils/helper.dart' show Helper;
import '../../../service/api_sales/model/orderDetailsModel.dart';
import '../../../service/api_sales/model/todaySalesModel.dart';
import '../../widget/title_search_bar.dart';
import '../../widget/title_search_bar_backbutton.dart';

class SalesMenuLandscapeNew extends StatefulWidget {
  int type;

  SalesMenuLandscapeNew({Key? key, required this.type}) : super(key: key);

  @override
  State<SalesMenuLandscapeNew> createState() => _SalesMenuState();
// TODO: implement createState
}

class _SalesMenuState extends State<SalesMenuLandscapeNew> {
  List<Sales> _listSales = [];
  List<SalesOverview> _listSalesOverview = [];
  List<Color> _listSalesColorOverview = [];
  late Future<OrderDetailsModel> futureOrderDetails;
  OrderDetailsModel? orderDetailsModel;
  late int tappedIndex = 0;
  int id = -1;
  int totalQty = 0;

  late TextEditingController searchCtrl;
  final FocusNode _focusNode = FocusNode();

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedEmployeeName = "";
  String _selectedTypeId = "";
  bool isSalesOn = false;
  late TodaySalesModel todaySalesModel;

  final _controller = ScrollController();

  String? selectedPrinter;
  String? printerIP;
  String? branch_name;
  String? branch_add1;
  String? branch_add2;
  String? branch_add3;
  String? branch_phone;
  String? branch_vat;
  String? branch_crno;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCtrl = TextEditingController();
    // _listSalesOverview =
    //     _getSalesOverView("0 - 0", "0 - 0", "0 - 0", "0 - 0", "0 - 0", "0 - 0");


    _getDetails();
  }

  List<SalesOverview> _getSalesOverView(String cash, String card,
      String benefit, String discount, String cancel, String total) {
    List<SalesOverview> list = [];

    list.add(SalesOverview(
        title: "Cash Sales", data: cash, img: "assets/icons/cash_icon.svg"));
    list.add(SalesOverview(
        title: "Card Sales", data: card, img: "assets/icons/card_icon.svg"));
    list.add(SalesOverview(
        title: "Benefit",
        data: benefit,
        img: "assets/icons/benefitpay_logo.svg"));
    for(int i=0;i<todaySalesModel.deliveryService!.length;i++){
      list.add(SalesOverview(
          title: todaySalesModel.deliveryService![i].name!, data: "${todaySalesModel.deliveryService![i].amount} - ${todaySalesModel.deliveryService![i].cnt}", img: "${todaySalesModel.deliveryService![i].image}"));
    }
    list.add(SalesOverview(
        title: "Discounts", data: discount, img: "assets/icons/discount.svg"));
    list.add(SalesOverview(
        title: "Cancelled",
        data: cancel,
        img: "assets/icons/cancelled_order.svg"));
    list.add(SalesOverview(
        title: "Total Sales",
        data: total,
        img: "assets/icons/order_history_icon.svg"));

    return list;
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;
    DBPreferences dbPreferences = DBPreferences();

    // ✅ Read prefs first (async work outside setState)
    String employeeId = manager.id;
    String employeeName = manager.name;
    String branch = prefs.getString(BranchName) ?? '';
    String branchId = prefs.getString(BranchId) ?? '';
    String counter = prefs.getString(CounterName) ?? '';
    String counterId = prefs.getString(CounterId) ?? '';
    String ip = prefs.getString('printer_ip') ?? "";
    String printerType = prefs.getString('printer_type') ?? "No Printer";
    String branchName = prefs.getString(BranchName) ?? "";
    String add1 = prefs.getString(BranchAdd1) ?? "";
    String add2 = prefs.getString(BranchAdd2) ?? "";
    String add3 = prefs.getString(BranchAdd3) ?? "";
    String phone = prefs.getString(BranchPhone) ?? "";
    String vat = prefs.getString(BranchVAT) ?? "";
    String crno = prefs.getString(BranchCRNo) ?? "";
    bool salesOn = prefs.getBool(isSalesOverview) ?? false;

    // ✅ API call outside setState
    todaySalesModel = await SalesService().getTodaySales(
      branchId: branchId,
      userId: employeeId,
      counterId: counterId,
    );

    _listSalesOverview = [];
    _listSalesOverview = _getSalesOverView(
      "${todaySalesModel!.cashSales} - ${todaySalesModel.cashCnt}",
      "${todaySalesModel.cardSales} - ${todaySalesModel.cardCnt}",
      "${todaySalesModel.benifitSales} - ${todaySalesModel.benifitSales}",
      "${todaySalesModel.discountAmount} - ${todaySalesModel.discountCnt}",
      "${todaySalesModel.cancelledSales} - ${todaySalesModel.cancelledCnt}",
      "${todaySalesModel.totalSales} - ${todaySalesModel.sales!.length}",
    );

    for(int i=0;i<_listSalesOverview.length;i++) {
      _listSalesColorOverview.add(Colors.white);
    }

    if (todaySalesModel.sales!.isNotEmpty) {
      id = todaySalesModel.sales![0].salId!;
    }

    // ✅ Now update UI state synchronously
    setState(() {
      _selectedEmployeeId = employeeId;
      _selectedEmployeeName = employeeName;
      _selectedBranch = branch;
      _selectedBranchId = branchId;
      _selectedCounter = counter;
      _selectedCounterId = counterId;
      printerIP = ip;
      selectedPrinter = printerType;
      branch_name = branchName;
      branch_add1 = add1;
      branch_add2 = add2;
      branch_add3 = add3;
      branch_phone = phone;
      branch_vat = vat;
      branch_crno = crno;
      isSalesOn = salesOn;
    });

    print("getOrderDetails_Id $id");

    // ✅ Finally, trigger order details fetch
    getOrderDetails('$id');
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    log("Tapped Index ${tappedIndex}");
    // _controller.animateTo(tappedIndex.toDouble(),
    // duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);

    if (_controller.hasClients) {
      _controller.animateTo(
        tappedIndex.toDouble(),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }

    // _controller.jumpTo(4);

    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: Device.get().isTablet ? 7 / 16 : 2 / 4.2,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: Device.get().isTablet ? 10 : 50,
                          bottom: 30),
                      child: Column(children: [
                        Device.get().isTablet
                            ? titleAndSearchBar()
                            : Center(
                                child: Text(
                                "Sales",
                                style: getTextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        // Device.get().isTablet
                        //     ? titleAndSearchBar()
                        //     : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        searchTextBar(onChanged: (query) {
                          debugPrint("Searching for: $query");
                        }),
                        SizedBox(
                            width: Device.get().isTablet
                                ? MediaQuery.of(context).size.width + 15
                                : MediaQuery.of(context).size.width - 20,
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: FutureBuilder<TodaySalesModel>(
                                future: SalesService().getTodaySales(
                                    branchId: _selectedBranchId,
                                    userId: _selectedEmployeeId,
                                    counterId: _selectedCounterId),
                                builder: (context, snapshot) {
                                  // print("getTodaySales ${snapshot.data}");
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // until data is fetched, show loader
                                    return Center(
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child:
                                              const CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasData) {
                                    TodaySalesModel? todaySalesModel =
                                        snapshot.data;

                                    if (todaySalesModel!.status == 0) {
                                      return Center(
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Text(
                                              "No Data Found",
                                              style: getTextStyle(
                                                  color: BLACK_COLOR),
                                            )),
                                      );
                                    } else {
                                      _listSales = todaySalesModel.sales!;
                                      // if (_listSales.isEmpty) {
                                      // } else {
                                      //   id = _listSales[0].salId!;
                                      // }
                                      // print('iddddddd $id');
                                      // getOrderDetails('${_listSales[0].salId}');

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          reverse: false,
                                          controller: _controller,
                                          itemCount: _listSales.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                id = _listSales[index].salId!;
                                                print(
                                                    "sales_id to be pass $id");
                                                !Device.get().isTablet
                                                    ? showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            Receiptdata(
                                                              sales_id: id,
                                                            )
                                                        // receiptColumn(),
                                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Receiptdata(id: id)));
                                                        )
                                                    : setState(() {
                                                        id = _listSales[index]
                                                            .salId!;
                                                        tappedIndex = index;
                                                        getOrderDetails('$id');
                                                      });
                                              },
                                              child: Card(
                                                semanticContainer: true,
                                                margin: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                elevation: 4.0,
                                                color: tappedIndex == index
                                                    ? LIGHT_BLACK_COLOR
                                                    : Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    spacing: 4,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _listSales[index]
                                                                .salNo ??
                                                            "",
                                                        style: getTextStyle(
                                                            color:
                                                                tappedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontSize: Device
                                                                        .get()
                                                                    .isTablet
                                                                ? LARGE_MINUS20_FONT_SIZE
                                                                : MEDIUM_FONT_SIZE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ' ${_listSales[index].netAmount ?? ""} BD',
                                                        style: getTextStyle(
                                                            color:
                                                                tappedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontSize: Device
                                                                        .get()
                                                                    .isTablet
                                                                ? LARGE_PLUS_FONT_SIZE
                                                                : MEDIUM_PLUS_FONT_SIZE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        width: 130,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: _listSales[index].status == 4 ? Colors.green : Colors.orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Text(
                                                          _listSales[index]
                                                                  .statusText ??
                                                              "",
                                                          style: getTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: Device
                                                                          .get()
                                                                      .isTablet
                                                                  ? LARGE_MINUS20_FONT_SIZE
                                                                  : MEDIUM_PLUS_FONT_SIZE,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Text(
                                                        _listSales[index]
                                                                .salDate ??
                                                            "",
                                                        style: getTextStyle(
                                                            color:
                                                                tappedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontSize: Device
                                                                        .get()
                                                                    .isTablet
                                                                ? LARGE_PLUS_FONT_SIZE
                                                                : MEDIUM_PLUS_FONT_SIZE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  } else {
                                    return Center(
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child: Text(
                                            "No Data Found",
                                            style: getTextStyle(
                                                color: BLACK_COLOR),
                                          )),
                                    );
                                  }
                                }))
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Device.get().isTablet
                    ? Container(
                        width: 2.0,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.grey,
                      )
                    : Container(),
                Expanded(
                    child:
                        Device.get().isTablet ? receiptColumn() : SizedBox()),
                isSalesOn &&
                        Device.get().isTablet &&
                        _listSalesOverview.isNotEmpty
                    ? AspectRatio(
                        aspectRatio: 7 / 18,
                        child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 30),
                              child: Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width + 15,
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.builder(
                                        shrinkWrap: false,
                                        itemCount: _listSalesOverview.length,
                                        itemBuilder: (context, index) {
                                          return itemListWidget(
                                              _listSalesOverview[index],
                                              _listSalesColorOverview[index]);
                                        })),
                              ])),
                        ),
                      )
                    : Container(),
              ],
            )));
  }

  Widget titleAndSearchBar() {
    return TitleAndSearchBarBack(
      searchBoxVisible: Device.get().isTablet ? true : false,
      focusNode: _focusNode,
      inputFormatter: [],
      title: "Sales",
      showButton: widget.type,
      onSubmit: (text) {
        // if (text.length >= 3) {
        //   categories.isEmpty
        //       ? const Center(
        //       child: Text(
        //         "No items found",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ))
        //       : _filterProductsCategories(text);
        // } else {
        //   getProducts();
        // }
      },
      onTextChanged: (changedtext) {
        // if (changedtext.length >= 3) {
        //   categories.isEmpty
        //       ? const Center(
        //       child: Text(
        //         "No items found",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ))
        //       : _filterProductsCategories(changedtext);
        // } else {
        //   getProducts();
        // }
      },
      searchCtrl: searchCtrl,
      searchHint: "Search Order no.",
      searchBoxWidth:
          Device.get().isTablet ? MediaQuery.of(context).size.width / 6.3 : 300,
    );
  }

  Widget receiptColumn() {
    return Column(
      // Keeps buttons fixed at the top
      children: [
        // Fixed Buttons Row
        Container(
          color: Colors.grey[200], // Background color
          padding: EdgeInsets.symmetric(vertical: 10), // Padding for spacing
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: MAIN_COLOR),
                    onPressed: () {
                      _printReceipt("");
                    },
                    label: Text(
                      'Print Receipt',
                      style: getTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                    icon: const Icon(Icons.print_rounded,
                        size: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Visibility(
                visible: false,
                child: Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: RED_COLOR,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text(
                        'Cancel Order',
                        style: getTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                      icon: const Icon(Icons.cancel_outlined,
                          size: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: widget.type == 0 ? 0 : 30,
                right: widget.type == 0 ? 0 : 30,
              ),
              child: Material(
                // ✅ This line fixes the error
                color: Colors.white,
                child: Container(
                  width: Device.get().isTablet
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width - 20,
                  child: getOrderDetails('$id'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemListWidget(SalesOverview item, Color bgColor) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            spreadRadius: 1,
            blurRadius: 0,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8, top: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Left: Image
            ClipRRect(
              // borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 50,
                height: 50,
                child: item.img.contains("assets/") ? SvgPicture.asset(
                  item.img,
                  fit: BoxFit.cover,
                ) :
                Image.network(
                  "$RUE_BASE${item.img}",
                  fit: BoxFit.contain,
                  errorBuilder: (c, o, s) =>
                  const Icon(Icons.image, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Center: item.title
            Expanded(
              child: Text(
                item.title,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: getTextStyle(
                  fontWeight: FontWeight.bold,
                  color: BLACK_COLOR,
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                ),
              ),
            ),

            // Right: item.data
            Text(
              item.data,
              textAlign: TextAlign.end,
              style: getTextStyle(
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR,
                fontSize: MediaQuery.of(context).size.width * 0.01,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getOrderDetails(String idd) {
    log("Sale Id ${idd}");
    late final repeatCount = 0;
    if (idd != "-1") {
      return SingleChildScrollView(
          child: FutureBuilder<OrderDetailsModel>(
              future: SalesService()
                  .getOrderDetailsById(OrderType: 'Direct', id: idd),
              builder: (context, snapshot) {
                print("getOrderDetailsById ${snapshot.data.toString()}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: const CircularProgressIndicator()));
                } else if (snapshot.hasData) {
                  orderDetailsModel = snapshot.data;
                  totalQty = orderDetailsModel!.orderList![0].orderDtl!.length;
                  return Column(
                    children: [
                      Text(
                        'Rue',
                        style: getTextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50.0),
                      ),
                      Text(
                        'RUE CATERING BOUTIQUE W.L.L',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      Text(
                        '$branch_name',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      Text(
                        '$branch_add1',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      Text(
                        '$branch_add2',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      Text(
                        '$branch_add3 $branch_phone',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      Text(
                        'CR No: $branch_crno',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 1.0,
                        width: double.maxFinite,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order No : ${orderDetailsModel?.orderList?[0].ordNo}',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Table : ${orderDetailsModel?.orderList?[0].tableLocation}',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                              Text(
                                'Server : $_selectedEmployeeName',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          dots,
                          ListTile(
                            title: Row(
                              children: [
                                // Description gets more space
                                Expanded(
                                  flex: 1, // 25% of the space
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Qty',
                                      style: getTextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2, // 25% of the space
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Price',
                                      style: getTextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1, // 25% of the space
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Amount',
                                      style: getTextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          dots,
                          for (int i = 0;
                              i <
                                  orderDetailsModel!
                                      .orderList![0].orderDtl!.length;
                              i++)
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔹 Main row: description + qty
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1, // 25% for qty
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${orderDetailsModel?.orderList?[0].orderDtl?[i].qty}',
                                            style: getTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2, // 25% for qty
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${orderDetailsModel?.orderList?[0].orderDtl?[i].rate}',
                                            style: getTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1, // 25% for qty
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${orderDetailsModel?.orderList?[0].orderDtl?[i].total}',
                                            style: getTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    '${orderDetailsModel?.orderList?[0].orderDtl?[i].description}',
                                    softWrap: true,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  // 🔹 Toppings list (only if available + status true)
                                  if ((orderDetailsModel
                                              ?.orderList?[0]
                                              .orderDtl?[i]
                                              .tbDirectOrderTopping ??
                                          [])
                                      .isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: orderDetailsModel!.orderList![0]
                                          .orderDtl![i].tbDirectOrderTopping!
                                          .where((topping) =>
                                              topping.status ==
                                              true) // ✅ filter by status
                                          .map<Widget>((topping) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 2.0),
                                          child: Text(
                                            '${topping.name ?? ''} x${topping.qty} (${topping.rate})',
                                            style: getTextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                          dots,
                        ],
                      ),

                      // 🔹 Summary section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '${orderDetailsModel?.orderList?[0].subTotal ?? 0} $appCurrency2',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'VAT',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '${orderDetailsModel?.orderList?[0].taxAmount ?? 0} $appCurrency2',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  '${orderDetailsModel?.orderList?[0].discount ?? 0} $appCurrency2',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  // '${orderDetailsModel?.orderList?[0].deliveryCharges ?? 0}',
                                  '${0.0 ?? 0} $appCurrency2',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            dots,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  // '${orderDetailsModel?.orderList?[0].deliveryCharges ?? 0}',
                                  '${orderDetailsModel?.orderList?[0].netAmount ?? 0} $appCurrency2',
                                  style: getTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      dots,

                      // 🔹 Total Items (already there)
                      Text(
                        'Total Item(s) ${totalQty}.0',
                        style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                        ),
                      ),

                      dots,

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10, bottom: 20),
                      //   child: Container(
                      //     alignment: Alignment.bottomLeft,
                      //     child: Text(
                      //       'Printed On : 23-03-2024 11:11 PM',
                      //       style: getTextStyle(
                      //           fontWeight: FontWeight.w500, fontSize: 16.0),
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                } else {
                  return const Text('NA');
                }
              }));
    } else {
      return Center(
        child: Container(
            height: 100,
            width: 100,
            child: Text(
              "No Data Found",
              style: getTextStyle(color: BLACK_COLOR),
            )),
      );
    }
  }

  Widget get dots {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Rough estimate: assume each '..' takes about 10 pixels width
        final repeatCount = (constraints.maxWidth / 9).floor();
        return Text(
          List.generate(repeatCount, (_) => '..').join(),
          style: TextStyle(fontSize: 16), // optional styling
        );
      },
    );
  }

  Widget searchTextBar({Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
            vertical: Device.get().isTablet ? 18.0 : 14.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
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

      bool printStatus = await Helper()
          .printProductionDuplicateInternalSunmiInvoice(
              context,
              orderDetailsModel!.orderList![0].orderDtl,
              orderDetailsModel!.orderList![0].netAmount,
              orderDetailsModel!.orderList![0].taxAmount,
              orderDetailsModel!.orderList![0].discount,
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
