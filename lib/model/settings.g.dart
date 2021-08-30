// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 10;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      isShowImage: fields[0] as bool,
      isShowPostPreview: fields[1] as bool,
      postTextSize: fields[2] as double,
      commentTextSize: fields[3] as double,
      isInfinityScroll: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isShowImage)
      ..writeByte(1)
      ..write(obj.isShowPostPreview)
      ..writeByte(2)
      ..write(obj.postTextSize)
      ..writeByte(3)
      ..write(obj.commentTextSize)
      ..writeByte(4)
      ..write(obj.isInfinityScroll);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SettingsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
