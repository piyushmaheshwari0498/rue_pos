// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 10;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as double,
      group: fields[3] as String,
      description: fields[4] as String,
      stock: fields[5] as double,
      attributes: (fields[6] as List).cast<Attribute>(),
      productImage: fields[7] as String,
      productUpdatedTime: fields[8] as DateTime,
      tax: fields[9] == null ? 0.0 : fields[9] as double,
      catmainid: fields[10] ?? 0,
      subcatid: fields[11] ?? 0,
      taxCode: fields[12] ?? "",
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
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
      ..write(obj.productImage)
      ..writeByte(8)
      ..write(obj.productUpdatedTime)
      ..writeByte(9)
      ..write(obj.tax)
      ..writeByte(10)
      ..write(obj.catmainid)
      ..writeByte(11)
      ..write(obj.subcatid)
    ..writeByte(12)
      ..write(obj.taxCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
