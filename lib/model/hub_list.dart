import 'dart:convert';

class HubList {
  HubList({
    required this.pagesCount,
    required this.hubIds,
    required this.hubRefs,
  });

  final int pagesCount;
  final List<String> hubIds;
  final Map<String, HubRef> hubRefs;

  factory HubList.fromJson(String str) => HubList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubList.fromMap(Map<String, dynamic> json) => HubList(
        pagesCount: json["pagesCount"] == null ? 0 : json["pagesCount"],
        hubIds: json["hubIds"] == null ? [] : List<String>.from(json["hubIds"].map((x) => x)),
        hubRefs: json["hubRefs"] == null ? {} : Map.from(json["hubRefs"]).map((k, v) => MapEntry<String, HubRef>(k, HubRef.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "pagesCount": pagesCount,
        "hubIds": List<dynamic>.from(hubIds.map((x) => x)),
        "hubRefs": Map.from(hubRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

class HubRef {
  HubRef({
    required this.id,
    required this.alias,
    required this.titleHtml,
    required this.imageUrl,
    required this.descriptionHtml,
    required this.statistics,
  });

  final String id;
  final String alias;
  final String titleHtml;
  final String imageUrl;
  final String descriptionHtml;
  final Statistics statistics;

  factory HubRef.fromJson(String str) => HubRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubRef.fromMap(Map<String, dynamic> json) => HubRef(
        id: json["id"] == null ? null : json["id"],
        alias: json["alias"] == null ? null : json["alias"],
        titleHtml: json["titleHtml"] == null ? null : json["titleHtml"],
        imageUrl: json["imageUrl"] == null ? '' : json["imageUrl"],
        descriptionHtml: json["descriptionHtml"] == null ? '' : json["descriptionHtml"],
        statistics: Statistics.fromMap(json["statistics"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "titleHtml": titleHtml,
        "imageUrl": imageUrl,
        "descriptionHtml": descriptionHtml,
        "statistics": statistics.toMap(),
      };
}

class Statistics {
  Statistics({
    required this.subscribersCount,
    required this.rating,
    required this.authorsCount,
    required this.postsCount,
  });

  final int subscribersCount;
  final double rating;
  final int authorsCount;
  final int postsCount;

  factory Statistics.fromJson(String str) => Statistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        subscribersCount: json["subscribersCount"] == null ? 0 : json["subscribersCount"],
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
        authorsCount: json["authorsCount"] == null ? 0 : json["authorsCount"],
        postsCount: json["postsCount"] == null ? 0 : json["postsCount"],
      );

  Map<String, dynamic> toMap() => {
        "subscribersCount": subscribersCount,
        "rating": rating,
        "authorsCount": authorsCount,
        "postsCount": postsCount,
      };
}
