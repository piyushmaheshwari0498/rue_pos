import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_product_addon.dart';

import '../db_utils/db_constants.dart';

part 'api_product.g.dart';

@HiveType(typeId: APIProductBoxTypeId)
class APIProduct extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String en_name;

  @HiveField(2)
  String ar_name;

  @HiveField(3)
  int seq_no;

  @HiveField(4)
  String? image;

  @HiveField(5)
  List<APIProductAddon> tbproduct;

  String? imageUrl;

  APIProduct(
      {required this.id,
      required this.en_name,
      required this.ar_name,
      required this.seq_no,
      required this.image,
      required this.tbproduct,});

  APIProduct copyWith({
    int? id,
    int? seqid,
    List<APIProductAddon>? tbpro,
    String? name,
    String? arname,
    String? image,
  }) {
    return APIProduct(
      id: id ?? this.id,
      en_name: name ?? en_name,
      ar_name: arname ?? ar_name,
      seq_no: seqid ??  seq_no,
      image: image ?? image,
      tbproduct: tbpro ?? tbproduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'en_name': en_name,
      'ar_name': ar_name,
      'seq_no': seq_no,
      'image': image,
      'tbproduct': tbproduct,
    };
  }

  factory APIProduct.fromMap(Map<String, dynamic> map) {
    return APIProduct(
      id: map['id'],
      en_name: map['en_name'] ,
      ar_name: map['ar_name'] ,
      seq_no: map['seq_no'],
      image: map['image'] ,
      tbproduct: map['tbproduct'],
    );
  }

  String toJson() => json.encode(toMap());

  factory APIProduct.fromJson(String source) =>
      APIProduct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $en_name, image: $image, tbproduct: $tbproduct)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is APIProduct &&
        other.id == id &&
        other.en_name == en_name &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^ en_name.hashCode ^ image.hashCode;
  }
}
