import 'dart:convert';

import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;

import '../model/AllBranchModel.dart';
import '../model/counterModel.dart';
import '../model/locationModel.dart';
import '../model/tableLocationModel.dart';

class CommonApiService{

  //MARK: Get Location List api
  Future<LocationModel> getLocationList(String branchId) async {
    final finalUrl = Uri.parse('$LOCATION_PATH?BranchId=$branchId');
    print("Calling URL: $finalUrl");

    final response = await http.get(finalUrl);

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return LocationModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load location list');
    }
  }


  Future<TableLocationModel> getTableLocationList(
      String branchId,
      ) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '$TABLE_LOCATION_PATH?BranchId=$branchId');
    // final response = await http.get(finalUrl);
    final Map<String, String> jsonbody = {'BranchId': branchId};
    final response = await http.post(
      Uri.parse(TABLE_LOCATION_PATH),
      body: jsonEncode(jsonbody),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('$LOCATION_PATH/$branchId ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TableLocationModel.fromJson(jsonMap);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //MARK: Get Branch List api
  Future<AllBranchModel> getBranchList(
      String deviceLogId,
      String employeeId,
      String eeviceId,
      String eogDate,
      String c1,
      String workCode,
      String createdDate) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${BRANCH_PATH}?DeviceLogId=$deviceLogId&employeeId=$employeeId&eeviceId=$eeviceId&eogDate=$eogDate&c1=$c1&workCode=$workCode&createdDate=$createdDate');
    final response = await http.get(finalUrl);

    print(finalUrl);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('${APIConstants.getBrances} ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return AllBranchModel.fromJson(jsonMap);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //MARK: Get Counter List api
  Future<CounterModel> getCounterList(
      String branchId,
      String deviceLogId,
      String employeeId,
      String eeviceId,
      String eogDate,
      String c1,
      String workCode,
      String createdDate) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${COUNTER_PATH}?BranchId=$branchId');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "DeviceLogId": deviceLogId,
          "EmployeeId": employeeId,
          "EeviceId": eeviceId,
          "EogDate": eogDate,
          "C1": c1,
          "WorkCode": workCode,
          "CreatedDate": createdDate
        }));

    if (response.statusCode == 200) {
      // print('${APIConstants.getCounters} ${response.body}');
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return CounterModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load album');
    }
  }

}