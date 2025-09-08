import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_product_addon_topping.dart';

import '../db_utils/db_constants.dart';
part 'api_product_addon.g.dart';

@HiveType(typeId: APIProductAddonBoxTypeId)
class APIProductAddon extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String code;

  @HiveField(2)
  String headEnglish;

  @HiveField(3)
  String headArabic;

  @HiveField(4)
  String desEnglish;

  @HiveField(5)
  String desArabic;

  @HiveField(6)
  double rate;

  @HiveField(7)
  double qty;

  @HiveField(8)
  double displayQty;

  @HiveField(9)
  double storesQty;

  @HiveField(10)
  int sequenceNo;

  @HiveField(11)
  int categoryId;

  @HiveField(12)
  int categoryMainId;

  @HiveField(13)
  int taxId;

  @HiveField(14)
  String taxCode;

  @HiveField(15)
  String taxClassName;

  @HiveField(16)
  double taxPercentage;

  @HiveField(17)
  bool status;

  @HiveField(18)
  String uploadImage;

  @HiveField(19)
  List<ApiProductToppingOption> tbProductTopping;

  APIProductAddon({
    required this.id,
    required this.code,
    required this.headEnglish,
    required this.headArabic,
    required this.desEnglish,
    required this.desArabic,
    required this.rate,
    required this.qty,
    required this.displayQty,
    required this.storesQty,
    required this.sequenceNo,
    required this.categoryId,
    required this.categoryMainId,
    required this.taxId,
    required this.taxCode,
    required this.taxClassName,
    required this.taxPercentage,
    required this.status,
    required this.uploadImage,
    required this.tbProductTopping,
  });

  APIProductAddon copyWith(
      {int? id,
      String? code,
      String? headEnglish,
      String? headArabic,
      String? desEnglish,
      String? desArabic,
      double? rate,
      double? qty,
      double? displayQty,
      double? storesQty,
      int? sequenceNo,
      int? categoryId,
      int? categoryMainId,
      int? taxId,
      String? taxCode,
      String? taxClassName,
      double? taxPercentage,
      bool? status,
      String? uploadImage,
      List<ApiProductToppingOption>? tbProductTopping}) {
    return APIProductAddon(
      id: id ?? this.id,
      code: code ?? this.code,
      headEnglish: headEnglish ?? this.headEnglish,
      headArabic: headArabic ?? this.headArabic,
      desEnglish: desEnglish ?? this.desEnglish,
      desArabic: desArabic ?? this.desArabic,
      rate: rate ?? this.rate,
      qty: qty ?? this.qty,
      displayQty: displayQty ?? this.displayQty,
      storesQty: storesQty ?? this.storesQty,
      sequenceNo: sequenceNo ?? this.sequenceNo,
      categoryId: categoryId ?? this.categoryId,
      categoryMainId: categoryMainId ?? this.categoryMainId,
      taxId: taxId ?? this.taxId,
      taxCode: taxCode ?? this.taxCode,
      taxClassName: taxClassName ?? this.taxClassName,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      status: status ?? this.status,
      uploadImage: uploadImage ?? this.uploadImage,
      tbProductTopping: tbProductTopping ?? this.tbProductTopping,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'headEnglish': headEnglish,
      'headArabic': headArabic,
      'desEnglish': desEnglish,
      'desArabic': desArabic,
      'rate': rate,
      'qty': qty,
      'displayQty': displayQty,
      'storesQty': storesQty,
      'sequenceNo': sequenceNo,
      'categoryId': categoryId,
      'categoryMainId': categoryMainId,
      'taxId': taxId,
      'taxCode': taxCode,
      'taxClassName': taxClassName,
      'taxPercentage': taxPercentage,
      'status': status,
      'uploadImage': uploadImage,
      'tbProductTopping': tbProductTopping.map((x) => x.toMap()).toList(),
    };
  }

  factory APIProductAddon.fromMap(Map<String, dynamic> map) {
    return APIProductAddon(
      id: map['id'] ?? 0,
      code: map['code'] ?? '',
      headEnglish: map['headEnglish'] ?? '',
      headArabic: map['headArabic'] ?? '',
      desEnglish: map['desEnglish'] ?? '',
      desArabic: map['desArabic'] ?? '',
      rate: map['rate'] ?? 0.0,
      qty: map['qty'] ?? 0.0,
      displayQty: map['displayQty'] ?? 0.0,
      storesQty: map['storesQty'] ?? 0.0,
      sequenceNo: map['sequenceNo'] ?? 0,
      categoryId: map['categoryId'] ?? 0,
      categoryMainId: map['categoryMainId'] ?? 0,
      taxId: map['taxId'] ?? 0,
      taxCode: map['taxCode'] ?? '',
      taxClassName: map['taxClassName'] ?? '',
      taxPercentage: map['taxPercentage'] ?? 0.0,
      status: map['status'] ?? false,
      uploadImage: map['uploadImage'] ?? '',
      tbProductTopping:
          List<ApiProductToppingOption>.from(map['tbProductTopping']?.map((x) => ApiProductToppingOption.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory APIProductAddon.fromJson(String source) =>
      APIProductAddon.fromMap(json.decode(source));

  @override
  String toString() =>
      'Addons(id $id code $code en $headEnglish ar $headArabic desen $desEnglish desar $desArabic rate $rate qty $qty disqty $displayQty sqty $storesQty seq $sequenceNo catid $categoryId mainid $categoryMainId taxid $taxId taxname $taxClassName taxcode  $taxCode tax% $taxPercentage status $status upldimg $uploadImage topping $tbProductTopping )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is APIProductAddon &&
        other.id == id &&
        other.headEnglish == headEnglish &&
        other.rate == rate &&
        listEquals(other.tbProductTopping, tbProductTopping);
  }

  @override
  int get hashCode => id.hashCode ^ headEnglish.hashCode ^ tbProductTopping.hashCode;
}
