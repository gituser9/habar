// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserResponse _$SearchUserResponseFromJson(Map<String, dynamic> json) =>
    SearchUserResponse(
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      userRefs: (json['userRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UserRef.fromJson(e as Map<String, dynamic>)),
      ),
      pagesCount: (json['pagesCount'] as num).toInt(),
      searchStatistics: SearchStatistics.fromJson(
          json['searchStatistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchUserResponseToJson(SearchUserResponse instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
      'userRefs': instance.userRefs,
      'pagesCount': instance.pagesCount,
      'searchStatistics': instance.searchStatistics,
    };

SearchStatistics _$SearchStatisticsFromJson(Map<String, dynamic> json) =>
    SearchStatistics(
      articlesCount: (json['articlesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      hubsCount: (json['hubsCount'] as num).toInt(),
      usersCount: (json['usersCount'] as num).toInt(),
      companiesCount: (json['companiesCount'] as num).toInt(),
    );

Map<String, dynamic> _$SearchStatisticsToJson(SearchStatistics instance) =>
    <String, dynamic>{
      'articlesCount': instance.articlesCount,
      'commentsCount': instance.commentsCount,
      'hubsCount': instance.hubsCount,
      'usersCount': instance.usersCount,
      'companiesCount': instance.companiesCount,
    };

UserRef _$UserRefFromJson(Map<String, dynamic> json) => UserRef(
      scoreStats:
          ScoreStats.fromJson(json['scoreStats'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      id: json['id'] as String,
      login: json['login'] as String,
      alias: json['alias'] as String,
      fullname: json['fullname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      speciality: json['speciality'] as String,
    );

Map<String, dynamic> _$UserRefToJson(UserRef instance) => <String, dynamic>{
      'scoreStats': instance.scoreStats,
      'rating': instance.rating,
      'id': instance.id,
      'login': instance.login,
      'alias': instance.alias,
      'fullname': instance.fullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
    };

SearchHub _$SearchHubFromJson(Map<String, dynamic> json) => SearchHub(
      id: json['id'] as String,
      alias: json['alias'] as String,
      title: json['title'] as String,
      titleHtml: json['titleHtml'] as String,
    );

Map<String, dynamic> _$SearchHubToJson(SearchHub instance) => <String, dynamic>{
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
