// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_product_addon_topping.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductToppingAdapter extends TypeAdapter<ApiProductToppingOption> {
  @override
  final int typeId = APIProductAddonToppingBoxTypeId;

  @override
  ApiProductToppingOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiProductToppingOption(
      id: fields[0] as int,
       toppingid: fields[1] as int,
      name: fields[2] as String,
      price: fields[3] as double,
      selected: fields[4] as bool,
     
    );
  }

  @override
  void write(BinaryWriter writer, ApiProductToppingOption obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
       ..writeByte(1)
      ..write(obj.toppingid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
       ..writeByte(4)
      ..write(obj.selected);
      
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductToppingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
