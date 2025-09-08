import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_category.dart';
import 'package:nb_posx/database/models/api_order_item.dart';

import '../models/category.dart';
import '../models/order_item.dart';
import 'db_constants.dart';

class DbCategory {
  late Box box;

  Future<void> addCategory(List<Category> list) async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    for (Category cat in list) {
      await box.put(cat.id, cat);
    }
  }

  Future<List<Category>> getCategories() async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    List<Category> list = [];
    for (var item in box.values) {
      var cat = item as Category;
      list.add(cat);
    }
    return list;
  }

  Future<void> addAPICategory(List<APICategory> list) async {
    box = await Hive.openBox<APICategory>(API_CATEGORY_BOX);
    for (APICategory cat in list) {
      await box.put(cat.id, cat);
    }
  }

   Future<int> deleteAPICategoryProducts() async {
    box = await Hive.openBox<APICategory>(API_CATEGORY_BOX);
    return box.clear();
  }

 Future<List<APICategory>> getAPICategories() async {
    box = await Hive.openBox<APICategory>(API_CATEGORY_BOX);
    List<APICategory> list = [];
    for (var item in box.values) {
      var cat = item as APICategory;
      list.add(cat);
    }
    box.close();
    return list;
  }

  Future<void> reduceInventory(List<OrderItem> items) async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    for (OrderItem orderItem in items) {
      for (var item in box.values) {
        Category cat = item as Category;
        if (cat.name == orderItem.group) {
          for (var catItem in cat.items) {
            if (catItem.name == orderItem.name &&
                catItem.stock != -1 &&
                catItem.stock != 0) {
              var availableQty = catItem.stock - orderItem.orderedQuantity;
              catItem.stock = availableQty;
              catItem.productUpdatedTime = DateTime.now();
              await cat.save();
            }
          }
        }
      }
    }
  }

  Future<void> reduceAPIInventory(List<APIOrderItem> items) async {
    box = await Hive.openBox<Category>(API_CATEGORY_BOX);
    for (APIOrderItem orderItem in items) {
      for (var item in box.values) {
        Category cat = item as Category;
        if (cat.name == orderItem.group) {
          for (var catItem in cat.items) {
            if (catItem.name == orderItem.name &&
                catItem.stock != -1 &&
                catItem.stock != 0) {
              var availableQty = catItem.stock - orderItem.orderedQuantity;
              catItem.stock = availableQty;
              catItem.productUpdatedTime = DateTime.now();
              await cat.save();
            }
          }
        }
      }
    }
  }
}
