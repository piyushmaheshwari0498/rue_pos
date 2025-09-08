import 'dart:convert';

import 'package:nb_posx/core/service/api_cancel_order/model/cancel_order_response.dart';
import 'package:nb_posx/core/service/api_deliveryservice/model/delivery_service.dart';

import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;

class CancelOrderApiService{

  //MARK: Get Printers List api
  Future<CancelOrderResponse> cancel_order({
    required int orderId,
    required String remark,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '$CANCEL_ORDER?DirectOrdId=$orderId&Comments=$remark');
    final response = await http.post(
      finalUrl,
      headers: _header,
    );
    // print('get printers final url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var printerListModel = CancelOrderResponse.fromJson(jsonMap);
      // print('${GET_Printers} ${printerListModel.toJson()}');
      return CancelOrderResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

}