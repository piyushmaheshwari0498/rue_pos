// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_park_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class APIParkOrderAdapter extends TypeAdapter<APIParkOrder> {
  @override
  final int typeId = APIParkOrderBoxTypeId;

  @override
  APIParkOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APIParkOrder(
      id: fields[0] as String,
      date: fields[1] as String,
      time: fields[2] as String,
      customer: fields[3] as Customer,
      manager: fields[4] as HubManager,
      items: (fields[5] as List).cast<APIOrderItem>(),
      orderAmount: fields[6] as double,
      transactionDateTime: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, APIParkOrder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.customer)
      ..writeByte(4)
      ..write(obj.manager)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.orderAmount)
      ..writeByte(7)
      ..write(obj.transactionDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIParkOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
