// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiCategoryAdapter extends TypeAdapter<APICategory> {
  @override
  final int typeId = APICategoryBoxTypeId;

  @override
  APICategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APICategory(
      id: fields[0] as int,
      en_name: fields[1] as String,
      ar_name: fields[2] as String,
       seq_no: fields[3] as int,
      image: fields[4] as String,
      main_id_no: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, APICategory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.en_name)
      ..writeByte(2)
      ..write(obj.ar_name)
      ..writeByte(3)
      ..write(obj.seq_no)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.main_id_no);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
