// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchPostResponse _$SearchPostResponseFromJson(Map<String, dynamic> json) =>
    SearchPostResponse(
      searchStatistics: SearchStatistics.fromJson(
          json['searchStatistics'] as Map<String, dynamic>),
      pagesCount: (json['pagesCount'] as num).toInt(),
      publicationIds: (json['publicationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      publicationRefs: (json['publicationRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Post.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SearchPostResponseToJson(SearchPostResponse instance) =>
    <String, dynamic>{
      'searchStatistics': instance.searchStatistics,
      'pagesCount': instance.pagesCount,
      'publicationIds': instance.publicationIds,
      'publicationRefs': instance.publicationRefs,
    };

ArticleRef _$ArticleRefFromJson(Map<String, dynamic> json) => ArticleRef(
      id: json['id'] as String,
      timePublished: DateTime.parse(json['timePublished'] as String),
      isCorporative: json['isCorporative'] as bool,
      titleHtml: json['titleHtml'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      statistics:
          Statistics.fromJson(json['statistics'] as Map<String, dynamic>),
      hubs: (json['hubs'] as List<dynamic>)
          .map((e) => SearchPostHub.fromJson(e as Map<String, dynamic>))
          .toList(),
      leadData: LeadData.fromJson(json['leadData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleRefToJson(ArticleRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timePublished': instance.timePublished.toIso8601String(),
      'isCorporative': instance.isCorporative,
      'titleHtml': instance.titleHtml,
      'author': instance.author,
      'statistics': instance.statistics,
      'hubs': instance.hubs,
      'leadData': instance.leadData,
    };

LeadData _$LeadDataFromJson(Map<String, dynamic> json) => LeadData(
      textHtml: json['textHtml'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$LeadDataToJson(LeadData instance) => <String, dynamic>{
      'textHtml': instance.textHtml,
      'imageUrl': instance.imageUrl,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: json['id'] as String,
      login: json['login'] as String,
      alias: json['alias'] as String,
      fullname: json['fullname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      speciality: json['speciality'] as String,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'alias': instance.alias,
      'fullname': instance.fullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
    };

SearchPostHub _$SearchPostHubFromJson(Map<String, dynamic> json) =>
    SearchPostHub(
      id: json['id'] as String,
      alias: json['alias'] as String,
      title: json['title'] as String,
      titleHtml: json['titleHtml'] as String,
    );

Map<String, dynamic> _$SearchPostHubToJson(SearchPostHub instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'title': instance.title,
      'titleHtml': instance.titleHtml,
    };

PostImage _$PostImageFromJson(Map<String, dynamic> json) => PostImage(
      url: json['url'] as String,
    );

Map<String, dynamic> _$PostImageToJson(PostImage instance) => <String, dynamic>{
      'url': instance.url,
    };

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      commentsCount: (json['commentsCount'] as num).toInt(),
      favoritesCount: (json['favoritesCount'] as num).toInt(),
      readingCount: (json['readingCount'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      votesCount: (json['votesCount'] as num).toInt(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'commentsCount': instance.commentsCount,
      'favoritesCount': instance.favoritesCount,
      'readingCount': instance.readingCount,
      'score': instance.score,
      'votesCount': instance.votesCount,
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
