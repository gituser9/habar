import 'package:json_annotation/json_annotation.dart';

part 'hub_authors.g.dart';

@JsonSerializable()
class HubAuthorList {
  HubAuthorList({
    required this.pagesCount,
    required this.authorIds,
    required this.authorRefs,
  });

  final int pagesCount;
  final List<String> authorIds;
  final Map<String, HubAuthorRef> authorRefs;

  factory HubAuthorList.fromJson(Map<String, dynamic> json) => _$HubAuthorListFromJson(json);

  Map<String, dynamic> toMap() => _$HubAuthorListToJson(this);
}

@JsonSerializable()
class HubAuthorRef {
  HubAuthorRef({
    required this.scoreStats,
    required this.rating,
    required this.id,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  final ScoreStats scoreStats;
  final double rating;

  final String id;
  final String alias;
  final String? fullname;
  final String? avatarUrl;
  final String? speciality;

  factory HubAuthorRef.fromJson(Map<String, dynamic> json) => _$HubAuthorRefFromJson(json);

  Map<String, dynamic> toMap() => _$HubAuthorRefToJson(this);
}

@JsonSerializable()
class HubShort {
  HubShort({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  final String id;
  final String alias;
  final String title;
  final String titleHtml;

  factory HubShort.fromJson(Map<String, dynamic> json) => _$HubShortFromJson(json);

  Map<String, dynamic> toMap() => _$HubShortToJson(this);
}

@JsonSerializable()
class ScoreStats {
  ScoreStats({
    required this.score,
    required this.votesCount,
  });

  final double score;
  final int votesCount;

  factory ScoreStats.fromJson(Map<String, dynamic> json) => _$ScoreStatsFromJson(json);

  Map<String, dynamic> toMap() => _$ScoreStatsToJson(this);
}
