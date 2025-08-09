// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyList _$CompanyListFromJson(Map<String, dynamic> json) => CompanyList(
      companyRefs: (json['companyRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Company.fromJson(e as Map<String, dynamic>)),
      ),
      pagesCount: (json['pagesCount'] as num).toInt(),
      companyIds: (json['companyIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CompanyListToJson(CompanyList instance) =>
    <String, dynamic>{
      'pagesCount': instance.pagesCount,
      'companyRefs': instance.companyRefs,
      'companyIds': instance.companyIds,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: json['id'] as String,
      alias: json['alias'] as String,
      titleHtml: json['titleHtml'] as String,
      descriptionHtml: json['descriptionHtml'] as String?,
      imageUrl: json['imageUrl'] as String,
      statistics:
          CompanyStat.fromJson(json['statistics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'titleHtml': instance.titleHtml,
      'descriptionHtml': instance.descriptionHtml,
      'imageUrl': instance.imageUrl,
      'statistics': instance.statistics,
    };

CompanyStat _$CompanyStatFromJson(Map<String, dynamic> json) => CompanyStat(
      rating: (json['rating'] as num).toDouble(),
      subscribersCount: (json['subscribersCount'] as num).toInt(),
    );

Map<String, dynamic> _$CompanyStatToJson(CompanyStat instance) =>
    <String, dynamic>{
      'subscribersCount': instance.subscribersCount,
      'rating': instance.rating,
    };
