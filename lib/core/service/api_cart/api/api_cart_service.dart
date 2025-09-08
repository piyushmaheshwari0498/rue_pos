import 'dart:convert';

import '../../../../database/models/order_item.dart';
import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;

import '../model/cart_data.dart';
import '../model/cart_response.dart';

class CartApiService {
  //MARK: Insert TakeAway Order API

  Future<CartResponse> insCartTakeAway({
    required String branchId,
    required String counterId,
    required String clientId,
    required String payStatus,
    required String modeOfPay,
    required String status,
    required String orderStatus,
    required String createrId,
    required double subTotal,
    required double taxAmount,
    required double discountAmount,
    required double netAmount,
    required double balanceAmt,
    required double tenderAmount,
    required List<TbDirectOrderDet> orderItem,
    required List<TbDirectOrderPayment> paymentItem,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    var body = jsonEncode(<String, dynamic>{
      "AhlanFlag": 0,
      "AuthToken": "",
      "ClientId": clientId,
      "SubTotal": subTotal,
      "TaxAmount": taxAmount.toInt(),
      "Discount": discountAmount,
      "NetAmount": netAmount,
      "BalanceAmount": balanceAmt,
      "PayStatus": payStatus,
      "CreaterId": createrId,
      "ModifiedBy": createrId,
      "BranchId": branchId,
      "CounterId": counterId,
      "ModeOfPay": modeOfPay,
      "Status": status,
      "TenderAmount": tenderAmount,
      "OrderStatus": orderStatus,
      "DeliveryType": "2",
      "ShippingCharge": "0.000",
      "tb_DirectOrderDet": orderItem,
      "tb_DirectOrderPayment": paymentItem,
    });

    final finalUrl = Uri.parse(INSERT_CART_TAKEAWAY
    );
    final response = await http.post(finalUrl,
        headers: _header,
        body: body
        );
    print('Final Url $finalUrl');
    print('Final Url res $body');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var insertTakeAwayOrder = CartResponse.fromJson(jsonMap);
      print('insertTakeAwayOrder ${insertTakeAwayOrder.toJson()}');

      return CartResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<CartResponse> insCartDineOrder({
    required int TableId,
    required int TableLocationId,
    required int DirectOrdId,
    required String branchId,
    required String counterId,
    required String clientId,
    required String payStatus,
    required String modeOfPay,
    required String status,
    required String orderStatus,
    required String createrId,
    required double subTotal,
    required double taxAmount,
    required double discountAmount,
    required double netAmount,
    required double balanceAmt,
    required double tenderAmount,
    required List<TbDirectOrderDet> orderItem,
    required List<TbDirectOrderPayment> paymentItem,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    var body = jsonEncode(<String, dynamic>{
      // "AhlanFlag": 0,
      "AuthToken": "",
      "SubTotal": subTotal,
      "TaxAmount": taxAmount.toInt(),
      "OrderType": "0",
      "DeliveryType": "0",
      "Discount": discountAmount,
      "NetAmount": netAmount,
      "TableId": TableId,
      "VechicleNo": "",
      "OrderStatus": orderStatus,
      "PayStatus": payStatus,
      "Status": status,
      "CreaterId": createrId,
      "ModifiedBy": createrId,
      "BranchId": branchId,
      "CounterId": counterId,
      "tb_DirectOrderDet": orderItem,
      "DirectOrdId": DirectOrdId,

      // "ClientId": clientId,
      // "BalanceAmount": balanceAmt,
      // "ModeOfPay": modeOfPay,
      // "TenderAmount": tenderAmount,
      // "DeliveryType": "2",
      // "ShippingCharge": "0.000",
      // "tb_DirectOrderPayment": paymentItem,
      // "TableLocationId": TableLocationId,
    });

    final finalUrl = Uri.parse(INSERT_CART_DINESAVE);
    final response = await http.post(finalUrl,
        headers: _header,
        body: body
    );
    print('Final Url $finalUrl');
    print('Final Url res $body');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var insertTakeAwayOrder = CartResponse.fromJson(jsonMap);
      print('insertDineOrder ${insertTakeAwayOrder.toJson()}');

      return CartResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<CartResponse> insCartPOS({
    required String branchId,
    required int deliveryId,
    required String counterId,
    required String clientId,
    required String payStatus,
    required String modeOfPay,
    required String status,
    required String orderStatus,
    required String createrId,
    required double subTotal,
    required double taxAmount,
    required double deliveryAmount,
    required double discountAmount,
    required double netAmount,
    required double balanceAmt,
    required double tenderAmount,
    required List<TbDirectOrderDet> orderItem,
    required List<TbDirectOrderPayment> paymentItem,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    var body = jsonEncode(<String, dynamic>{
      "AhlanFlag": 0,
      "AuthToken": "",
      "ClientId": clientId,
      "SubTotal": subTotal,
      "TaxAmount": taxAmount.toInt(),
      "Discount": discountAmount,
      "NetAmount": netAmount,
      "BalanceAmount": balanceAmt,
      "PayStatus": payStatus,
      "CreaterId": createrId,
      "ModifiedBy": createrId,
      "BranchId": branchId,
      "CounterId": counterId,
      "ModeOfPay": modeOfPay,
      "Status": status,
      "TenderAmount": tenderAmount,
      "OrderStatus": orderStatus,
      "DeliveryType": "2",
      "DeliveryId": deliveryId == 0 ? null : deliveryId,
      "ShippingCharge": deliveryAmount,
      "tb_DirectOrderDet": orderItem,
      "tb_DirectOrderPayment": paymentItem,
    });

    final finalUrl = Uri.parse(INSERT_CART_TAKEAWAY
    );
    final response = await http.post(finalUrl,
        headers: _header,
        body: body
    );
    print('Final Url $finalUrl');
    print('Final Url res $body');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var insertTakeAwayOrder = CartResponse.fromJson(jsonMap);
      print('insertTakeAwayOrder ${insertTakeAwayOrder.toJson()}');

      return CartResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }
}
