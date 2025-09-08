import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_category.dart';
import 'package:nb_posx/database/models/api_order_item.dart';
import 'package:nb_posx/database/models/api_sub_category.dart';

import '../models/category.dart';
import '../models/order_item.dart';
import 'db_constants.dart';

class DbSubCategory {
  late Box box;


  Future<void> addAPISUBCategory(List<APISUBCategory> list) async {
    box = await Hive.openBox<APISUBCategory>(API_SUB_CATEGORY_BOX);
    for (APISUBCategory cat in list) {
      await box.put(cat.id, cat);
    }
  }

   Future<int> deleteAPISUBCategoryProducts() async {
    box = await Hive.openBox<APISUBCategory>(API_SUB_CATEGORY_BOX);
    return box.clear();
  }

 Future<List<APISUBCategory>> getAPISUBCategories() async {
    box = await Hive.openBox<APISUBCategory>(API_SUB_CATEGORY_BOX);
    List<APISUBCategory> list = [];
    for (var item in box.values) {
      var cat = item as APISUBCategory;
      list.add(cat);
    }
    box.close();
    return list;
  }
}
