import 'package:habar/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_post.g.dart';

@JsonSerializable()
class SearchPostResponse {
  SearchPostResponse({
    required this.searchStatistics,
    required this.pagesCount,
    required this.publicationIds,
    required this.publicationRefs,
  });

  SearchStatistics searchStatistics;
  int pagesCount;
  List<String> publicationIds;
  Map<String, Post> publicationRefs;

  factory SearchPostResponse.empty() => SearchPostResponse(
        searchStatistics: SearchStatistics.empty(),
        pagesCount: 0,
        publicationIds: [],
        publicationRefs: {},
      );

  factory SearchPostResponse.fromJson(Map<String, dynamic> json) => _$SearchPostResponseFromJson(json);
}

// todo: delete?
@JsonSerializable()
class ArticleRef {
  ArticleRef({
    required this.id,
    required this.timePublished,
    required this.isCorporative,
    required this.titleHtml,
    required this.author,
    required this.statistics,
    required this.hubs,
    required this.leadData,
  });

  String id;
  DateTime timePublished;
  bool isCorporative;
  String titleHtml;
  Author author;
  Statistics statistics;
  List<SearchPostHub> hubs;
  final String textHtml = '';
  final LeadData leadData;

  factory ArticleRef.fromJson(Map<String, dynamic> json) => _$ArticleRefFromJson(json);
}

@JsonSerializable()
class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  final String textHtml;
  final String imageUrl;

  factory LeadData.fromJson(Map<String, dynamic> json) => _$LeadDataFromJson(json);
}

@JsonSerializable()
class Author {
  Author({
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  String id;
  String login;
  String alias;
  String fullname;
  String avatarUrl;
  String speciality;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

enum Alias {
  POPSCI,
  DEVELOP,
  MANAGEMENT,
  MARKETING,
  ADMIN,
}

final aliasValues = EnumValues({
  "admin": Alias.ADMIN,
  "develop": Alias.DEVELOP,
  "management": Alias.MANAGEMENT,
  "marketing": Alias.MARKETING,
  "popsci": Alias.POPSCI,
});

enum Title {
  EMPTY,
  TITLE,
  PURPLE,
  FLUFFY,
  TENTACLED,
}

final titleValues = EnumValues({
  "Научпоп": Title.EMPTY,
  "Маркетинг": Title.FLUFFY,
  "Менеджмент": Title.PURPLE,
  "Администрирование": Title.TENTACLED,
  "Разработка": Title.TITLE,
});

@JsonSerializable()
class SearchPostHub {
  SearchPostHub({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  String title;
  String titleHtml;

  factory SearchPostHub.fromJson(Map<String, dynamic> json) => _$SearchPostHubFromJson(json);
}

enum Type {
  COLLECTIVE,
  CORPORATIVE,
}

final typeValues = EnumValues({
  "collective": Type.COLLECTIVE,
  "corporative": Type.CORPORATIVE,
});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

@JsonSerializable()
class PostImage {
  PostImage({
    required this.url,
  });

  String url;

  factory PostImage.fromJson(Map<String, dynamic> json) => _$PostImageFromJson(json);
}

@JsonSerializable()
class Statistics {
  Statistics({
    required this.commentsCount,
    required this.favoritesCount,
    required this.readingCount,
    required this.score,
    required this.votesCount,
  });

  int commentsCount;
  int favoritesCount;
  int readingCount;
  int score;
  int votesCount;

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);
}

enum Status { PUBLISHED }

final statusValues = EnumValues({"published": Status.PUBLISHED});

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

class EnumValues<T> {
  Map<String, T> map;

  EnumValues(this.map);

  Map<T, String> reverse() {
    return map.map((k, v) => MapEntry(v, k));
  }
}
