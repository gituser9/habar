import 'package:json_annotation/json_annotation.dart';

part 'search_user.g.dart';

@JsonSerializable()
class SearchUserResponse {
  SearchUserResponse({
    required this.userIds,
    required this.userRefs,
    required this.pagesCount,
    required this.searchStatistics,
  });

  List<String> userIds;
  Map<String, UserRef> userRefs;
  int pagesCount;
  SearchStatistics searchStatistics;

  factory SearchUserResponse.empty() => SearchUserResponse(
        userIds: [],
        userRefs: {},
        pagesCount: 0,
        searchStatistics: SearchStatistics.empty(),
      );

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) => _$SearchUserResponseFromJson(json);
}

@JsonSerializable()
class SearchStatistics {
  SearchStatistics({
    required this.articlesCount,
    required this.commentsCount,
    required this.hubsCount,
    required this.usersCount,
    required this.companiesCount,
  });

  int articlesCount;
  int commentsCount;
  int hubsCount;
  int usersCount;
  int companiesCount;

  factory SearchStatistics.empty() => SearchStatistics(
        articlesCount: 0,
        commentsCount: 0,
        hubsCount: 0,
        usersCount: 0,
        companiesCount: 0,
      );

  factory SearchStatistics.fromJson(Map<String, dynamic> json) => _$SearchStatisticsFromJson(json);
}

@JsonSerializable()
class UserRef {
  UserRef({
    required this.scoreStats,
    required this.rating,
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  ScoreStats scoreStats;
  double rating;
  String id;
  String login;
  String alias;
  String fullname;
  String avatarUrl;
  String speciality;

  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
}

@JsonSerializable()
class SearchHub {
  SearchHub({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  String title;
  String titleHtml;

  factory SearchHub.fromJson(Map<String, dynamic> json) => _$SearchHubFromJson(json);
}

@JsonSerializable()
class ScoreStats {
  ScoreStats({
    required this.score,
    required this.votesCount,
  });

  double score;
  int votesCount;

  factory ScoreStats.fromJson(Map<String, dynamic> json) => _$ScoreStatsFromJson(json);
}
