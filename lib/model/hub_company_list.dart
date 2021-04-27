// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class HubCompanyList {
  HubCompanyList({
    required this.pagesCount,
    required this.companyIds,
    required this.companyRefs,
  });

  final int pagesCount;
  final List<String> companyIds;
  final Map<String, HubCompanyRef> companyRefs;

  factory HubCompanyList.fromJson(String str) => HubCompanyList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubCompanyList.fromMap(Map<String, dynamic> json) => HubCompanyList(
        pagesCount: json["pagesCount"] == null ? 0 : json["pagesCount"],
        companyIds: json["companyIds"] == null ? [] : List<String>.from(json["companyIds"].map((x) => x)),
        companyRefs: json["companyRefs"] == null
            ? {}
            : Map.from(json["companyRefs"]).map((k, v) => MapEntry<String, HubCompanyRef>(k, HubCompanyRef.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "pagesCount": pagesCount,
        "companyIds": List<dynamic>.from(companyIds.map((x) => x)),
        "companyRefs": Map.from(companyRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

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
  final String descriptionHtml;
  final String imageUrl;
  final Statistics statistics;

  factory HubCompanyRef.fromJson(String str) => HubCompanyRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubCompanyRef.fromMap(Map<String, dynamic> json) => HubCompanyRef(
        id: json["id"] == null ? '' : json["id"],
        alias: json["alias"] == null ? '' : json["alias"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        descriptionHtml: json["descriptionHtml"] == null ? '' : json["descriptionHtml"],
        imageUrl: json["imageUrl"] == null ? '' : json["imageUrl"],
        statistics: Statistics.fromMap(json["statistics"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "titleHtml": titleHtml,
        "descriptionHtml": descriptionHtml,
        "imageUrl": imageUrl,
        "statistics": statistics.toMap(),
      };
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

class Statistics {
  Statistics({
    required this.subscribersCount,
    required this.rating,
  });

  final int subscribersCount;
  final double rating;

  factory Statistics.fromJson(String str) => Statistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        subscribersCount: json["subscribersCount"] == null ? null : json["subscribersCount"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "subscribersCount": subscribersCount,
        "rating": rating,
      };
}

class EnumValues<T> {
  Map<String, T> map;

  EnumValues(this.map);
}
