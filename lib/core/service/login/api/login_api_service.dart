import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nb_posx/core/service/login/model/api_login_common_response.dart';
import 'package:nb_posx/core/service/login/model/api_login_response.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
import 'package:nb_posx/database/models/hub_manager.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../database/db_utils/db_instance_url.dart';
import '../model/login_response.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginService {
  
  static Future<APILoginCommanResponse> login(
      String email, String password, String url) async {
    //Check for the internet connection
    // var isInternetAvailable = await Helper.isNetworkAvailable();

    final Map<String, String> jsonbody;

    password.isNotEmpty ?
    jsonbody = {
      'UserPin': email,
       'CounterId': password
    }
    :
    jsonbody = {
      'UserPin': email,
    };


    final Dio _dio = Dio();
    Response res;
    // if (isInternetAvailable) {
      //Login api url from api_constants

      // log('UserPin :: $email');
      // log('Counterid :: $password');
      try {
        res = await _dio.post(
          RUE_LOGIN_PATH,
          data: jsonEncode(jsonbody),
          options: Options(headers: {"Content-Type": "application/json"}),
        ).timeout(
          const Duration(seconds: 40) );


        log('LOGIN_API PATH:: $RUE_LOGIN_PATH');
        if (res.statusCode == 200 && res.data["Status"] == 1) {
          DBPreferences dbPreferences = DBPreferences();
          //
          log('LOGIN_API isCashier:: ${res.data["NewCashierLogin"]}');
          log('LOGIN_API API UserData:: ${res.data["userdata"]}');
          // log('userDataList :: ${res.data["userdata"]["UserName"]}');
          await dbPreferences.savePreference(ApiKey, res.data["Token"]);
          await dbPreferences.savePreference(ApiSecret, res.data["Token"]);
          await dbPreferences.savePreference(
              HubManagerId, '${res.data["userdata"]["id"]}');
          await dbPreferences.savePreference(
              isNewCashierLogin, res.data["NewCashierLogin"]);
          log('LOGIN_API API NewCashierLogin:: res.data["NewCashierLogin"]}');
          await dbPreferences.savePreference(
              HubUsername, res.data["userdata"]["UserName"]);

          //Saving API Key and API secret in database.
          //Return the Success Login Response
          return APILoginCommanResponse(
              status: true,
              message: SUCCESS,
              apiStatus: ApiStatus.REQUEST_SUCCESS,
              response: res);
        }

        //API Failure
        else {
          //Return the Failure Login Response
          return APILoginCommanResponse(
              // ignore: dead_code
              status: res.data["Status"] == 1 ? true : false,
              message: res.data["Message"],
              apiStatus: ApiStatus.REQUEST_FAILURE,
              response: res);
        }
      } catch (e) {
        print(e);

        if (e is SocketException) {
          // ignore: unrelated_type_equality_checks
          if ((e).osError == 7) {
            print('***** Exception Caught *****');
          }
        }

        return APILoginCommanResponse.fromp(
          status: false,
          message: e.toString(),
          apiStatus: ApiStatus.REQUEST_FAILURE,
        );
      }
    
    // }
    //
    // //If internet is not available
    // else {
    //   return APILoginCommanResponse.fromp(
    //     status: false,
    //     message: NO_INTERNET,
    //     apiStatus: ApiStatus.NO_INTERNET,
    //   );
    // }
  }

  ///Function to check whether email is in correct format or not.
  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  ///Function to check whether password is in correct format or not.
  static bool isValidPassword(String password) {
    String regex =
        (r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
    return RegExp(regex).hasMatch(regex);
  }

  ///Function to check whether the input URL is valid or not
  static bool _isValidUrl(String url) {
    // Regex to check valid URL
    String regex =
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";

    return RegExp(regex).hasMatch(url);
  }
}
