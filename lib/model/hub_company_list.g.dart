// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_company_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubCompanyList _$HubCompanyListFromJson(Map<String, dynamic> json) =>
    HubCompanyList(
      pagesCount: (json['pagesCount'] as num).toInt(),
      companyIds: (json['companyIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      companyRefs: (json['companyRefs'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, HubCompanyRef.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$HubCompanyListToJson(HubCompanyList instance) =>
    <String, dynamic>{
      'pagesCount': instance.pagesCount,
      'companyIds': instance.companyIds,
      'companyRefs': instance.companyRefs,
    };

HubCompanyRef _$HubCompanyRefFromJson(Map<String, dynamic> json) =>
    HubCompanyRef(
      id: json['id'] as String,
      alias: json['alias'] as String,
      titleHtml: json['titleHtml'] as String,
      descriptionHtml: json['descriptionHtml'] as String?,
      imageUrl: json['imageUrl'] as String,
      statistics:
          Statistics.fromJson(json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HubCompanyRefToJson(HubCompanyRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'titleHtml': instance.titleHtml,
      'descriptionHtml': instance.descriptionHtml,
      'imageUrl': instance.imageUrl,
      'statistics': instance.statistics,
    };

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      subscribersCount: (json['subscribersCount'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'subscribersCount': instance.subscribersCount,
      'rating': instance.rating,
    };
