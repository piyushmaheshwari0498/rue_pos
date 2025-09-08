// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/core/service/api_sales/api/api_sales_service.dart';
import 'package:nb_posx/core/service/api_sales/sales_overview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../utils copy/ui_utils/spacer_widget.dart';
import '../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../service/api_sales/model/orderDetailsModel.dart';
import '../../../service/api_sales/model/todaySalesModel.dart';
import '../../widget/title_search_bar.dart';
import '../../widget/title_search_bar_backbutton.dart';

class SalesMenuLandscape extends StatefulWidget {
  int type;

  SalesMenuLandscape({Key? key, required this.type}) : super(key: key);

  @override
  State<SalesMenuLandscape> createState() => _SalesMenuState();
// TODO: implement createState
}

class _SalesMenuState extends State<SalesMenuLandscape> {
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
  String _selectedTypeId = "";
  bool isSalesOn = false;
  late TodaySalesModel todaySalesModel;

  final _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCtrl = TextEditingController();
    _listSalesOverview =
        _getSalesOverView("0 - 0", "0 - 0", "0 - 0", "0 - 0", "0 - 0", "0 - 0");
    _listSalesColorOverview.add(Colors.lightBlueAccent);
    _listSalesColorOverview.add(Colors.orangeAccent);
    _listSalesColorOverview.add(Colors.white54);
    _listSalesColorOverview.add(Colors.grey);
    _listSalesColorOverview.add(Colors.redAccent);
    _listSalesColorOverview.add(Colors.lightGreen);

    _getDetails();
  }

  List<SalesOverview> _getSalesOverView(String cash, String card,
      String benefit, String discount, String cancel, String total) {
    List<SalesOverview> list = [];

    list.add(SalesOverview(
        title: "Cash Sales", data: cash, img: "assets/icons/cash_icon.svg"));
    list.add(SalesOverview(
        title: "Card Sales", data: card, img: "assets/icons/cash_icon.svg"));
    list.add(SalesOverview(
        title: "Benefit", data: benefit, img: "assets/icons/cash_icon.svg"));
    list.add(SalesOverview(
        title: "Discounts", data: discount, img: "assets/icons/cash_icon.svg"));
    list.add(SalesOverview(
        title: "Cancelled",
        data: cancel,
        img: "assets/icons/order_history_icon.svg"));
    list.add(SalesOverview(
        title: "Total Sales",
        data: total,
        img: "assets/icons/order_history_icon.svg"));

    return list;
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      isSalesOn = prefs.getBool(isSalesOverview) ?? false;
      _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });

    todaySalesModel = await SalesService().getTodaySales(
        branchId: _selectedBranchId,
        userId: _selectedEmployeeId,
        counterId: _selectedCounterId);

    _listSalesOverview = _getSalesOverView(
        "${todaySalesModel!.cashSales} - ${todaySalesModel.cashCnt}",
        "${todaySalesModel.cardSales} - ${todaySalesModel.cardCnt}",
        "${todaySalesModel.benifitSales} - ${todaySalesModel.benifitSales}",
        "${todaySalesModel.discountAmount} - ${todaySalesModel.discountCnt}",
        "${todaySalesModel.cancelledSales} - ${todaySalesModel.cancelledCnt}",
        "${todaySalesModel.totalSales} - ${todaySalesModel.sales!.length}");
    id = todaySalesModel!.sales![0]!.salId!;

    setState(() {});

    // futureOrderDetails =
    //     SalesService().getOrderDetailsById(OrderType: 'Direct', id: '$id');
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
    _controller.animateTo(tappedIndex.toDouble(),
        duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);

    // _controller.jumpTo(4);

    return Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 50,
        //   // backgroundColor: Colors.brown,
        //   // leading:
        //   // IconButton(
        //   //   onPressed: () {
        //   //     Navigator.of(context).pop();
        //   //   },
        //   //   icon: const Icon(
        //   //     Icons.arrow_back_ios,
        //   //     color: Colors.white,
        //   //     size: 30,
        //   //   ),
        //   // ),
        //   // title: Text(
        //   //   'Sales',
        //   //   style: getTextStyle(
        //   //       fontSize: LARGE_PLUS_FONT_SIZE, color: BLACK_COLOR),
        //   // ),
        // ),
        body: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 7 / 16,
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 30),
                      child: Column(children: [
                        TitleAndSearchBarBack(
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
                          searchBoxWidth: widget.type == 0
                              ? MediaQuery.of(context).size.width / 5.5
                              : MediaQuery.of(context).size.width / 5.5,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width + 15,
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
                                      _listSales = todaySalesModel!.sales!;
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
                                                setState(() {
                                                  id = _listSales[index].salId!;
                                                  tappedIndex = index;
                                                  getOrderDetails('$id');
                                                  // if (_controller.hasClients) {

                                                  // }
                                                });
                                              },
                                              child: Card(
                                                semanticContainer: true,
                                                margin: const EdgeInsets.only(
                                                    bottom: 30.0),
                                                elevation: 10.0,
                                                color: tappedIndex == index
                                                    ? LIGHT_BLACK_COLOR
                                                    : Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
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
                                                            fontSize: 20.0,
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
                                                            fontSize: 30.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: const BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Text(
                                                          _listSales[index]
                                                                  .payStatus ??
                                                              "",
                                                          style: getTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.0,
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
                                                            fontSize: 20.0,
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
                Container(
                  width: 2.0,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey,
                ),
                /*Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                    color: Colors.grey[200],
                    //height: 100,
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              // Expanded(
                              // child: SizedBox(
                              //   height: 70,
                              //   child: ElevatedButton.icon(
                              //     style: ElevatedButton.styleFrom(
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(5)),
                              //         backgroundColor: const Color.fromARGB(
                              //             255, 84, 164, 86)),
                              //     onPressed: () {},
                              //     label: Text(
                              //       'Make Payment',
                              //       style: getTextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 17.0),
                              //     ),
                              //     icon: const Icon(Icons.wallet,
                              //         size: 30, color: Colors.white),
                              //   ),
                              // ),
                              // ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: MAIN_COLOR),
                                    onPressed: () {},
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
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: RED_COLOR,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onPressed: () {},
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
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // Expanded(
                              //   child: SizedBox(
                              //     height: 70,
                              //     child: ElevatedButton.icon(
                              //       style: ElevatedButton.styleFrom(
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(5)),
                              //         backgroundColor: Colors.brown,
                              //       ),
                              //       onPressed: () {},
                              //       label: Text(
                              //         'Comment',
                              //         style: getTextStyle(
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: 17.0),
                              //       ),
                              //       icon: const Icon(
                              //         Icons.message,
                              //         size: 30,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: widget.type == 0 ? 0 : 30,
                            right: widget.type == 0 ? 0 : 30
                            // bottom: 50
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                                // height:
                                // MediaQuery.of(context).size.height - 215,
                              width: MediaQuery.of(context).size.width / 3,
                                // width:
                                //      widget.type == 0 ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2 - 10,
                                // height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                                child: getOrderDetails('$id')),
                          ),
                        )
                      ],
                    ),
                  )),
                ),*/
                Expanded(
                  child: Column( // Keeps buttons fixed at the top
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
                                  onPressed: () {},
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
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: RED_COLOR,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5))),
                                  onPressed: () {},
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              color: Colors.white,
                              child: getOrderDetails('$id'), // This part scrolls
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                isSalesOn
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

  Widget itemListWidget(SalesOverview item, Color bgColor) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Container(
        // padding: EdgeInsets.only(left: 20, top: 60),
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
        //  width: double.infinity,
        // height: 100,
        margin: const EdgeInsets.only(bottom: 8, top: 15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  width: 55,
                  height: 55,
                  child: SvgPicture.asset(
                    item.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Image.asset(BURGAR_IMAGE),
              // widthSpacer(10),
              Expanded(
                child: SizedBox(
                    // height: 120,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        item.data,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                            fontWeight: FontWeight.bold,
                            color: WHITE_COLOR,
                            fontSize: LARGE_MINUS_FONT_SIZE),
                      )),
                    ]),
                    hightSpacer10,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: Text(
                            "${item.title}",
                            style: getTextStyle(
                                fontWeight: FontWeight.w900,
                                color: WHITE_COLOR,
                                fontSize: LARGE_MINUS_FONT_SIZE),
                          )),
                          // const Spacer(),
                          // const Icon(Icons.delete)
                        ]),
                  ],
                )),
              ),
            ],
          ),
        ));
  }

  getOrderDetails(String idd) {
    log("Sale Id ${idd}");
    if (idd != "-1") {
      return SingleChildScrollView(
          child: FutureBuilder<OrderDetailsModel>(
          future:
              SalesService().getOrderDetailsById(OrderType: 'Direct', id: idd),
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
                    'Rue.',
                    style: getTextStyle(
                        fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                  Text(
                    'Al Janabiyah',
                    style: getTextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  Text(
                    'Kingdom of Bahrain',
                    style: getTextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18.0),
                  ),
                  Text(
                    '39399090',
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
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Order Date : ${orderDetailsModel?.orderList?[0].ordDate}',
                            style: getTextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            'Delivery Date : ${orderDetailsModel?.orderList?[0].ordNo}',
                            style: getTextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            'Order Type : ${orderDetailsModel?.orderList?[0].orderType}',
                            style: getTextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                          Text(
                            'Server : ',
                            style: getTextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        '.......................................................................................................',
                      ),
                      ListTile(
                        leading: Text(
                          'Description',
                          style: getTextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: Text(
                            'Qty',
                            style: getTextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.0),
                          ),
                        ),
                      ),
                      const Text(
                        '.......................................................................................................',
                      ),
                      for (int i = 0;
                          i < orderDetailsModel!.orderList![0].orderDtl!.length;
                          i++)
                        ListTile(
                          leading: Text(
                            '${orderDetailsModel?.orderList?[0].orderDtl?[i].description}',
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          // subtitle: Text('${orderDetailsModel?.orderList?[0].orderDtl![i].vari}'),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: Text(
                              '${orderDetailsModel?.orderList?[0].orderDtl?[i].qty}',
                              style: getTextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                        ),
                      const Text(
                        '.......................................................................................................',
                      ),
                    ],
                  ),
                  Text(
                    'Total Item(s) ${totalQty}.0',
                    style: getTextStyle(
                        fontWeight: FontWeight.w500, fontSize: 30.0),
                  ),
                  const Text(
                    '.......................................................................................................',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 20),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Printed On : 23-03-2024 11:11 PM',
                        style: getTextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                    ),
                  ),
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
}
