import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/api_table/model/table_model.dart';
import 'package:nb_posx/core/service/category/model/categories.dart';
import 'package:nb_posx/core/service/category/model/category_comman_response.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';

import '../model/stock_comman_response.dart';
import '../model/stock_model.dart';


class StockService {
  static Future<StockCommanResponse> getStock(String id) async {
    final isInternetAvailable = await Helper.isNetworkAvailable();
    final Uri url = Uri.parse("$STOCK_PATH?id=$id");

    if (!isInternetAvailable) {
      return StockCommanResponse(
          status: 0,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET,
          data1: []);
    }

    try {
      final res = await http.get(url, headers: {"Content-Type": "application/json"});

      print('Stock_data URL: $url');
      print('Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        final List<Product> data = (body['Product'] as List)
            .map((item) => Product.fromJson(item))
            .toList();

        for (var p in data) {
          print('Parsed: $p');
        }

        return StockCommanResponse(
          status: res.statusCode,
          message: SUCCESS,
          apiStatus: ApiStatus.REQUEST_SUCCESS,
          data1: data,
        );
      } else {
        print('Stock_data: $FAILURE_OCCURED');
        return StockCommanResponse(
          status: res.statusCode,
          message: FAILURE_OCCURED,
          apiStatus: ApiStatus.REQUEST_FAILURE,
          data1: [],
        );
      }
    } catch (e) {
      print('Error fetching stock: $e');
      return StockCommanResponse(
        status: 0,
        message: 'Exception occurred',
        apiStatus: ApiStatus.REQUEST_FAILURE,
        data1: [],
      );
    }
  }
  
}
