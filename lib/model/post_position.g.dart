// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_position.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostPositionAdapter extends TypeAdapter<PostPosition> {
  @override
  final int typeId = 9;

  @override
  PostPosition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostPosition(
      postId: fields[0] as String,
      position: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PostPosition obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostPositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
