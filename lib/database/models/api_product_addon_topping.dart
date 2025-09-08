import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';

part 'api_product_addon_topping.g.dart';

@HiveType(typeId: APIProductAddonToppingBoxTypeId)
class ApiProductToppingOption extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int toppingid;

  @HiveField(2)
  String name;

  @HiveField(3)
  double price;

@HiveField(4)
  bool selected;


  ApiProductToppingOption({
    required this.id,
    required this.toppingid,
    required this.name,
    required this.price,
    required this.selected,
  });

  ApiProductToppingOption copyWith({
    int? id,
     int? toppingid,
    String? name,
    double? price,
    bool? selected,
    
  }) {
    return ApiProductToppingOption(
      id: id ?? this.id,
      toppingid: id ?? this.toppingid,
      name: name ?? this.name,
      price: price ?? this.price,
       selected: selected ?? this.selected,
    
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toppingid': toppingid,
      'name': name,
      'price': price,
       'selected': selected,
     
    };
  }

  factory ApiProductToppingOption.fromMap(Map<String, dynamic> map) {
    return ApiProductToppingOption(
      id: map['id'] ?? 0,
      toppingid: map['toppingid'] ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
     selected: map['selected'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiProductToppingOption.fromJson(String source) => ApiProductToppingOption.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Option(id: $id, name: $name, price: $price, toppingid: $toppingid, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiProductToppingOption &&
        other.id == id &&
        other.toppingid == toppingid &&
        other.name == name &&
        other.price == price &&
        other.selected == selected ;
        
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ price.hashCode ^ toppingid.hashCode ^ selected.hashCode;
  }
}
