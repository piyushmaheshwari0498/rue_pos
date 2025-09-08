import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/product_common_response.dart';
import 'package:nb_posx/core/service/api_cat_pro/model/apicatpromodel.dart';
import 'package:nb_posx/core/service/api_product/model/product_common_response.dart';
import 'package:nb_posx/database/db_utils/db_categories.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import 'package:nb_posx/database/db_utils/db_sub_categories.dart';
import 'package:nb_posx/database/models/api_category.dart';
import 'package:nb_posx/database/models/api_sub_category.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/option.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/utils%20copy/helper.dart';
import '../../../../../database/models/product.dart' as hvpro;

class CatProductService {
  static Future<ProductCommanResponse2> getProducts(String branchId) async {
    /*  if (!_isValidUrl(url)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }*/
    // log('Products branchId: ${branchId}\n');
    final Map<String, String> jsonbody = {'BranchId': branchId};

    //Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();

    late List<hvpro.Product> product = [];
    List<Attribute> attributeList = [];

    if (isInternetAvailable) {
      //Login api url from api_constants

      http.Response res = await http.post(
        Uri.parse(CAT_PRODUCT_PATH),
        body: jsonEncode(jsonbody),
        headers: {"Content-Type": "application/json"},
      );
      debugPrint("CATPRO API Calling : ${branchId}");
      if(branchId.isNotEmpty) {
        //API success
        if (res.statusCode == 200) {
          var body = convert.jsonDecode(res.body);

          debugPrint("CATPRO API Calling : ${body.toString()}");
          //Parsing the login response
          List<Product> data = (body['Product'] as Iterable)
              .map((dynamic item) => Product.fromJson(item))
              .toList();

          List<Category> catedata = (body['Category'] as Iterable)
              .map((dynamic item) => Category.fromJson(item))
              .toList();

          List<SubCategory> subcatedata = (body['SubCategory'] as Iterable)
              .map((dynamic item) => SubCategory.fromJson(item))
              .toList();

          await DbProduct().deleteProducts();
          await DbProduct().deleteApiProducts();
          await DbCategory().deleteAPICategoryProducts();
          await DbSubCategory().deleteAPISUBCategoryProducts();

          if (catedata.isNotEmpty) {
            // categories.add(new dbcat.APICategory(
            //   id: 0,
            //   en_name: "All",
            //   ar_name: "",
            //   seq_no: 0,
            //   image: "",
            //   main_id_no: 0));

            await DbCategory().deleteAPICategoryProducts();
            List<APICategory> categories = [];
            APICategory category = APICategory(
                id: 0,
                en_name: "All",
                ar_name: "",
                seq_no: 0,
                image: "",
                main_id_no: 0);
            categories.add(category);
            for (Category c in catedata) {
              APICategory category = APICategory(
                  id: c.id!,
                  en_name: c.name ?? "",
                  ar_name: "",
                  // seq_no: c.sequenceNo ?? 0,
                  seq_no: 0,
                  image: "",
                  main_id_no: 0);
              categories.add(category);
            }

            // log('categories  ${categories.length}');

            //Fetching data from DbProduct database
            // categories = DbCategory().getAPICategories() as List<dbcat.APICategory>;
            await DbCategory().addAPICategory(categories);
          }

          if (subcatedata.isNotEmpty) {
            // categories.add(new dbcat.APICategory(
            //   id: 0,
            //   en_name: "All",
            //   ar_name: "",
            //   seq_no: 0,
            //   image: "",
            //   main_id_no: 0));

            await DbSubCategory().deleteAPISUBCategoryProducts();
            List<APISUBCategory> categories = [];

            APISUBCategory category = APISUBCategory(
                id: 0,
                en_name: "All",
                ar_name: "",
                seq_no: 0,
                image: "",
                main_id_no: 0);
            categories.add(category);
            for (SubCategory c in subcatedata) {
              APISUBCategory category = APISUBCategory(
                  id: c.id!,
                  en_name: c.english!,
                  ar_name: c.arabic ?? "",
                  seq_no: c.sequenceNo ?? 0,
                  image: "",
                  main_id_no: c.categoryMainId ?? 0);
              categories.add(category);
            }

            // log('categories  ${categories.length}');

            //Fetching data from DbProduct database
            // categories = DbCategory().getAPICategories() as List<dbcat.APICategory>;
            await DbSubCategory().addAPISUBCategory(categories);
          }

          //  log("Product Api calling....");

          // log(data.toString());
          //Return the Success Login Response

          if (data.isNotEmpty) {
            // for (var productData in data) {
            // final Uint8List empty = Uint8List(1);
            // log('Products fetched ${data.toString()}\n');
            List<Option> listaddonTopping = [];
            List<Attribute> proaddon = [];
            late hvpro.Product orderItem;
            for (Product p in data) {
              if (p.tbProductTopping!.isEmpty) {
                proaddon = [];
                orderItem = hvpro.Product(
                  id: p.id ?? 0,
                  name: p.headEnglish ?? "",
                  group: "",
                  description: "",
                  taxCode: p.taxCode!,
                  stock: p.qty ?? 0,
                  price: p.rate ?? 0,
                  attributes: List.empty(),
                  productImage: p.uploadImage ?? "",
                  productUpdatedTime: DateTime.now(),
                  tax: p.taxPercentage ?? 0.0,
                  catmainid: p.categoryMainId ?? 0,
                  subcatid: p.categoryId ?? 0,
                );
              } else {
                proaddon = [];
                for (TbProductTopping topping in p.tbProductTopping!) {
                  TbProductTopping atr = topping;
                  // listaddonTopping.add(Option(
                  //     id: data[p].tbProductTopping![j].id.toString(),
                  //     name: data[p].tbProductTopping![j].name ?? "",
                  //     price: data[p].tbProductTopping![j].rate ?? 0,
                  //     selected: false,
                  //     tax: data[p].taxPercentage ?? 0));
                  // log('Product Addon ${atr.toString()}\n');
                  proaddon.add(Attribute(
                      id: atr.id!,
                      name: atr.name ?? ""!,
                      type: "Multiselect",
                      moq: 0,
                      qty: 0,
                      toppingId: atr.toppingId! ?? 0,
                      options: List.empty(),
                      rate: atr.rate ?? 0));

                  orderItem.attributes = proaddon;
                }

                orderItem = hvpro.Product(
                  id: p.id ?? 0,
                  name: p.headEnglish ?? "",
                  group: "",
                  description: "",
                  stock: p.qty ?? 0,
                  price: p.rate ?? 0,
                  attributes: proaddon ?? List.empty(),
                  productImage: "",
                  productUpdatedTime: DateTime.now(),
                  tax: 0,
                  catmainid: p.categoryMainId ?? 0,
                  taxCode: p.taxCode! ?? "",
                  subcatid: p.categoryId ?? 0,
                );
              }


              // log('Products ${orderItem.toString()}\n');

              product.add(orderItem);
            }


            await DbProduct().addProducts(product);


            // products = apiProResponse.data1!;

            // product = await DbProduct().getAllProducts();
          }

          log("CATPRO API Calling : Data Saved");
          return ProductCommanResponse2(
              status: res.statusCode,
              message: SUCCESS,
              apiStatus: ApiStatus.REQUEST_SUCCESS,
              data1: data);
        }

        //API Failure
        else {
          //Return the Failure Login Response
          return ProductCommanResponse2(
              status: res.statusCode,
              message: FAILURE_OCCURED,
              apiStatus: ApiStatus.REQUEST_FAILURE,
              data1: List.empty());
        }
      }else{
        return ProductCommanResponse2(
            status: res.statusCode,
            message: FAILURE_OCCURED,
            apiStatus: ApiStatus.REQUEST_FAILURE,
            data1: List.empty());
      }
    }

    // If internet is not available
    else {
      return ProductCommanResponse2(
          status: 0,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET,
          data1: List.empty());
    }
  }
}
