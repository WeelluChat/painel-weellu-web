// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelsClients.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelsclientsAdapter extends TypeAdapter<Modelsclients> {
  @override
  final int typeId = 0;

  @override
  Modelsclients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Modelsclients(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      countryCode: fields[3] as String?,
      fullImageUrl: fields[4] as String?,
      createdAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Modelsclients obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.fullImageUrl)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelsclientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
