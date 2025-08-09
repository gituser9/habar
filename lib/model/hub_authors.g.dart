// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_authors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubAuthorList _$HubAuthorListFromJson(Map<String, dynamic> json) =>
    HubAuthorList(
      pagesCount: (json['pagesCount'] as num).toInt(),
      authorIds:
          (json['authorIds'] as List<dynamic>).map((e) => e as String).toList(),
      authorRefs: (json['authorRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, HubAuthorRef.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$HubAuthorListToJson(HubAuthorList instance) =>
    <String, dynamic>{
      'pagesCount': instance.pagesCount,
      'authorIds': instance.authorIds,
      'authorRefs': instance.authorRefs,
    };

HubAuthorRef _$HubAuthorRefFromJson(Map<String, dynamic> json) => HubAuthorRef(
      scoreStats:
          ScoreStats.fromJson(json['scoreStats'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      id: json['id'] as String,
      alias: json['alias'] as String,
      fullname: json['fullname'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      speciality: json['speciality'] as String?,
    );

Map<String, dynamic> _$HubAuthorRefToJson(HubAuthorRef instance) =>
    <String, dynamic>{
      'scoreStats': instance.scoreStats,
      'rating': instance.rating,
      'id': instance.id,
      'alias': instance.alias,
      'fullname': instance.fullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
    };

HubShort _$HubShortFromJson(Map<String, dynamic> json) => HubShort(
      id: json['id'] as String,
      alias: json['alias'] as String,
      title: json['title'] as String,
      titleHtml: json['titleHtml'] as String,
    );

Map<String, dynamic> _$HubShortToJson(HubShort instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'title': instance.title,
      'titleHtml': instance.titleHtml,
    };

ScoreStats _$ScoreStatsFromJson(Map<String, dynamic> json) => ScoreStats(
      score: (json['score'] as num).toDouble(),
      votesCount: (json['votesCount'] as num).toInt(),
    );

Map<String, dynamic> _$ScoreStatsToJson(ScoreStats instance) =>
    <String, dynamic>{
      'score': instance.score,
      'votesCount': instance.votesCount,
    };
