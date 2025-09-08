import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/core/service/api_sales/model/orderDetailsModel.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../service/api_sales/api/api_sales_service.dart';

class Receiptdata extends StatefulWidget {
  int sales_id;

  Receiptdata({Key? key, required this.sales_id}) : super(key: key);

  @override
  State<Receiptdata> createState() => _ReceiptState();
// TODO: implement createState
}

class _ReceiptState extends State<Receiptdata> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []); // 🔥 Hide status bar
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge); // ✅ Restore on exit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          // backgroundColor: const Color.fromRGBO(139, 143, 124, 40.0),
          title: Text(
            'Receipt',
            style: getTextStyle(
                fontSize: Device.get().isTablet
                    ? LARGE_PLUS_FONT_SIZE
                    : MEDIUM_PLUS_FONT_SIZE,
                color: BLACK_COLOR),
          ),
        ),
        body: receiptColumn());
  }

  late Future<OrderDetailsModel> futureOrderDetails;
  OrderDetailsModel? orderDetailsModel;
  late int tappedIndex = 0;
  int id = -1;
  int totalQty = 0;

  Widget receiptColumn() {
    return Column(
      // Keeps buttons fixed at the top
      children: [
        // Fixed Buttons Row
        Container(
          // height: MediaQuery.of(context).size.height * 0.80,
          color: Colors.grey[200],
          // Background color
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // Padding for spacing
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 50,
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
                          fontSize: MEDIUM_MINUS_FONT_SIZE),
                    ),
                    icon: const Icon(Icons.print_rounded,
                        size: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 50,
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
                          fontSize: MEDIUM_MINUS_FONT_SIZE),
                    ),
                    icon: const Icon(Icons.cancel_outlined,
                        size: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                left: 30,
                right: 30,
              ),
              child: Material(
                // ✅ This line fixes the error
                color: Colors.white,
                child: Container(
                  width: Device.get().isTablet
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width - 20,
                  child: getOrderDetails('${widget.sales_id}'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getOrderDetails(String idd) {
    print("Sales Id ${idd}");
    late final repeatCount = 0;
    if (idd != "-1") {
      return SingleChildScrollView(
          child: FutureBuilder<OrderDetailsModel>(
              future: SalesService()
                  .getOrderDetailsById(OrderType: 'Direct', id: idd),
              builder: (context, snapshot) {
                // print("getOrderDetailsById ${snapshot.data.toString()}");
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
                            fontWeight: FontWeight.bold,
                            fontSize: LARGE_MINUS20_FONT_SIZE),
                      ),
                      Text(
                        'Al Janabiyah',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MEDIUM_MINUS_FONT_SIZE),
                      ),
                      Text(
                        'Kingdom of Bahrain',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MEDIUM_MINUS_FONT_SIZE),
                      ),
                      Text(
                        '39399090',
                        style: getTextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MEDIUM_MINUS_FONT_SIZE),
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
                                'Order Date : ${orderDetailsModel?.orderList?[0].ordDate}',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                              Text(
                                'Delivery Date : ${orderDetailsModel?.orderList?[0].ordNo}',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                              Text(
                                'Order Type : ${orderDetailsModel?.orderList?[0].orderType}',
                                style: getTextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0),
                              ),
                              Text(
                                'Server : ',
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
                                  flex: 3, // 75% of the space
                                  child: Text(
                                    'Description',
                                    style: getTextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0),
                                  ),
                                ),
                                // Qty gets less space
                                Expanded(
                                  flex: 1, // 25% of the space
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Qty',
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
                            /*ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 3, // 75% of the space for description
                                    child: Text(
                                      '${orderDetailsModel?.orderList?[0].orderDtl?[i].description}',
                                      softWrap: true,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: getTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1, // 25% for qty
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${orderDetailsModel?.orderList?[0].orderDtl?[i].qty}',
                                        style: getTextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Main Row: description + qty
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${orderDetailsModel?.orderList?[0].orderDtl?[i].description}',
                                          softWrap: true,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: getTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${orderDetailsModel?.orderList?[0].orderDtl?[i].qty}',
                                            style: getTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  // Toppings list (if available and not empty)
                                  if ((orderDetailsModel?.orderList?[0].orderDtl?[i].tbDirectOrderTopping ?? []).isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: orderDetailsModel!
                                          .orderList![0]
                                          .orderDtl![i]
                                          .tbDirectOrderTopping!
                                          .where((topping) => topping.status == true) // ✅ filter only active toppings
                                          .map<Widget>((topping) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 12.0, top: 2.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  topping.name ?? '',
                                                  style: getTextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'x${topping.qty}',
                                                  style: getTextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey[700],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  '${topping.rate}',
                                                  style: getTextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey[700],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                ],
                              ),
                            ),
                          dots,
                        ],
                      ),
                      Text(
                        'Total Item(s) ${totalQty}.0',
                        style: getTextStyle(
                            fontWeight: FontWeight.w500, fontSize: 30.0),
                      ),
                      dots,
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

  Widget get dots {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Rough estimate: assume each '..' takes about 10 pixels width
        final repeatCount = (constraints.maxWidth / 10).floor();
        return Text(
          List.generate(repeatCount, (_) => '..').join(),
          style: TextStyle(fontSize: 16), // optional styling
        );
      },
    );
  }
}
