// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttributeAdapter extends TypeAdapter<Attribute> {
  @override
  final int typeId = 15;

  @override
  Attribute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attribute(
       id: fields[0] as int,
      name: fields[1] as String,
      options: (fields[2] as List).cast<Option>(),
      type: fields[3] as String,
      moq: fields[4] == null ? 0 : fields[4] as double,
      rate: fields[5] == null ? 0 : fields[5] as double,
      qty: fields[6] == null ? 0 : fields[6] as double,
      toppingId: fields[7] == null ? 0 : fields[7] as int,

    );
  }

  @override
  void write(BinaryWriter writer, Attribute obj) {
    writer
      ..writeByte(8)
       ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.moq)
       ..writeByte(5)
      ..write(obj.rate)
    ..writeByte(6)
    ..write(obj.qty)
      ..writeByte(7)
    ..write(obj.toppingId);

  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
