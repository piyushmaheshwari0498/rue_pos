import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';
import 'attribute.dart';

part 'product.g.dart';

@HiveType(typeId: ProductsBoxTypeId)
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String group;

  @HiveField(4)
  String description;

  @HiveField(5)
  double stock;

  @HiveField(6)
  List<Attribute> attributes;

  @HiveField(7)
  String productImage;

  @HiveField(8)
  DateTime productUpdatedTime;

  @HiveField(9, defaultValue: 0.0)
  double tax;

  @HiveField(10)
  int catmainid;

   @HiveField(11)
  int subcatid;

   @HiveField(12)
  String taxCode;

  Product(
      {required this.id,
      required this.name,
      required this.group,
      required this.description,
      required this.stock,
      required this.price,
      required this.attributes,
      required this.productImage,
      required this.productUpdatedTime,
      required this.tax,
      required this.taxCode,
       required this.catmainid,
        required this.subcatid,
      
      });

  Product copyWith(
      {
        required int id,
      required String code,
      required String name,
      required String group,
      required String description,
      required double stock,
      required double price,
      required List<Attribute> attributes,
      required double orderedQuantity,
      required double orderedPrice,
      required String productImage,
      required DateTime productUpdatedTime,
      required double tax,
      required String taxCode,
      required int catmainid,
      required int subcatid,
      }) {
    return Product(
      id: id,
      name: name,
      group: group,
      description: description,
      stock: stock,
      price: price,
      attributes: attributes,
      productImage: productImage,
      productUpdatedTime: productUpdatedTime,
      tax: tax,
      taxCode: taxCode,
      catmainid: catmainid,
      subcatid: subcatid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'description': description,
      'stock': stock,
      'price': price,
      'attributes': attributes.map((x) => x.toMap()).toList(),
      'productImage': productImage,
      'productUpdatedTime': productUpdatedTime.toIso8601String(),
      'tax': tax,
      'taxCode': taxCode,
      'catmainid': catmainid,
      'subcatid': subcatid
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        name: map['name'],
        group: map['group'],
        description: map['description'],
        stock: map['stock'],
        price: map['price'],
        attributes: List<Attribute>.from(
            map['attributes']?.map((x) => Attribute.fromMap(x))),
        productImage: map['productImage'],
        // productUpdatedTime: map['productUpdatedTime'],
        productUpdatedTime:DateTime.parse(map['productUpdatedTime']),
        tax: map['tax'],
      taxCode: map['taxCode'],
         catmainid: map['catmainid'],
          subcatid: map['subcatid'],);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id,  name: $name,attributes: $attributes,  group: $group, description: $description, stock: $stock, price: '
        '$price,  productImage: $productImage, productUpdatedTime: $productUpdatedTime, '
        'tax: $tax, catmainid: $catmainid, subcatid: $subcatid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.group == group &&
        other.description == description &&
        other.stock == stock &&
        other.price == price &&
        other.attributes == attributes &&
        other.productImage == productImage &&
        other.productUpdatedTime == productUpdatedTime &&
        other.productUpdatedTime == productUpdatedTime &&
        other.tax == tax &&
        other.taxCode == taxCode &&
        other.catmainid == catmainid &&
        other.subcatid == subcatid
        ;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        group.hashCode ^
        description.hashCode ^
        stock.hashCode ^
        price.hashCode ^
        attributes.hashCode ^
        productImage.hashCode ^
        productUpdatedTime.hashCode ^
        productUpdatedTime.hashCode ^
        tax.hashCode ^
    taxCode.hashCode ^
        catmainid.hashCode ^
        subcatid.hashCode
        ;
  }
}
