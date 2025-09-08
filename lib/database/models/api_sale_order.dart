import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/api_order_item.dart';

import '../db_utils/db_constants.dart';
import 'customer.dart';
import 'hub_manager.dart';
import 'order_item.dart';

part 'api_sale_order.g.dart';

@HiveType(typeId: APISaleOrderBoxTypeId)
class APISaleOrder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String time;

  @HiveField(3)
  Customer customer;

  @HiveField(4)
  HubManager manager;

  @HiveField(5)
  List<APIOrderItem> items;

  @HiveField(6)
  double orderAmount;

  @HiveField(7)
  String transactionId;

  @HiveField(8)
  bool transactionSynced;

  @HiveField(9)
  DateTime tracsactionDateTime;

  @HiveField(10, defaultValue: "")
  String paymentMethod;

  @HiveField(11, defaultValue: "Unpaid")
  String paymentStatus;

  String? parkOrderId;

  APISaleOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    required this.manager,
    required this.items,
    required this.orderAmount,
    required this.transactionId,
    required this.transactionSynced,
    required this.tracsactionDateTime,
    required this.paymentMethod,
    required this.paymentStatus,
    this.parkOrderId = '',
  });

  APISaleOrder copyWith(
      {String? id,
      String? date,
      String? time,
      Customer? customer,
      HubManager? manager,
      List<APIOrderItem>? items,
      double? orderAmount,
      String? transactionId,
      String? paymentMethod,
      String? paymentStatus,
      bool? transactionSynced,
      DateTime? tracsactionDateTime}) {
    return APISaleOrder(
        id: id ?? this.id,
        date: date ?? this.date,
        time: time ?? this.time,
        customer: customer ?? this.customer,
        manager: manager ?? this.manager,
        items: items ?? this.items,
        orderAmount: orderAmount ?? this.orderAmount,
        transactionId: transactionId ?? this.transactionId,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        transactionSynced: transactionSynced ?? this.transactionSynced,
        tracsactionDateTime: tracsactionDateTime ?? this.tracsactionDateTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'customer': customer.toMap(),
      'manager': manager.toMap(),
      'items': items.map((x) => x.toMap()).toList(),
      'orderAmount': orderAmount,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'transactionSynced': transactionSynced,
      'tracsactionDateTime': tracsactionDateTime.toIso8601String(),
    };
  }

  factory APISaleOrder.fromMap(Map<String, dynamic> map) {
    return APISaleOrder(
        id: map['id'],
        date: map['date'],
        time: map['time'],
        customer: Customer.fromMap(map['customer']),
        manager: HubManager.fromMap(map['manager']),
        items: List<APIOrderItem>.from(
            map['items']?.map((x) => APIOrderItem.fromMap(x))),
        orderAmount: map['orderAmount'],
        transactionId: map['transactionId'],
        paymentMethod: map['paymentMethod'],
        paymentStatus: map['paymentStatus'],
        transactionSynced: map['transactionSynced'],
        tracsactionDateTime: map['tracsactionDateTime']);
  }

  String toJson() => json.encode(toMap());

  factory APISaleOrder.fromJson(String source) =>
      APISaleOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaleOrder(id: $id, date: $date, time: $time, customer: $customer, manager: $manager, items: $items, orderAmount: $orderAmount, transactionId: $transactionId, transactionSynced: $transactionSynced. tracsactionDateTime: $tracsactionDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is APISaleOrder &&
        other.id == id &&
        other.date == date &&
        other.time == time &&
        other.customer == customer &&
        other.manager == manager &&
        listEquals(other.items, items) &&
        other.orderAmount == orderAmount &&
        other.transactionId == transactionId &&
        other.paymentMethod == paymentMethod &&
        other.paymentStatus == paymentStatus &&
        other.transactionSynced == transactionSynced &&
        other.tracsactionDateTime.isAtSameMomentAs(tracsactionDateTime);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        time.hashCode ^
        customer.hashCode ^
        manager.hashCode ^
        items.hashCode ^
        orderAmount.hashCode ^
        transactionId.hashCode ^
        paymentMethod.hashCode ^
        paymentStatus.hashCode ^
        transactionSynced.hashCode ^
        tracsactionDateTime.hashCode;
  }
}
