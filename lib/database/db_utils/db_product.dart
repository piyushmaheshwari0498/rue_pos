

import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_product.dart';

import '../models/order_item.dart';
import '../models/product.dart';
import 'db_constants.dart';

import 'package:nb_posx/core/service/api_product/model/api_product.dart'
    as aiPro; 
    
class DbProduct {
  late Box box;

  Future<void> addProducts(List<Product> list) async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);

    for (Product item in list) {
      await box.put(item.id, item);
    }
  }

  Future<void> addApiProducts(List<APIProduct> list) async {
    box = await Hive.openBox<APIProduct>(API_PRODUCT_BOX);

    for (APIProduct item in list) {
      await box.put(item.id, item);
    }
  }

  Future<List<Product>> getProducts() async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);
    List<Product> list = [];
    for (var item in box.values) {
      var product = item as Product;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    return list;
  }

  Future<Product?> getProductDetails(String key) async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);
    return box.get(key);
  }

  Future<void> reduceInventory(List<OrderItem> items) async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);
    for (OrderItem item in items) {
      Product? itemInDB = await getProductDetails(item.id);
      var availableQty = itemInDB!.stock - item.orderedQuantity;
      itemInDB.stock = availableQty;
      // itemInDB.orderedQuantity = 0;
      itemInDB.productUpdatedTime = DateTime.now();
      await itemInDB.save();
    }
  }

  Future<int> deleteProducts() async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);
    return box.clear();
  }

   Future<int> deleteApiProducts() async {
    box = await Hive.openBox<APIProduct>(API_PRODUCT_BOX);
    return box.clear();
  }

  Future<List<Product>> getAllProducts() async {
    box = await Hive.openBox<Product>(PRODUCT_BOX);
    List<Product> list = [];
    for (var item in box.values) {
      var product = item;
      // if (product.stock > 0 && product.price > 0) 
      list.add(product);
    }
     log('Products ${list.length}');
    box.close();

   
    return list;
  }

  Future<int> getProductsSize() async {
    box = await Hive.openBox<APIProduct>(API_PRODUCT_BOX);
    List<APIProduct> list = [];
    for (var item in box.values) {
      var product = item;
      // if (product.stock > 0 && product.price > 0) 
      list.add(product);
    }
    //  log('Products ${list.length}');
    // box.close();

   
    return list.length;
  }

  Future<List<APIProduct>> getAllAPiProducts() async {
    box = await Hive.openBox<APIProduct>(API_PRODUCT_BOX);
    List<APIProduct> list = [];
    for (var item in box.values) {
      var product = item;

      
      // if (product.stock > 0 && product.price > 0) 
      list.add(product);
    }

    
    // box.close();
    return list;
  }
}
