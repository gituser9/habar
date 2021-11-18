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
      theme: fields[5] as AppThemeType?,
      filters: fields[6] as Filter?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isShowImage)
      ..writeByte(1)
      ..write(obj.isShowPostPreview)
      ..writeByte(2)
      ..write(obj.postTextSize)
      ..writeByte(3)
      ..write(obj.commentTextSize)
      ..writeByte(4)
      ..write(obj.isInfinityScroll)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.filters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeTypeAdapter extends TypeAdapter<AppThemeType> {
  @override
  final int typeId = 11;

  @override
  AppThemeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeType.light;
      case 1:
        return AppThemeType.dark;
      default:
        return AppThemeType.light;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeType obj) {
    switch (obj) {
      case AppThemeType.light:
        writer.writeByte(0);
        break;
      case AppThemeType.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
