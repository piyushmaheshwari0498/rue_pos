import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
import 'option.dart';
part 'attribute.g.dart';

@HiveType(typeId: AttributeBoxTypeId)
class Attribute extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  List<Option> options;

  @HiveField(4, defaultValue: 0)
  double moq;

  @HiveField(5, defaultValue: 0)
  double rate;

  @HiveField(6, defaultValue: 0)
  double qty;

  @HiveField(7, defaultValue: 0)
  int toppingId;

  Attribute({
    required this.id,
    required this.name,
    required this.type,
    required this.moq,
    required this.options,
     required this.rate,
    required this.qty,
    required this.toppingId,
  });

  Attribute copyWith({
    int? id,
    int? toppingId,
    String? name,
    String? type,
    double? moq,
    List<Option>? options,
    double? tax,
     double? rate,
    double? qty,
  }) {
    return Attribute(
      id: id ?? this.id,
      toppingId: toppingId ?? this.toppingId,
       name: name ?? this.name,
      type: type ?? this.type,
      moq: moq ?? this.moq,
      options: options ?? this.options,
       rate: rate ?? this.rate,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
       'id': id,
       'toppingId': toppingId,
      'name': name,
      'type': type,
      'moq': moq,
      'rate': rate,
      'qty': qty,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  factory Attribute.fromMap(Map<String, dynamic> map) {
    return Attribute(
       id: map['id'] ?? 0,
      toppingId: map['toppingId'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      moq: map['moq'] ?? 0,
      rate: map['rate'] ?? 0,
      qty: map['qty'] ?? 0,
      options: List<Option>.from(map['options']?.map((x) => Option.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Attribute.fromJson(String source) =>
      Attribute.fromMap(json.decode(source));

  @override
  String toString() =>
      'Attribute(id: $id, name: $name, moq: $moq type: $type, options: $options,rate: $rate, qty: $qty)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attribute &&
     other.id == id &&
     other.toppingId == toppingId &&
        other.name == name &&
        other.type == type &&
        other.moq == moq &&
         other.rate == rate &&
        other.qty == qty &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode ^ rate.hashCode ^ options.hashCode ^ qty.hashCode;
}
