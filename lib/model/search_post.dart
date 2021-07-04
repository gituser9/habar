// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:habar/model/author.dart';
import 'package:habar/model/post.dart';

class SearchPostResponse {
  SearchPostResponse({
    required this.searchStatistics,
    required this.pagesCount,
    required this.articleIds,
    required this.articleRefs,
  });

  SearchStatistics searchStatistics;
  int pagesCount;
  List<String> articleIds;
  Map<String, Post> articleRefs;

  factory SearchPostResponse.empty() => SearchPostResponse(
        searchStatistics: SearchStatistics.empty(),
        pagesCount: 0,
        articleIds: [],
        articleRefs: {},
      );

  factory SearchPostResponse.fromJson(String str) => SearchPostResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchPostResponse.fromMap(Map<String, dynamic> json) => SearchPostResponse(
        searchStatistics: SearchStatistics.fromMap(json["searchStatistics"]),
        pagesCount: json["pagesCount"] == null ? 0 : json["pagesCount"],
        articleIds: json["articleIds"] == null ? [] : List<String>.from(json["articleIds"].map((x) => x)),
        articleRefs: json["articleRefs"] == null ? {} : Map.from(json["articleRefs"]).map((k, v) => MapEntry<String, Post>(k, Post.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "searchStatistics": searchStatistics.toMap(),
        "pagesCount": pagesCount,
        "articleIds": List<dynamic>.from(articleIds.map((x) => x)),
        "articleRefs": Map.from(articleRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

// todo: delete?
class ArticleRef extends BasePost {
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
  BaseAuthor author;
  BaseStatistic statistics;
  List<Hub> hubs;
  final String textHtml = '';
  final LeadData leadData;

  factory ArticleRef.fromJson(String str) => ArticleRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleRef.fromMap(Map<String, dynamic> json) => ArticleRef(
        id: json["id"] == null ? 0 : json["id"],
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] == null ? false : json["isCorporative"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        author: Author.fromMap(json["author"]),
        statistics: Statistics.fromMap(json["statistics"]),
        leadData: LeadData.fromMap(json["leadData"]),
        hubs: json["hubs"] == null ? [] : List<Hub>.from(json["hubs"].map((x) => Hub.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "timePublished": timePublished.toIso8601String(),
        "isCorporative": isCorporative,
        "titleHtml": titleHtml,
        "author": author.toMap(),
        "statistics": statistics.toMap(),
        "hubs": List<dynamic>.from(hubs.map((x) => x.toMap())),
      };
}

class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  final String textHtml;
  final String imageUrl;

  factory LeadData.fromJson(String str) => LeadData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeadData.fromMap(Map<String, dynamic> json) => LeadData(
        textHtml: json["textHtml"] == null ? '' : json["textHtml"],
        imageUrl: json["imageUrl"] == null ? '' : json["imageUrl"],
      );

  Map<String, dynamic> toMap() => {
        "textHtml": textHtml,
        "imageUrl": imageUrl,
      };
}

class Author extends BaseAuthor {
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

  factory Author.fromJson(String str) => Author.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Author.fromMap(Map<String, dynamic> json) => Author(
        id: json["id"] == null ? '' : json["id"],
        login: json["login"] == null ? '' : json["login"],
        alias: json["alias"] == null ? '' : json["alias"],
        fullname: json["fullname"] == null ? '' : json["fullname"],
        avatarUrl: json["avatarUrl"] == null ? '' : json["avatarUrl"],
        speciality: json["speciality"] == null ? '' : json["speciality"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "login": login,
        "alias": alias,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "speciality": speciality,
      };
}

enum Alias { POPSCI, DEVELOP, MANAGEMENT, MARKETING, ADMIN }

final aliasValues = EnumValues(
    {"admin": Alias.ADMIN, "develop": Alias.DEVELOP, "management": Alias.MANAGEMENT, "marketing": Alias.MARKETING, "popsci": Alias.POPSCI});

enum Title { EMPTY, TITLE, PURPLE, FLUFFY, TENTACLED }

final titleValues = EnumValues(
    {"Научпоп": Title.EMPTY, "Маркетинг": Title.FLUFFY, "Менеджмент": Title.PURPLE, "Администрирование": Title.TENTACLED, "Разработка": Title.TITLE});

class Hub {
  Hub({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  String title;
  String titleHtml;

  factory Hub.fromJson(String str) => Hub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
        id: json["id"] == null ? '' : json["id"],
        alias: json["alias"] == null ? '' : json["alias"],
        title: json["title"] == null ? '' : json["title"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "title": title,
        "titleHtml": titleHtml,
      };
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

class PostImage {
  PostImage({
    required this.url,
  });

  String url;

  factory PostImage.fromJson(String str) => PostImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostImage.fromMap(Map<String, dynamic> json) => PostImage(
        url: json["url"] == null ? '' : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}

class Statistics extends BaseStatistic {
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

  factory Statistics.fromJson(String str) => Statistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        commentsCount: json["commentsCount"] == null ? 0 : json["commentsCount"],
        favoritesCount: json["favoritesCount"] == null ? 0 : json["favoritesCount"],
        readingCount: json["readingCount"] == null ? 0 : json["readingCount"],
        score: json["score"] == null ? 0 : json["score"],
        votesCount: json["votesCount"] == null ? 0 : json["votesCount"],
      );

  Map<String, dynamic> toMap() => {
        "commentsCount": commentsCount,
        "favoritesCount": favoritesCount,
        "readingCount": readingCount,
        "score": score,
        "votesCount": votesCount,
      };
}

enum Status { PUBLISHED }

final statusValues = EnumValues({"published": Status.PUBLISHED});

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

  factory SearchStatistics.fromJson(String str) => SearchStatistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchStatistics.fromMap(Map<String, dynamic> json) => SearchStatistics(
        articlesCount: json["articlesCount"] == null ? 0 : json["articlesCount"],
        commentsCount: json["commentsCount"] == null ? 0 : json["commentsCount"],
        hubsCount: json["hubsCount"] == null ? 0 : json["hubsCount"],
        usersCount: json["usersCount"] == null ? 0 : json["usersCount"],
        companiesCount: json["companiesCount"] == null ? 0 : json["companiesCount"],
      );

  Map<String, dynamic> toMap() => {
        "articlesCount": articlesCount,
        "commentsCount": commentsCount,
        "hubsCount": hubsCount,
        "usersCount": usersCount,
        "companiesCount": companiesCount,
      };
}

class EnumValues<T> {
  Map<String, T> map;

  EnumValues(this.map);

  Map<T, String> reverse() {
    return map.map((k, v) => new MapEntry(v, k));
  }
}
