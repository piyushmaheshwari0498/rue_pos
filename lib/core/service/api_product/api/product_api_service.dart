import 'dart:convert';
import 'dart:typed_data';

import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/api_product/model/api_product.dart';
import 'package:nb_posx/core/service/api_product/model/product_common_response.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import '../../../../../database/models/product.dart' as hvpro;
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/option.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/utils/helper.dart';
import 'dart:convert' as convert;
import 'dart:developer';

import 'package:http/http.dart' as http;

class ProductService {
  static Future<ProductCommanResponse> getProducts() async {
  /*  if (!_isValidUrl(url)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }*/
    final Map<String, String> jsonbody = {'BranchId': '15'};
    
    //Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();

    late List<hvpro.Product> product = [];
      List<Attribute> attributeList = [];

    if (isInternetAvailable) {
      //Login api url from api_constants

      final res = await http.post(
      Uri.parse(PRODUCT_PATH),
      body: jsonEncode(jsonbody),
      headers: {"Content-Type": "application/json"},
    );
  
      //API success
      if (res.statusCode == 200) {

       var body =  convert.jsonDecode(res.body);

      //Parsing the login response
      List<Product> data = (body['Product'] as Iterable)
          .map((dynamic item) => Product.fromJson(item))
          .toList(); 

          //  log("Product Api calling....");

          // log(data.toString());
        //Return the Success Login Response


         if (data.isNotEmpty) {
        for (var productData in data) {
          final Uint8List empty = Uint8List(0);

          List<Option> listaddonTopping = [];
          List<Attribute> proaddon = [];
          for (int p = 0; p < productData.tbProduct!.length; p++) {
            for (int j = 0;
                j < productData.tbProduct![p].tbProductTopping!.length;
                j++) {
              listaddonTopping.add(Option(
                  id: productData.tbProduct![p].tbProductTopping![j].id
                      .toString(),
                  name: productData.tbProduct![p].tbProductTopping![j].name ?? "",
                  price: productData.tbProduct![p].tbProductTopping![j].rate ?? 0,
                  selected: false,
                  tax: productData.tbProduct![p].taxPercentage ?? 0));
            }
            proaddon.add(Attribute(
                id: productData.tbProduct![p].id ?? 0,
                name: productData.tbProduct![p].headEnglish ?? "",
                type: "Multiselect",
                moq: productData.tbProduct![p].qty,
                options: listaddonTopping,
                toppingId: 0,
                qty: 0,
                rate: productData.tbProduct![p].rate!));
          }

          attributeList.addAll(proaddon);

          hvpro.Product orderItem = hvpro.Product(
              id: productData.id ?? 0,
              name: productData.english!,
              group: "",
              description: "",
              stock: 0,
              price: 0,
              attributes: proaddon,
              productImage: "",
              productUpdatedTime: DateTime.now(),
              tax: 0,
              taxCode: "",
              catmainid: 0,
              subcatid: 0);
          // var item = OrderItem.fromJson(products[index].toString());

          product.add(orderItem);
        }

        // await DbProduct().addProducts(product);

        // products = apiProResponse.data1!;

        // product = await DbProduct().getAllProducts();
      }

        return ProductCommanResponse(
            status: res.statusCode,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS,
            data1: data);
      }

      //API Failure
      else {
        //Return the Failure Login Response
        return ProductCommanResponse(
            status: res.statusCode,
            message: FAILURE_OCCURED,
            apiStatus: ApiStatus.REQUEST_FAILURE,
            data1: List.empty());
      }
    }

    //If internet is not available
    else {
      return ProductCommanResponse(
          status: 0,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET,
          data1: List.empty());
    }
  }

  //MARK: Get Product List api
  Future<ApiProduct> getAllProducts({required String branchId}) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    final finalUrl = Uri.parse(
        '${RUE_BASE_PATH}${PRODUCT_PATH}');

    print(finalUrl);
    print(branchId);
    final response = await http.post(finalUrl,
        headers: _header,
        body: jsonEncode(<String, dynamic>{
          "BranchId": branchId,
        }));
    print(response.body);
    print("requestAllProducts ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      var productsModel = ApiProduct.fromJson(jsonMap);
      print('${PRODUCT_PATH} ${productsModel.toJson()}');


      return ApiProduct.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load');
    }
  }



}
