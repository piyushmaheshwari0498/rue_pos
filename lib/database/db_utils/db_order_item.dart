import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_order_item.dart';

import '../models/order_item.dart';
import 'db_constants.dart';

class DbOrderItem {
  late Box box;

  Future<void> addProducts(List<OrderItem> list) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);

    for (OrderItem item in list) {
      await box.put(item.id, item);
    }
  }

  Future<void> addUpdateProducts(OrderItem item) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);

    // for (OrderItem item in list) {
      await box.put(item.id, item);
    // }
  }

  Future<void> addAPIOrder(List<APIOrderItem> list) async {
    box = await Hive.openBox<APIOrderItem>(API_ORDER_ITEM_BOX);

    for (APIOrderItem item in list) {
      await box.put(item.id, item);
    }
  }


  Future<List<OrderItem>> getProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    List<OrderItem> list = [];
    for (var item in box.values) {
      var product = item as OrderItem;
      // if (product.stock > 0 && product.price > 0)
        list.add(product);
    }
    return list;
  }

  Future<OrderItem?> getProductDetails(String key) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    return box.get(key);
  }

  Future<APIOrderItem?> getAPIProductDetails(String key) async {
    box = await Hive.openBox<APIOrderItem>(API_ORDER_ITEM_BOX);
    return box.get(key);
  }

  Future<void> reduceInventory(List<OrderItem> items) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    for (OrderItem item in items) {
      OrderItem itemInDB = box.get(item.id) as OrderItem;
      var availableQty = itemInDB.stock - item.orderedQuantity;
      itemInDB.stock = availableQty;
      itemInDB.orderedQuantity = 0;
      itemInDB.productUpdatedTime = DateTime.now();
      await itemInDB;
    }
  }


  Future<List<OrderItem>> updateInventory(OrderItem items) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    // for (OrderItem item in items) {
    var key = box.get(items.id);

    // dynamic desiredKey;
    // final Map<dynamic, OrderItem> deliveriesMap = box.keys;
    // deliveriesMap.forEach((key, value){
    //   if (value.id == id)
    //     desiredKey = key;
    // });
    // box.delete(key);
    box.putAt(key,items);

    List<OrderItem> list = [];
    for (var item in box.values) {
      var product = item as OrderItem;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    return list;

  }

  Future<int> deleteProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    return box.clear();
  }

  deleteProductById(int id) async {
    final box = Hive.box<OrderItem>(ORDER_ITEM_BOX);

    final Map<dynamic, OrderItem> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value){
      if (value.id == id)
        desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future<List<OrderItem>> getAllProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    List<OrderItem> list = [];
    for (var item in box.values) {
      var product = item as OrderItem;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    // box.close();
    return list;
  }

  Future<List<APIOrderItem>> getAllAPIOrders() async {
    box = await Hive.openBox<APIOrderItem>(API_ORDER_ITEM_BOX);
    List<APIOrderItem> list = [];
    for (var item in box.values) {
      var product = item as APIOrderItem;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    // box.close();
    return list;
  }
}
