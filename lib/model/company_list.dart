import 'package:json_annotation/json_annotation.dart';

part 'company_list.g.dart';

@JsonSerializable()
class CompanyList {
  CompanyList({
    required this.companyRefs,
    required this.pagesCount,
    required this.companyIds,
  });

  final int pagesCount;
  final Map<String, Company> companyRefs;
  final List<String> companyIds;

  factory CompanyList.fromJson(Map<String, dynamic> json) => _$CompanyListFromJson(json);
}

@JsonSerializable()
class Company {
  Company({
    required this.id,
    required this.alias,
    required this.titleHtml,
    required this.descriptionHtml,
    required this.imageUrl,
    required this.statistics,
  });

  final String id;
  final String alias;
  final String titleHtml;
  final String? descriptionHtml;
  final String imageUrl;
  final CompanyStat statistics;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}

@JsonSerializable()
class CompanyStat {
  CompanyStat({
    required this.rating,
    required this.subscribersCount,
  });

  final int subscribersCount;
  final double rating;

  factory CompanyStat.fromJson(Map<String, dynamic> json) => _$CompanyStatFromJson(json);
}
