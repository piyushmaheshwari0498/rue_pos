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

import '../model/table_comman_response.dart';

class TableService {
  static Future<TableCommanResponse> getTable(String branchId) async {
  /*  if (!_isValidUrl(url)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }*/
    
    //Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();
    final Map<String, String> jsonbody = {'BranchId': branchId};
    if (isInternetAvailable) {
      //Login api url from api_constants

      // final res = await http.get(Uri.parse(TABLE_PATH));
      http.Response res = await http.post(
        Uri.parse(TABLE_PATH),
        body: jsonEncode(jsonbody),
        headers: {"Content-Type": "application/json"},
      );
      //API success
      if (res.statusCode == 200) {

       var body =  convert.jsonDecode(res.body);

      //Parsing the login response
      List<Table> data = (body['Table'] as Iterable)
          .map((dynamic item) => Table.fromJson(item))
          .toList(); 

          print('APi calling ${data.toString()}');
          print('APi calling ${jsonbody.toString()}');
        //Return the Success Login Response
        return TableCommanResponse(
            status: res.statusCode,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS,
            data1: data,
        tableCount: body['TableCount'],
        freeTable: body['FreeTable'],
        busyTable: body['BusyTable']);
      }

      //API Failure
      else {
        //Return the Failure Login Response
        return TableCommanResponse(
            status: res.statusCode,
            message: FAILURE_OCCURED,
            apiStatus: ApiStatus.REQUEST_FAILURE,
            data1: List.empty());
      }
    }

    //If internet is not available
    else {
      return TableCommanResponse(
          status: 0,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET,
          data1: List.empty());
    }
  }

  
}
