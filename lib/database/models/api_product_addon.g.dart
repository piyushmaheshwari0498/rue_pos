// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_product_addon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class APIProductAddonAdapter extends TypeAdapter<APIProductAddon> {
  @override
  final int typeId = APIProductAddonBoxTypeId;

  @override
  APIProductAddon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

  
    return APIProductAddon(
      id: fields[0],
      code: fields[1] as String,
      headEnglish: fields[2] as String,
      headArabic: fields[3] as String,
      desEnglish: fields[4] as String,
      desArabic: fields[5] as String,
      rate: fields[6] == null ? 0.0 : fields[6] as double,
      qty: fields[7] == null ? 0.0 : fields[7] as double,
      displayQty: fields[8] == null ? 0.0 : fields[8] as double,
      storesQty: fields[9] == null ? 0.0 : fields[9] as double,
      sequenceNo: fields[10]  == null ? 0 : fields[10] as int,
      categoryId: fields[11]  == null ? 0 : fields[11] as int,
      categoryMainId: fields[12]  == null ? 0 : fields[12] as int,
      taxId: fields[13]  == null ? 0 : fields[13] as int,
      taxCode: fields[14] as String,
      taxClassName: fields[15] as String,
      taxPercentage: fields[16]  == null ? 0.0 : fields[16] as double,
      status: fields[17] as bool,
      uploadImage: fields[18] as String,
      tbProductTopping: (fields[19] as List).cast<ApiProductToppingOption>(),
    );
  }

  @override
  void write(BinaryWriter writer, APIProductAddon obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.headEnglish)
      ..writeByte(3)
      ..write(obj.headArabic)
       ..writeByte(4)
      ..write(obj.desEnglish)
       ..writeByte(5)
      ..write(obj.desArabic)
       ..writeByte(6)
      ..write(obj.rate)
       ..writeByte(7)
      ..write(obj.qty)
       ..writeByte(8)
      ..write(obj.displayQty)
       ..writeByte(9)
      ..write(obj.storesQty)
       ..writeByte(10)
      ..write(obj.sequenceNo)
       ..writeByte(11)
      ..write(obj.categoryId)
       ..writeByte(12)
      ..write(obj.categoryMainId)
       ..writeByte(13)
      ..write(obj.taxId)
       ..writeByte(14)
      ..write(obj.taxCode)
       ..writeByte(15)
      ..write(obj.taxClassName)
       ..writeByte(16)
      ..write(obj.taxPercentage)
       ..writeByte(17)
      ..write(obj.status)
       ..writeByte(18)
      ..write(obj.uploadImage)
       ..writeByte(19)
      ..write(obj.tbProductTopping)
      ;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIProductAddonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
