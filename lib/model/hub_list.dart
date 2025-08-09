import 'package:json_annotation/json_annotation.dart';

part 'hub_list.g.dart';

@JsonSerializable()
class HubList {
  HubList({
    required this.pagesCount,
    required this.hubIds,
    required this.hubRefs,
  });

  final int pagesCount;
  final List<String> hubIds;
  final Map<String, HubRef> hubRefs;

  factory HubList.empty() => HubList(pagesCount: 0, hubIds: [], hubRefs: {});

  factory HubList.fromJson(Map<String, dynamic> json) => _$HubListFromJson(json);

  Map<String, dynamic> toMap() => _$HubListToJson(this);
}

@JsonSerializable()
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
  Statistics statistics;

  factory HubRef.fromJson(Map<String, dynamic> json) => _$HubRefFromJson(json);

  Map<String, dynamic> toMap() => _$HubRefToJson(this);
}

@JsonSerializable()
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

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

  Map<String, dynamic> toMap() => _$StatisticsToJson(this);

  factory Statistics.empty() => Statistics(subscribersCount: 0, rating: 0, authorsCount: 0, postsCount: 0);
}
