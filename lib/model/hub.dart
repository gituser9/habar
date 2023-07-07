import 'dart:convert';

class Hub {
  Hub({
    required this.alias,
    required this.titleHtml,
    required this.descriptionHtml,
    required this.fullDescriptionHtml,
    required this.imageUrl,
    required this.statistics,
  });

  final String alias;
  final String titleHtml;
  final String descriptionHtml;
  final String fullDescriptionHtml;
  final String imageUrl;
  final Statistics statistics;

  factory Hub.empty() => Hub(
        alias: '',
        titleHtml: '',
        descriptionHtml: '',
        fullDescriptionHtml: '',
        imageUrl: '',
        statistics: Statistics.empty(),
      );

  factory Hub.fromJson(String str) => Hub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
        alias: json["alias"],
        titleHtml: json["titleHtml"],
        descriptionHtml: json["descriptionHtml"],
        fullDescriptionHtml: json["fullDescriptionHtml"],
        imageUrl: json["imageUrl"],
        statistics: Statistics.fromMap(json["statistics"]),
      );

  Map<String, dynamic> toMap() => {
        "alias": alias,
        "titleHtml": titleHtml,
        "descriptionHtml": descriptionHtml,
        "fullDescriptionHtml": fullDescriptionHtml,
        "imageUrl": imageUrl,
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

  factory Statistics.empty() => Statistics(
        subscribersCount: 0,
        rating: 0,
        authorsCount: 0,
        postsCount: 0,
      );

  factory Statistics.fromJson(String str) => Statistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        subscribersCount: json["subscribersCount"],
        rating: json["rating"]?.toDouble(),
        authorsCount: json["authorsCount"],
        postsCount: json["postsCount"],
      );

  Map<String, dynamic> toMap() => {
        "subscribersCount": subscribersCount,
        "rating": rating,
        "authorsCount": authorsCount,
        "postsCount": postsCount,
      };
}
