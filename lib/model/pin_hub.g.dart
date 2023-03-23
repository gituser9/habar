// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_hub.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PinHubAdapter extends TypeAdapter<PinHub> {
  @override
  final int typeId = 16;

  @override
  PinHub read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PinHub(
      alias: fields[0] as String,
      data: (fields[1] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PinHub obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.alias)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinHubAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
