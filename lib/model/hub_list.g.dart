// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubList _$HubListFromJson(Map<String, dynamic> json) => HubList(
      pagesCount: (json['pagesCount'] as num).toInt(),
      hubIds:
          (json['hubIds'] as List<dynamic>).map((e) => e as String).toList(),
      hubRefs: (json['hubRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, HubRef.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$HubListToJson(HubList instance) => <String, dynamic>{
      'pagesCount': instance.pagesCount,
      'hubIds': instance.hubIds,
      'hubRefs': instance.hubRefs,
    };

HubRef _$HubRefFromJson(Map<String, dynamic> json) => HubRef(
      id: json['id'] as String,
      alias: json['alias'] as String,
      titleHtml: json['titleHtml'] as String,
      imageUrl: json['imageUrl'] as String,
      descriptionHtml: json['descriptionHtml'] as String,
      statistics:
          Statistics.fromJson(json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HubRefToJson(HubRef instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'titleHtml': instance.titleHtml,
      'imageUrl': instance.imageUrl,
      'descriptionHtml': instance.descriptionHtml,
      'statistics': instance.statistics,
    };

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      subscribersCount: (json['subscribersCount'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      authorsCount: (json['authorsCount'] as num).toInt(),
      postsCount: (json['postsCount'] as num).toInt(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'subscribersCount': instance.subscribersCount,
      'rating': instance.rating,
      'authorsCount': instance.authorsCount,
      'postsCount': instance.postsCount,
    };
