import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;

import '../../../../utils copy/helpers/sync_helper.dart';
import '../../../tablet/login/login_landscape2.dart';
import '../model/addAndWithdrawCash.dart';
import '../model/closeDay.dart';


class CashierApiService{
  //MARK: Add Cash API
  Future<AddWithdrawCash> insCash(
      {required String apiString,
        required String amount,
        required String branchId,
        required String userId,
        required String remarks,
        required String counterId}) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${WITHDRAW_CASH}?BranchId=$branchId&UserId=$userId&CounterId=$counterId&Amount=$amount&Remarks=$remarks');
    final response = await http.post(
      finalUrl,
      headers: _header,
    );
    print('Final Url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var addWithdrawCash = AddWithdrawCash.fromJson(jsonMap);
      print('$apiString ${addWithdrawCash.toJson()}');

      return AddWithdrawCash.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Close Day API
  Future<Closeday> closeDay({
    required String amount,
    required String branchId,
    required String userId,
    required String counterId,
    required String bD20,
    required String bD10,
    required String bD5,
    required String bD1,
    required String fils500,
    required String fils100,
    required String fils50,
    required String fils25,
    required String fils10,
    required String fils5,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final Map<String, String> jsonbody = {
      'BranchId': branchId.toString(),
      'UserId': userId,
      'CounterId': counterId,
      'Amount': amount.toString(),
      'BD20': bD20,
      'BD10': bD10,
      'BD5': bD5,
      'BD1': bD1,
      'Fils500': fils500,
      'Fils100': fils100,
      'Fils50': fils50,
      'Fils25': fils25,
      'Fils10': fils10,
      'Fils5': fils5,
    };

    Uri url = Uri();
      url = Uri.parse(CLOSE_DAY);
    final response = await http.post(
      url,
      body: jsonEncode(jsonbody),
      headers: _header,
    ).timeout(
        const Duration(seconds: 40) );

    print('Final Url $url');
    print('Final jsonbody $jsonbody');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      print('Close day api service class $jsonMap');
      // var addWithdrawCash = AddWithdrawCash.fromJson(jsonMap);
      // print('Close day api service class ${addWithdrawCash.toJson()}');

      return Closeday.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AddWithdrawCash> startDay({
    required String amount,
    required String branchId,
    required String userId,
    required String counterId,
    required String remarks,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final Map<String, String> jsonbody = {
      'BranchId': branchId.toString(),
      'UserId': userId,
      'CounterId': counterId,
      'OpBal': amount.toString(),
      'Remarks': remarks,
    };
    // final finalUrl = Uri.parse(
    //     '${CLOSE_DAY}?BranchId=$branchId&UserId=$userId&CounterId='
    //         '$counterId&Amount=$amount&BD20=$bD20&BD10=$bD10&BD5='
    //         '$bD5&BD1=$bD1&Fils500=$fils500&Fils100=$fils100&Fils50='
    //         '$fils50&Fils25=$fils25&Fils10=$fils10&Fils5=$fils5');
    Uri url = Uri();
    url = Uri.parse(START_SHIFT_DAY);
    final response = await http.post(
      url,
      body: jsonEncode(jsonbody),
      headers: _header,
    ).timeout(
        const Duration(seconds: 40) );

    print('Final Url $url');
    print('Final jsonbody $jsonbody');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      print('Close day api service class $jsonMap');
      var addWithdrawCash = AddWithdrawCash.fromJson(jsonMap);
      // print('Close day api service class ${addWithdrawCash.toJson()}');
      // await SyncHelper().logoutFlow();
      // Get.offAll(() => const LoginLandscape2());
      return AddWithdrawCash.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

}