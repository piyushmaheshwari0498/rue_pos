import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/app_constants.dart';
import '../../../constants/asset_paths.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/models/api_category.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/order_item.dart';
import '../../../database/models/split_bill_model.dart';
import '../../../utils copy/helper.dart';
import '../../../utils copy/ui_utils/padding_margin.dart';
import '../../../utils copy/ui_utils/spacer_widget.dart';
import '../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../utils copy/ui_utils/textfield_border_decoration.dart';
import '../../../utils/ui_utils/keypad_button.dart';
import '../../../widgets/multitext_field_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../../service/api_cart/model/cart_data.dart';
import '../../service/api_orders/api/api_order_service.dart';
import '../../service/api_sales/model/orderDetailsModel.dart' as ot;
import '../create_order/payment_number_screen.dart';

class DetailTableOrdersLandscape extends StatefulWidget {
  final String orderNo;
  final int orderId;
  final String customerName;
  final String orderType;

  final double sub_total, discount, tax, total, cash, due;

  const DetailTableOrdersLandscape({
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
  State<StatefulWidget> createState() => DetailTableOrderState();
}

class DetailTableOrderState extends State<DetailTableOrdersLandscape> {
  ot.OrderDetailsModel? orderDetailsModel;
  late List<ot.OrderDtl> listOrders = [];
  double screenWidth = 0;
  double screenHeight = 0;
  double sub_total = 0,
      discount = 0,
      tax = 0,
      total = 0,
      tender_amount = 0,
      change_due = 0;

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
  // double totalAmount = 0.0;
  double balanceAmount = 0.0;
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

  late int selectedCashMode;
  late String selectedCashText;
  late bool selectedPaymentMode;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";

  late List<APICategory> tabMenu = [];
  int currenttabSelectedIndex = 0;

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
    getPaymentList();
    // _getDetails();

    getTabs();
    getDetailsFromApis();
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
    sub_total = orderDetailsModel!.orderList![0].subTotal!;
    tax = orderDetailsModel!.orderList![0].taxAmount!;
    // }

    // due = orderDetailsModel!.orderList[0].netAmount!;


    // if (!isTax) {
    //   sub_total = sub_total - tax;
    //   log("_itemTotal ${tax}");
    //   // total = total - taxAmount;
    // }
    // totalAmount = widget.total;

    listOrders = orderDetailsModel!.orderList![0].orderDtl!;
    // print('orderDetailssss');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
       // isTax = prefs.getBool(isTaxOn) ?? false;

    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
                            fontSize: LARGE_PLUS_FONT_SIZE,
                            color: BLACK_COLOR),
                      ),
                      Text(
                        '${orderDetailsModel!.orderList![0].tableNo} - ${orderDetailsModel!.orderList![0].ordNo} ',
                        style: getTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: LARGE_PLUS_FONT_SIZE,
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
                              fontSize: 22.0),
                        ),
                        Text(
                          'Discount',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                        Text(
                          'VAT',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
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
                              fontSize: 22.0),
                        ),
                        Text(
                          '${discount ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                        Text(
                          '${tax ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 3,
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
                          fontSize: 82.0),
                    )
                  ],
                ),
                Container(
                  height: 3,
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
                              fontSize: 22.0),
                        ),
                        Text(
                          'Change Due',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
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
                              fontSize: 22.0),
                        ),
                        Text(
                          '${change_due ?? 0.000} $appCurrency2',
                          style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width:
                        defaultTargetPlatform == TargetPlatform.iOS ? 600 : 700,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                          Text(
                            "${widget.total.toStringAsFixed(3)} $appCurrency2",
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
                                ? "${selectedCashText} Payment"
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
                                                    : "${widget.total.toStringAsFixed(3)} ",
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
                                                "${balanceAmount.toStringAsFixed(3)} ",
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
                                  width: 400,
                                  // height: 100,
                                  padding: horizontalSpace(),
                                  child: TextFieldWidget(
                                    boxDecoration: txtFieldBorderDecoration,
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
                                    boxDecoration: txtFieldBorderDecoration,
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
                                                //     :
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
                                    boxDecoration: txtFieldBorderDecoration,
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
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () async {
                                                  // Navigator.of(context, rootNavigator: true).pop();
                                                  // dispose();
                                                  List<TbDirectOrderPayment>
                                                      listPayment = [];
                                                  List<TbDirectOrderDet>
                                                      listOrder = [];
                                                  List<TbDirectOrderTopping>
                                                      listOrderTopping = [];

                                                  TbDirectOrderPayment payment =
                                                      TbDirectOrderPayment();

                                                  for (int i = 0;
                                                      i < listOrders.length;
                                                      i++) {
                                                    TbDirectOrderDet items =
                                                        TbDirectOrderDet();
                                                    items.itemId =
                                                        listOrders[i].itemId;
                                                    items.product =
                                                        listOrders[i]
                                                            .description;
                                                    items.description =
                                                        listOrders[i]
                                                            .description;
                                                    items.selprodimg = null;
                                                    items.selprodprice =
                                                        listOrders[i]
                                                            .rate
                                                            .toString();
                                                    items.rate = listOrders[i]
                                                        .rate
                                                        .toString();
                                                    items.remarks =
                                                        listOrders[i]
                                                                .remarks!
                                                                .isNotEmpty
                                                            ? true
                                                            : false;
                                                    items.name = "";
                                                    items.extraDesc = "";
                                                    items.nameonBox = "";
                                                    items.variationRemarks =
                                                        listOrders[i].remarks;
                                                    items.toppingAmount = "";
                                                    items.itemStatus = 0;
                                                    items.selcode = null;
                                                    items.qty = listOrders[i]
                                                        .qty as int?;
                                                    items.taxPercentage =
                                                        listOrders[i].taxPer
                                                            as int?;
                                                    items.taxCode = "S2";
                                                    items.tbDirectOrderDtlAssorted =
                                                        [];

                                                   /* if (listOrders[i]
                                                        .attributes
                                                        .isNotEmpty) {
                                                      for (int a = 0;
                                                          a <
                                                              widget
                                                                  .orderItem[i]
                                                                  .attributes
                                                                  .length;
                                                          a++) {
                                                        Attribute attr = widget
                                                            .orderItem[i]
                                                            .attributes[a];
                                                        TbDirectOrderTopping
                                                            topping =
                                                            TbDirectOrderTopping();
                                                        topping.id = attr.id;
                                                        topping.toppingId =
                                                            attr.toppingId;
                                                        topping.name =
                                                            attr.name;
                                                        topping.rate =
                                                            attr.rate;
                                                        topping.qty =
                                                            attr.qty.toInt();
                                                        topping.checked = true;

                                                        listOrderTopping
                                                            .add(topping);
                                                        items.tbDirectOrderTopping =
                                                            listOrderTopping;
                                                      }
                                                    } else {
                                                      items.tbDirectOrderTopping =
                                                          [];
                                                    }*/
                                                    listOrder.add(items);
                                                  }
                                                  if (selectedCashMode != 3) {
                                                    switch (selectedCashMode) {
                                                      case 0:
                                                        payment.modeofPay = 1;
                                                        payment.amount =
                                                            receivedAmount
                                                                .toString() as double?;
                                                        payment.cardNo = "";
                                                        break;
                                                      case 1:
                                                        payment.modeofPay = 2;
                                                        payment.amount =
                                                            widget.total
                                                                .toString() as double?;
                                                        payment.cardNo =
                                                            cardNumberCtrl.text;
                                                        break;
                                                      case 2:
                                                        payment.modeofPay = 3;
                                                        payment.amount =
                                                            widget.total
                                                                .toString() as double?;
                                                        payment.cardNo =
                                                            transRefCtrl.text;
                                                        break;
                                                    }
                                                    listPayment.add(payment as TbDirectOrderPayment);
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
                                                      switch (splitBillList[i]
                                                          .payment_type) {
                                                        case "Cash":
                                                          payment2.modeofPay =
                                                              1;
                                                          // log("splitBillList Payments : ${splitBillList[i].payment_type.toString()}");
                                                          break;
                                                        case "Card":
                                                          payment2.modeofPay =
                                                              2;
                                                          break;
                                                        case "Benefit Pay":
                                                          payment2.modeofPay =
                                                              3;
                                                          break;
                                                      }
                                                      payment2.amount =
                                                          splitBillList[i]
                                                              .amount
                                                              .toString() as double?;
                                                      payment2.cardNo =
                                                          splitBillList[i]
                                                              .transaction_no;

                                                      // log("Payments : ${splitBillList[i]
                                                      //     .payment_type.toString()}");
                                                      // log("Payments : ${payment2.toString()}");
                                                      listPayment.add(payment2 as TbDirectOrderPayment);
                                                      // log("Payments List1 : ${listPayment.toString()}");
                                                    }
                                                    log("Payments List1 : ${listPayment.toString()}");
                                                    // listPayment.addAll(listPayment2);
                                                    // listPayment.addAll(listPayment);
                                                  }

                                                  String payMode = "";
                                                  if (selectedCashMode == 0)
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

                                                  /*CartResponse cart = await CartApiService()
                                                      .insCartTakeAway(
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
                                                          taxAmount: taxAmount,
                                                          discountAmount:
                                                              widget.discount,
                                                          netAmount:
                                                              totalAmount,
                                                          balanceAmt:
                                                              balanceAmount,
                                                          tenderAmount:
                                                              splitTender,
                                                          orderItem: listOrder,
                                                          paymentItem:
                                                              listPayment);*/

                                                  Navigator.pop(context);

                                                  Helper.hideLoader(context);
                                                 /* if (cart.status == 1) {
                                                    Navigator.of(context)
                                                        .pop(cart);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pop(cart);
                                                  }*/
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
                                      borderRadius: BorderRadius.circular(10),
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
          )),
    );
  }

  getOrdersList() {
    int sr_no = 1;

    setState(() {});
    return FutureBuilder<ot.OrderDetailsModel?>(
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
          return Container(
            width: double.maxFinite,
            child: DataTable(
              showCheckboxColumn: false,
              border: const TableBorder(
                  bottom: BorderSide(color: Colors.grey, width: 1.0)),
              headingRowHeight: 80,
              dataRowHeight: 100,
              dataTextStyle:
                  // const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  getTextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              headingTextStyle: const TextStyle(
                  fontSize: 22,
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
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                    sr_no == 0 ? '${sr_no++}' : '${sr_no++}')),
                                DataCell(Text('${element.description}')),
                                DataCell(Text('${element.qty}')),
                                DataCell(Text('${element.subTotal} BHD')),
                                DataCell(Text('${element.rate} BHD')),
                              ],
                            )),
                      )
                      .toList(),
            ),
          );
        } else {
          return const Center(
            child: Text("Loading..."),
          );
        }
      },
    );
  }

  Widget _cashPayment() {
    return Container(
      padding: paddingXY(x: 20, y: 20),
      color: Colors.white,
      width: defaultTargetPlatform == TargetPlatform.iOS ? 350 : 400,
      height: 320,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        padding: defaultTargetPlatform == TargetPlatform.iOS
            ? paddingXY(x: 10, y: 6)
            : paddingXY(x: 16, y: 6),
        child: Row(
          children: [
            SvgPicture.asset(paymentIcon,
                height: defaultTargetPlatform == TargetPlatform.iOS ? 30 : 35),
            widthSpacer(10),
            Text(
              title,
              style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getTabs() async {
    selectedCashMode = 0;
    tabMenu.add(new APICategory(
        id: 0,
        en_name: "Cash",
        ar_name: "Percentage",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new APICategory(
        id: 0,
        en_name: "Card",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new APICategory(
        id: 0,
        en_name: "Benefit Pay",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));
    tabMenu.add(new APICategory(
        id: 0,
        en_name: "Split Pay",
        ar_name: "Amount",
        seq_no: 0,
        image: "",
        main_id_no: 0));

    tabMenu[selectedCashMode].isChecked = true;
  }

  void addList() {
    double val1 = widget.total / splitBillCount;

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
    double val1 = widget.total / splitBillCount;

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
      if (splitPaid >= widget.total) {
        splitBal = 0.000;
      } else {
        splitBal = splitPaid - widget.total;
      }
      if (splitPaid > widget.total) {
        splitTender = widget.total - splitPaid;
      } else if (splitPaid < widget.total) {
        splitTender = 0.000;
      } else {
        splitTender = 0.000;
      }
    }

    // for(SplitBill item in splitBillList)
    //   amountRefCtrl.text = "${item.amount.toStringAsPrecision(3)}";

    setState(() {});
  }

  Widget _SplitItemListSection() {
    return Expanded(
        flex: 10,
        child: SingleChildScrollView(
          child: Column(
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
                      alignment: Alignment.centerLeft,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        // phoneCtrl.text.length == 10 && nameCtrl.text.isNotEmpty
                        //     ? MAIN_COLOR
                        //     : MAIN_COLOR.withOpacity(0.3),
                        // border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.3)),
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

              // for (SplitBill bill in splitBillList)
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: splitBillList.length,
                  itemBuilder: (BuildContext context, int index) {
                    amountRefCtrl.add(TextEditingController());
                    splittransRefCtrl.add(TextEditingController());
                    return splititemListWidget(splitBillList[index], index);
                  }),

              // (widget.orderList.length <= 1)
              //     ? const SizedBox(height: 200)
              //     : (widget.orderList.length <= 2)
              //     ? const SizedBox(height: 200)
              //     : const SizedBox(height: 30),
            ],
          ),
        ));
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
                                  fontSize: screenWidth * 0.01),
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
                                            fontSize: screenWidth * 0.01),
                                      )),
                                    );
                                  });
                            },
                          ),
                          SizedBox(
                            width: 80,
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
              ? double.parse(receivedAmount) - widget.total
              : 0.0;

          // Get.back(result: field1);
        }),
        child: Container(
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
            )),
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
                : widget.total.toString();

            log(receivedAmount);

            balanceAmount = receivedAmount.isNotEmpty
                ? double.parse(receivedAmount) - widget.total
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
                '${paymentList[index]}',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
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

  List<SplitBill> getList() {
    List<SplitBill> list = [];

    double val1 = widget.total / splitBillCount;
    double val2 = widget.total / splitBillCount;

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

  void getPaymentList() {
    paymentList.add("Cash");
    paymentList.add("Card");
    paymentList.add("Benefit Pay");
  }
}
