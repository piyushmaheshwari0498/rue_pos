import 'dart:convert';

import '../../../../network/api_constants/api_paths.dart';
import '../../api_sales/model/orderDetailsModel.dart';
import '../model/CurrentOrdersModel.dart';
import 'package:http/http.dart' as http;

class OrdersApiService {
  //MARK: Get order details api
  Future<CurrentOrdersModel> getAllOrders(int indTapped, String branchId,
      String userId, String counterNo, String status) async {
    Map<String, String> qParams = {
      'UserId': userId,
      'BranchId': branchId,
      'CounterNo': counterNo,
      'Status': status,
    };
    Map<String, String> _header = {'Content-Type': 'application/json'};
    // {'Content-Type': 'application/json'}
    Uri url = Uri();
    if (indTapped == 1) {
      url = Uri.parse(
          // '${ALL_ORDERS_PATH}?BranchId=$branchId&Status=$status&UserId=$userId&CounterNo=$counterNo}');
          ALL_ORDERS_PATH);
    } else if (indTapped == 2) {
      url = Uri.parse(
          // '${PICKUP_ORDERS_PATH}?BranchId=$branchId&Status=$status&UserId=$userId&CounterNo=$counterNo}');
          PICKUP_ORDERS_PATH);
    } else if (indTapped == 3) {
      url = Uri.parse(
          // '${ALL_ORDERS_PATH}?BranchId=$branchId&Status=$status&UserId=$userId&CounterNo=$counterNo}');
          ALL_ORDERS_PATH);
    } else if (indTapped == 4) {
      url = Uri.parse(
          // '${OPEN_ORDERS_PATH}?BranchId=$branchId&Status=$status&UserId=$userId&CounterNo=$counterNo}');
          OPEN_ORDERS_PATH);
    } else if (indTapped == 5) {
      url = Uri.parse(
          // '${CLOSE_ORDERS_PATH}?BranchId=$branchId&Status=$status&UserId=$userId&CounterNo=$counterNo}');
          CLOSE_ORDERS_PATH);
    }

    // final finalUrl = url.replace(queryParameters: qParams);
    // final finalUrl = url;
    // print(finalUrl);
    final Map<String, String> jsonbody = {
      'BranchId': branchId,
      'UserId': userId,
      'CounterNo': counterNo,
      'Status': status,
    };
    final response = await http.post(
      headers: _header,
      url,
      body: jsonEncode(jsonbody),
    ).timeout(
        const Duration(seconds: 40) );


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('api service call URL $url');
      print('api service call Param $jsonbody');
      print('api service call response ${response}');
      print('api service call data $indTapped ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return CurrentOrdersModel.fromJson(jsonMap);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //MARK: Get Order Details By Id api
  Future<OrderDetailsModel> getOrderDetailsById({
    required String OrderType,
    required String id,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse('${DETAILS_ORDERS_PATH}');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{"OrderType": OrderType, "id": id}));

    if (response.statusCode == 200) {
      print('$DETAILS_ORDERS_PATH ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      // print('ANiket ${finalUrl.toString()}');
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
}
