import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_posx/configs/theme_config.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../service/api_orders/api/api_order_service.dart';
import '../../../../service/api_sales/model/orderDetailsModel.dart';

class DetailCurrentOrdersLandscape extends StatefulWidget {
  final String orderNo;
  final int orderId;
  final String customerName;
  final String orderType;

  final double sub_total, discount, tax, total, cash, due;

  const DetailCurrentOrdersLandscape({
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

class DetailCurrentOrderState extends State<DetailCurrentOrdersLandscape> {
  OrderDetailsModel? orderDetailsModel;
  late List<OrderDtl> listOrders = [];
  double sub_total = 0,
      discount = 0,
      tax = 0,
      total = 0,
      tender_amount = 0,
      change_due = 0;

  @override
  void initState() {
    super.initState();
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
                            fontSize: LARGE_PLUS_FONT_SIZE,
                            color: BLACK_COLOR),
                      ),
                      if (orderDetailsModel!.orderList![0].tableNo == null)
                        Text(
                          '${orderDetailsModel!.orderList![0].ordNo} ',
                          style: getTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: LARGE_PLUS_FONT_SIZE,
                              color: BLACK_COLOR),
                        )
                      else
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
          return
            Container(
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
}
