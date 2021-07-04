// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 1;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] as String,
      timePublished: fields[1] as DateTime,
      isCorporative: fields[2] as bool,
      lang: fields[3] as String,
      titleHtml: fields[4] as String,
      postType: fields[5] as String,
      postLabels: (fields[6] as List).cast<PostLabel>(),
      author: fields[7] as Author,
      statistics: fields[8] as Statistics,
      hubs: (fields[9] as List).cast<HubData>(),
      textHtml: fields[12] as String,
      status: fields[11] as String,
      tags: (fields[10] as List).cast<Tag>(),
      leadData: fields[13] as LeadData,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timePublished)
      ..writeByte(2)
      ..write(obj.isCorporative)
      ..writeByte(3)
      ..write(obj.lang)
      ..writeByte(4)
      ..write(obj.titleHtml)
      ..writeByte(5)
      ..write(obj.postType)
      ..writeByte(6)
      ..write(obj.postLabels)
      ..writeByte(7)
      ..write(obj.author)
      ..writeByte(8)
      ..write(obj.statistics)
      ..writeByte(9)
      ..write(obj.hubs)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.textHtml)
      ..writeByte(13)
      ..write(obj.leadData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthorAdapter extends TypeAdapter<Author> {
  @override
  final int typeId = 2;

  @override
  Author read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Author(
      scoreStats: fields[0] as ScoreStats,
      id: fields[1] as String,
      login: fields[2] as String,
      alias: fields[3] as String,
      fullname: fields[4] as String,
      avatarUrl: fields[5] as String,
      speciality: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Author obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.scoreStats)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.login)
      ..writeByte(3)
      ..write(obj.alias)
      ..writeByte(4)
      ..write(obj.fullname)
      ..writeByte(5)
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.speciality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreStatsAdapter extends TypeAdapter<ScoreStats> {
  @override
  final int typeId = 3;

  @override
  ScoreStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreStats(
      score: fields[0] as double,
      votesCount: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreStats obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.votesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HubDataAdapter extends TypeAdapter<HubData> {
  @override
  final int typeId = 4;

  @override
  HubData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HubData(
      id: fields[0] as String,
      alias: fields[1] as String,
      type: fields[2] as String,
      title: fields[3] as String,
      titleHtml: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HubData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.alias)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.titleHtml);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HubDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostLabelAdapter extends TypeAdapter<PostLabel> {
  @override
  final int typeId = 5;

  @override
  PostLabel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostLabel(
      type: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostLabel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostLabelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatisticsAdapter extends TypeAdapter<Statistics> {
  @override
  final int typeId = 6;

  @override
  Statistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Statistics(
      commentsCount: fields[0] as int,
      favoritesCount: fields[1] as int,
      readingCount: fields[2] as int,
      score: fields[3] as int,
      votesCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Statistics obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.commentsCount)
      ..writeByte(1)
      ..write(obj.favoritesCount)
      ..writeByte(2)
      ..write(obj.readingCount)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.votesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 7;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      titleHtml: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.titleHtml);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LeadDataAdapter extends TypeAdapter<LeadData> {
  @override
  final int typeId = 8;

  @override
  LeadData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeadData(
      textHtml: fields[0] as String,
      imageUrl: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LeadData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.textHtml)
      ..writeByte(1)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeadDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
