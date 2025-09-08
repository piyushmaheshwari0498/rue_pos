import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/category/model/categories.dart';
import 'package:nb_posx/core/service/category/model/category_comman_response.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';

class CategoryService {
  static Future<CategoryCommanResponse> getCategory() async {
  /*  if (!_isValidUrl(url)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }*/
    
    //Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();

    if (isInternetAvailable) {
      //Login api url from api_constants

      final res = await http.get(Uri.parse(CATEGORY_PATH));
  
      //API success
      if (res.statusCode == 200) {

       var body =  convert.jsonDecode(res.body);

      //Parsing the login response
      List<Category> data = (body['Category'] as Iterable)
          .map((dynamic item) => Category.fromJson(item))
          .toList(); 

          log('APi calling ${data.toString()}');
        //Return the Success Login Response
        return CategoryCommanResponse(
            status: res.statusCode,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS,
            data1: data);
      }

      //API Failure
      else {
        //Return the Failure Login Response
        return CategoryCommanResponse(
            status: res.statusCode,
            message: FAILURE_OCCURED,
            apiStatus: ApiStatus.REQUEST_FAILURE,
            data1: List.empty());
      }
    }

    //If internet is not available
    else {
      return CategoryCommanResponse(
          status: 0,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET,
          data1: List.empty());
    }
  }

  //MARK: Get Category List api
  Future<Categories> getCategoryList() async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl =
    Uri.parse('$RUE_BASE_PATH$CATEGORY_PATH');
    final response = await http.get(finalUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('${CATEGORY_PATH} ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Categories.fromJson(jsonMap);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


}
