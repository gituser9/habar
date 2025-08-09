import 'package:json_annotation/json_annotation.dart';

part 'hub_company_list.g.dart';

@JsonSerializable()
class HubCompanyList {
  HubCompanyList({
    required this.pagesCount,
    required this.companyIds,
    required this.companyRefs,
  });

  final int pagesCount;
  final List<String> companyIds;
  final Map<String, HubCompanyRef> companyRefs;

  factory HubCompanyList.fromJson(Map<String, dynamic> json) => _$HubCompanyListFromJson(json);

  Map<String, dynamic> toMap() => _$HubCompanyListToJson(this);
}

@JsonSerializable()
class HubCompanyRef {
  HubCompanyRef({
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
  final Statistics statistics;

  factory HubCompanyRef.fromJson(Map<String, dynamic> json) => _$HubCompanyRefFromJson(json);

  Map<String, dynamic> toMap() => _$HubCompanyRefToJson(this);
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

@JsonSerializable()
class Statistics {
  Statistics({
    required this.subscribersCount,
    required this.rating,
  });

  final int subscribersCount;
  final double rating;

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

  Map<String, dynamic> toMap() => _$StatisticsToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;

  EnumValues(this.map);
}
