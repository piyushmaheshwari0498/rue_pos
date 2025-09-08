import 'dart:convert';

import '../../../../network/api_constants/api_paths.dart';
import '../model/orderDetailsModel.dart';
import 'package:http/http.dart' as http;

import '../model/todaySalesModel.dart';

class SalesService {

  //MARK: Get Order Details By Id api
  Future<OrderDetailsModel> getOrderDetailsById({
    required String OrderType,
    required String id,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${SALES_PATH}');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{"OrderType": OrderType, "id": id}));

    if (response.statusCode == 200) {
      print('${SALES_PATH} ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      print('ANiket ${jsonMap.toString()}');
      try {
        return OrderDetailsModel.fromJson(jsonMap);
      } catch (e) {
        print('inside catch _ api getdetails by id $e');
        return OrderDetailsModel.fromJson(jsonMap);
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  //MARK: Get Today Sales List api
  Future<TodaySalesModel> getTodaySales(
      {required String branchId,
        required String userId,
        required String counterId}) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${TODAY_SALES_PATH}?BranchId=$branchId&UserId=$userId&CounterId=$counterId');
    final response = await http.get(
      finalUrl,
      headers: _header,
    );

    print(finalUrl);

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var todaySalesModel = TodaySalesModel.fromJson(jsonMap);
      print('${TODAY_SALES_PATH} ${todaySalesModel.toJson()}');
      return TodaySalesModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }


}