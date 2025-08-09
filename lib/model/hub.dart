import 'package:json_annotation/json_annotation.dart';

part 'hub.g.dart';

@JsonSerializable()
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

  factory Hub.fromJson(Map<String, dynamic> json) => _$HubFromJson(json);

  Map<String, dynamic> toMap() => _$HubToJson(this);
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

  factory Statistics.empty() => Statistics(
        subscribersCount: 0,
        rating: 0,
        authorsCount: 0,
        postsCount: 0,
      );

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

  Map<String, dynamic> toMap() => _$StatisticsToJson(this);
}
