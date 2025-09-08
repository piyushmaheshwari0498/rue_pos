import 'dart:convert';

import 'package:nb_posx/core/service/api_deliveryservice/model/delivery_service.dart';

import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;




class DeliveryApiService{

  //MARK: Get Printers List api
  static Future<DeliveryResponse> getDeliveryServices() async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        // '${GET_Printers}?BranchId=14');
        '${GET_DELIVERY_SERVICE}');
    final response = await http.get(
      finalUrl,
      headers: _header,
    );
    // print('get delivery services final url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var deliveryListModel = DeliveryResponse.fromJson(jsonMap);
      // print('${GET_Printers} ${deliveryListModel.toJson()}');
      return DeliveryResponse.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }
}