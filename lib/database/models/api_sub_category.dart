import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';

part 'api_sub_category.g.dart';

@HiveType(typeId: APISUBCategoryBoxTypeId)
class APISUBCategory extends HiveObject {
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
  int main_id_no;

  String? imageUrl;

  bool isChecked;

  APISUBCategory(
      {required this.id,
      required this.en_name,
      required this.ar_name,
      required this.seq_no,
      required this.image,
      required this.main_id_no,
      this.imageUrl = '',
      this.isChecked = false});

  APISUBCategory copyWith({
    int? id,
    int? seqid,
    int? mainid,
    String? name,
    String? arname,
    String? image,
    bool? isChecked
  }) {
    return APISUBCategory(
      id: id ?? this.id,
      en_name: name ?? this.en_name,
      ar_name: arname ?? this.ar_name,
      seq_no: seqid ?? this.seq_no,
      image: image ?? this.image,
      main_id_no: mainid ?? this.main_id_no,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'en_name': en_name,
      'ar_name': ar_name,
      'seq_no': seq_no,
      'image': image,
      'main_id': main_id_no,
      'isChecked': isChecked,
    };
  }

  factory APISUBCategory.fromMap(Map<String, dynamic> map) {
    return APISUBCategory(
      id: map['id'] ?? 0,
      en_name: map['en_name'] ?? '',
      ar_name: map['ar_name'] ?? '',
      seq_no: map['seq_no'] ?? 0,
      image: map['image'] ?? '',
      main_id_no: map['main_id'] ?? 0,
       isChecked: map['isChecked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory APISUBCategory.fromJson(String source) =>
      APISUBCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $en_name, image: $image, mainid: $main_id_no, isChecked : $isChecked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is APISUBCategory &&
        other.id == id &&
        other.en_name == en_name &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^ en_name.hashCode ^ image.hashCode;
  }
}
