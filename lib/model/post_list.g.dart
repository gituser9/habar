// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostList _$PostListFromJson(Map<String, dynamic> json) => PostList(
      pagesCount: (json['pagesCount'] as num).toInt(),
      publicationIds: (json['publicationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      publicationRefs: (json['publicationRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Post.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$PostListToJson(PostList instance) => <String, dynamic>{
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
          .map((e) => PostHub.fromJson(e as Map<String, dynamic>))
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

PostAuthor _$PostAuthorFromJson(Map<String, dynamic> json) => PostAuthor(
      id: json['id'] as String,
      login: json['login'] as String,
      alias: json['alias'] as String,
      fullname: json['fullname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      speciality: json['speciality'] as String,
    );

Map<String, dynamic> _$PostAuthorToJson(PostAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'alias': instance.alias,
      'fullname': instance.fullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
    };

PostHub _$PostHubFromJson(Map<String, dynamic> json) => PostHub(
      id: json['id'] as String,
      alias: json['alias'] as String,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      title: json['title'] as String,
      titleHtml: json['titleHtml'] as String,
    );

Map<String, dynamic> _$PostHubToJson(PostHub instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'type': _$TypeEnumMap[instance.type]!,
      'title': instance.title,
      'titleHtml': instance.titleHtml,
    };

const _$TypeEnumMap = {
  Type.COLLECTIVE: 'COLLECTIVE',
  Type.CORPORATIVE: 'CORPORATIVE',
};

PostLabel _$PostLabelFromJson(Map<String, dynamic> json) => PostLabel(
      type: json['type'] as String,
    );

Map<String, dynamic> _$PostLabelToJson(PostLabel instance) => <String, dynamic>{
      'type': instance.type,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      originalAuthorName: json['originalAuthorName'] as String,
      originalUrl: json['originalUrl'] as String,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'originalAuthorName': instance.originalAuthorName,
      'originalUrl': instance.originalUrl,
    };

PostStatistics _$PostStatisticsFromJson(Map<String, dynamic> json) =>
    PostStatistics(
      commentsCount: (json['commentsCount'] as num).toInt(),
      favoritesCount: (json['favoritesCount'] as num).toInt(),
      readingCount: (json['readingCount'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      votesCount: (json['votesCount'] as num).toInt(),
    );

Map<String, dynamic> _$PostStatisticsToJson(PostStatistics instance) =>
    <String, dynamic>{
      'commentsCount': instance.commentsCount,
      'favoritesCount': instance.favoritesCount,
      'readingCount': instance.readingCount,
      'score': instance.score,
      'votesCount': instance.votesCount,
    };
