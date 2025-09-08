import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/app_constants.dart';
import '../model/create_sales_order_response.dart';
import '../model/sales_order_request.dart' as request_items;
import '../model/sales_order_request.dart';
import '../../../../../database/db_utils/db_parked_order.dart';

import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/sale_order.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';

class CreateOrderService {
  Future<CommanResponse> createOrder(SaleOrder order) async {
    debugPrint("Inside out:Create OrderApi calling");
    if (await Helper.isNetworkAvailable()) {
      debugPrint("Inside:Create OrderApi calling");
      List<request_items.Items> items = [];
      for (OrderItem item in order.items) {
        List<request_items.SelectedOptions> selectedOption = [];
        for (var atrib in item.attributes) {
          for (var opt in atrib.options) {
            if (opt.selected) {
              selectedOption.add(request_items.SelectedOptions(
                  id: opt.id,
                  name: opt.name,
                  price: opt.price,
                  qty: item.orderedQuantity));
            }
          }
        }

        request_items.Items i = request_items.Items(
            itemCode: item.id,
            name: item.name,
            price: item.price,
            selectedOption: selectedOption,
            orderedPrice: item.orderedPrice,
            orderedQuantity: item.orderedQuantity);
        items.add(i);
      }

      var transactionDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(order.tracsactionDateTime);
      log('Formatted Transaction Date Time :: $transactionDateTime');

      SalesOrderRequest orderRequest = SalesOrderRequest(
        hubManager: order.manager.emailId,
        // ward: "order.customer.ward.id",
        customer: order.customer.id,
        transactionDate: transactionDateTime,
        deliveryDate: _parseDate(order.tracsactionDateTime),
        items: items,
        modeOfPayment: order.paymentMethod,
        mpesaNo: order.transactionId,
      );

      var body = {'order_list': orderRequest.toJson()};

      debugPrint("createOrder ${orderRequest.toJson()}");
      debugPrint("createOrder encode ${json.encode(body)}");

      var apiResponse =
          await APIUtils.postRequest(INSERT_CART_DINESAVE, body);

      debugPrint("createOrder response ${json.encode(apiResponse)}");

      CreateSalesOrderResponse salesOrderResponse =
          CreateSalesOrderResponse.fromJson(apiResponse);
      // SyncHelper().getDetails();

      // ignore: unnecessary_null_comparison
      if (salesOrderResponse.message != null &&
          salesOrderResponse.message.successKey == 1) {
        DbParkedOrder().deleteOrderById(order.parkOrderId!);
        return CommanResponse(
            status: true,
            message: salesOrderResponse.message.salesOrder.name,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      } else {
        return CommanResponse(
            status: false,
            message: SOMETHING_WRONG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET_CREATE_ORDER_SYNC_QUEUED,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }

  String _parseDate(DateTime date) {
    var month = date.month < 10 ? "0${date.month}" : date.month;
    var day = date.day < 10 ? "0${date.day}" : date.day;
    var dateValue = '${date.year}-$month-$day';
    debugPrint('createOrder Parsed date :: $dateValue');
    return dateValue;
  }
}
