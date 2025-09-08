// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_order_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class APIOrderItemAdapter extends TypeAdapter<APIOrderItem> {
  @override
  final int typeId = APIOrderItemBoxTypeId;

  @override
  APIOrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APIOrderItem(
      id: fields[0] as String,
      name: fields[1] as String,
      group: fields[3] as String,
      description: fields[4] as String,
      stock: fields[5] as double,
      price: fields[2] as double,
      attributes: (fields[6] as List).cast<APIProductAddon>(),
      orderedQuantity: fields[7] as double,
      orderedPrice: fields[10] as double,
      productImage: fields[8] as String,
      productUpdatedTime: fields[9] as DateTime,
      productImageUrl: fields[11] == null ? '' : fields[11] as String?,
      tax: fields[12] == null ? 0.0 : fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, APIOrderItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.group)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.attributes)
      ..writeByte(7)
      ..write(obj.orderedQuantity)
      ..writeByte(8)
      ..write(obj.productImage)
      ..writeByte(9)
      ..write(obj.productUpdatedTime)
      ..writeByte(10)
      ..write(obj.orderedPrice)
      ..writeByte(11)
      ..write(obj.productImageUrl)
      ..writeByte(12)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIOrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
