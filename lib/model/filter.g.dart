// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterAdapter extends TypeAdapter<Filter> {
  @override
  final int typeId = 12;

  @override
  Filter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Filter()
      ..sortType = fields[0] as FilterSortType
      ..sortValue = (fields[1] as Map).cast<String, String>()
      ..filterKey = fields[2] as ListFilter
      ..hubFilter = fields[3] as ListHubFilter;
  }

  @override
  void write(BinaryWriter writer, Filter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sortType)
      ..writeByte(1)
      ..write(obj.sortValue)
      ..writeByte(2)
      ..write(obj.filterKey)
      ..writeByte(3)
      ..write(obj.hubFilter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterSortTypeAdapter extends TypeAdapter<FilterSortType> {
  @override
  final int typeId = 13;

  @override
  FilterSortType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FilterSortType.newPost;
      case 1:
        return FilterSortType.bestPost;
      default:
        return FilterSortType.newPost;
    }
  }

  @override
  void write(BinaryWriter writer, FilterSortType obj) {
    switch (obj) {
      case FilterSortType.newPost:
        writer.writeByte(0);
        break;
      case FilterSortType.bestPost:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterSortTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListFilterAdapter extends TypeAdapter<ListFilter> {
  @override
  final int typeId = 14;

  @override
  ListFilter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListFilter.all;
      case 1:
        return ListFilter.top0;
      case 2:
        return ListFilter.top10;
      case 3:
        return ListFilter.top25;
      case 4:
        return ListFilter.top50;
      case 5:
        return ListFilter.top100;
      case 6:
        return ListFilter.daily;
      case 7:
        return ListFilter.weekly;
      case 8:
        return ListFilter.monthly;
      case 9:
        return ListFilter.yearly;
      case 10:
        return ListFilter.alltime;
      default:
        return ListFilter.all;
    }
  }

  @override
  void write(BinaryWriter writer, ListFilter obj) {
    switch (obj) {
      case ListFilter.all:
        writer.writeByte(0);
        break;
      case ListFilter.top0:
        writer.writeByte(1);
        break;
      case ListFilter.top10:
        writer.writeByte(2);
        break;
      case ListFilter.top25:
        writer.writeByte(3);
        break;
      case ListFilter.top50:
        writer.writeByte(4);
        break;
      case ListFilter.top100:
        writer.writeByte(5);
        break;
      case ListFilter.daily:
        writer.writeByte(6);
        break;
      case ListFilter.weekly:
        writer.writeByte(7);
        break;
      case ListFilter.monthly:
        writer.writeByte(8);
        break;
      case ListFilter.yearly:
        writer.writeByte(9);
        break;
      case ListFilter.alltime:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListHubFilterAdapter extends TypeAdapter<ListHubFilter> {
  @override
  final int typeId = 15;

  @override
  ListHubFilter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListHubFilter.subscribersAsc;
      case 1:
        return ListHubFilter.subscribersDesc;
      case 2:
        return ListHubFilter.rateAsc;
      case 3:
        return ListHubFilter.rateDesc;
      case 4:
        return ListHubFilter.titleAsc;
      case 5:
        return ListHubFilter.titleDesc;
      default:
        return ListHubFilter.subscribersAsc;
    }
  }

  @override
  void write(BinaryWriter writer, ListHubFilter obj) {
    switch (obj) {
      case ListHubFilter.subscribersAsc:
        writer.writeByte(0);
        break;
      case ListHubFilter.subscribersDesc:
        writer.writeByte(1);
        break;
      case ListHubFilter.rateAsc:
        writer.writeByte(2);
        break;
      case ListHubFilter.rateDesc:
        writer.writeByte(3);
        break;
      case ListHubFilter.titleAsc:
        writer.writeByte(4);
        break;
      case ListHubFilter.titleDesc:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListHubFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
