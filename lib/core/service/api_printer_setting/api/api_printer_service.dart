import 'dart:convert';

import '../../../../network/api_constants/api_paths.dart';
import 'package:http/http.dart' as http;

import '../model/categoryAllocated.dart';
import '../model/insertCategoryAllocate.dart';
import '../model/printerList.dart';
import '../model/productAllocated.dart';



class PrinterApiService{

  //MARK: Get Printers List api
  Future<PrinterList> getPrinters({
    required String branchId,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        // '${GET_Printers}?BranchId=14');
        '${GET_Printers}?BranchId=$branchId');
    final response = await http.get(
      finalUrl,
      headers: _header,
    );
    print('get printers final url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var printerListModel = PrinterList.fromJson(jsonMap);
      print('${GET_Printers} ${printerListModel.toJson()}');
      return PrinterList.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Get allocated categories List api
  Future<GetCategoryAllocate> getAlocatedCategories({
    required String branchId,
    required String counterId,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${GET_CategoryAllocate}?BranchId=$branchId&CounterId=$counterId');
    final response = await http.get(
      finalUrl,
      headers: _header,
    );
    print('get allocated categories final url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var printerListModel = GetCategoryAllocate.fromJson(jsonMap);
      print('${GET_CategoryAllocate} ${printerListModel.toJson()}');
      return GetCategoryAllocate.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Insert Category Allocate API
  Future<InsertCategoryAllocate> insCategoryAllocate({
    required String branchId,
    required String counterId,
    required String categoryId,
    required String locationId,
    required String locationId1,
    required String createrId,
    required String modifiedBy,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${INSERT_CategoryAllocate}?BranchId=$branchId&CategoryId=$categoryId&CounterId=$counterId&LocationId=$locationId&LocationId1=$locationId1&CreaterId=$createrId&ModifiedBy=$modifiedBy');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "BranchId": branchId,
          "CategoryId": categoryId,
          "CounterId": counterId,
          "LocationId": locationId,
          "LocationId1": locationId1,
          "CreaterId": createrId,
          "ModifiedBy": modifiedBy,
        }));
    print('Final Url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var addWithdrawCash = InsertCategoryAllocate.fromJson(jsonMap);
      print('insCategoryAllocate ${addWithdrawCash.toJson()}');

      return InsertCategoryAllocate.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Insert Product Allocate API
  Future<InsertCategoryAllocate> insProductAllocate({
    required String branchId,
    required String counterId,
    required String productId,
    required String locationId,
    required String locationId1,
    required String createrId,
    required String modifiedBy,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${INSERT_ProductAllocate}?BranchId=$branchId&ProductId=$productId&CounterId=$counterId&LocationId=$locationId&LocationId1=$locationId1&CreaterId=$createrId&ModifiedBy=$modifiedBy');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "BranchId": branchId,
          "ProductId": productId,
          "CounterId": counterId,
          "LocationId": locationId,
          "LocationId1": locationId1,
          "CreaterId": createrId,
          "ModifiedBy": modifiedBy,
        }));
    print('Final Url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var addWithdrawCash = InsertCategoryAllocate.fromJson(jsonMap);
      print('insCategoryAllocate ${addWithdrawCash.toJson()}');

      return InsertCategoryAllocate.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Get allocated Producta List api
  Future<GetproductAllocated> getAlocatedProducts({
    required String branchId,
    required String counterId,
  }) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${GET_ProductAllocate}?BranchId=$branchId&CounterId=$counterId');
    final response = await http.get(
      finalUrl,
      headers: _header,
    );
    print('get allocated categories final url $finalUrl');
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      // var printerListModel = GetCategoryAllocate.fromJson(jsonMap);
      // print('${GET_ProductAllocate} ${printerListModel.toJson()}');
      return GetproductAllocated.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Delete Allocated categoried
  Future<InsertCategoryAllocate> delAllocatedCategory(
      {required String apiString, required String catId}) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse('${DELETE_CategoryAllocate}?id=$catId');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "id": catId,
        }));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var insertCategoryAllocate = InsertCategoryAllocate.fromJson(jsonMap);
      print(
          '${DELETE_CategoryAllocate} ${insertCategoryAllocate.toJson()}');
      return InsertCategoryAllocate.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }

  //MARK: Delete Allocated Product
  Future<InsertCategoryAllocate> delAllocatedProduct(
      {required String apiString, required String catId}) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse('${DELET_ProductAllocate}?id=$catId');
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "id": catId,
        }));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      // var insertCategoryAllocate = InsertCategoryAllocate.fromJson(jsonMap);
      // print(
      //     '${DELET_ProductAllocate} ${insertCategoryAllocate.toJson()}');
      return InsertCategoryAllocate.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }



}