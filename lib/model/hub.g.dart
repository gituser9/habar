// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hub _$HubFromJson(Map<String, dynamic> json) => Hub(
      alias: json['alias'] as String,
      titleHtml: json['titleHtml'] as String,
      descriptionHtml: json['descriptionHtml'] as String,
      fullDescriptionHtml: json['fullDescriptionHtml'] as String,
      imageUrl: json['imageUrl'] as String,
      statistics:
          Statistics.fromJson(json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HubToJson(Hub instance) => <String, dynamic>{
      'alias': instance.alias,
      'titleHtml': instance.titleHtml,
      'descriptionHtml': instance.descriptionHtml,
      'fullDescriptionHtml': instance.fullDescriptionHtml,
      'imageUrl': instance.imageUrl,
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
