import 'dart:convert';

import 'package:habar/model/author.dart';

abstract class BaseStatistic {
  final int commentsCount = 0;
  final int favoritesCount = 0;
  final int readingCount = 0;
  final int score = 0;
  final int votesCount = 0;

  Map<String, dynamic> toMap();
}

abstract class BasePost {
  final String id = '';
  final String textHtml = '';
  final String titleHtml = '';
  final DateTime timePublished = DateTime.now();
  late BaseStatistic statistics;
  late BaseAuthor author;
}

// To parse this JSON data, do
//
//     final post = postFromMap(jsonString);

class Post extends BasePost {
  Post({
    required this.id,
    required this.timePublished,
    required this.isCorporative,
    required this.lang,
    required this.titleHtml,
    required this.postType,
    required this.postLabels,
    required this.author,
    required this.statistics,
    required this.hubs,
    required this.textHtml,
    required this.status,
    required this.tags,
  });

  String id;
  DateTime timePublished;
  bool isCorporative;
  String lang;
  String titleHtml;
  String postType;
  List<PostLabel> postLabels;
  BaseAuthor author;
  BaseStatistic statistics;
  List<Hub> hubs;
  List<Tag> tags;
  String status;
  String textHtml;

  factory Post.empty() => Post(
        id: '',
        timePublished: DateTime.now(),
        isCorporative: false,
        lang: '',
        titleHtml: '',
        postType: '',
        postLabels: [],
        author: Author.empty(),
        statistics: Statistics.empty(),
        hubs: [],
        textHtml: '',
        status: '',
        tags: [],
      );

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] == null ? null : json["isCorporative"],
        lang: json["lang"] == null ? null : json["lang"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        postType: json["postType"] == null ? null : json["postType"],
        postLabels:
            json["postLabels"] == null ? [] : List<PostLabel>.from(json["postLabels"].map((x) => PostLabel.fromMap(x))),
        author: Author.fromMap(json["author"]),
        statistics: Statistics.fromMap(json["statistics"]),
        hubs: json["hubs"] == null ? [] : List<Hub>.from(json["hubs"].map((x) => Hub.fromMap(x))),
        textHtml: json["textHtml"] == null ? null : json["textHtml"],
        tags: json["tags"] == null ? [] : List<Tag>.from(json["tags"].map((x) => Tag.fromMap(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "timePublished": timePublished.toIso8601String(),
        "isCorporative": isCorporative,
        "lang": lang,
        "titleHtml": titleHtml,
        "postType": postType,
        "postLabels": List<dynamic>.from(postLabels.map((x) => x.toMap())),
        "author": author.toMap(),
        "statistics": statistics.toMap(),
        "hubs": List<dynamic>.from(hubs.map((x) => x.toMap())),
        "textHtml": textHtml,
        "tags": List<dynamic>.from(tags.map((x) => x.toMap())),
        "status": status,
      };
}

class Author extends BaseAuthor {
  Author({
    required this.scoreStats,
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  ScoreStats scoreStats;
  String id;
  String login;
  String alias;
  String fullname;
  String avatarUrl;
  String speciality;

  factory Author.empty() => Author(
        scoreStats: ScoreStats.empty(),
        id: '',
        login: '',
        alias: '',
        fullname: '',
        avatarUrl: '',
        speciality: '',
      );

  factory Author.fromJson(String str) => Author.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Author.fromMap(Map<String, dynamic> json) => Author(
        scoreStats: ScoreStats.fromMap(json["scoreStats"]),
        id: json["id"] == null ? 0 : json["id"],
        login: json["login"] == null ? '' : json["login"],
        alias: json["alias"] == null ? '' : json["alias"],
        fullname: json["fullname"] == null ? '' : json["fullname"],
        avatarUrl: json["avatarUrl"] == null ? '' : json["avatarUrl"],
        speciality: json["speciality"] == null ? '' : json["speciality"],
      );

  Map<String, dynamic> toMap() => {
        "scoreStats": scoreStats.toMap(),
        "id": id,
        "login": login,
        "alias": alias,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "speciality": speciality,
      };
}

class ScoreStats {
  ScoreStats({
    required this.score,
    required this.votesCount,
  });

  double score;
  int votesCount;

  factory ScoreStats.empty() => ScoreStats(score: 0.0, votesCount: 0);

  factory ScoreStats.fromJson(String str) => ScoreStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScoreStats.fromMap(Map<String, dynamic> json) => ScoreStats(
        score: json["score"] == null ? 0.0 : json["score"].toDouble(),
        votesCount: json["votesCount"] == null ? 0 : json["votesCount"],
      );

  Map<String, dynamic> toMap() => {
        "score": score,
        "votesCount": votesCount,
      };
}

class Hub {
  Hub({
    required this.id,
    required this.alias,
    required this.type,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  String type;
  String title;
  String titleHtml;

  factory Hub.fromJson(String str) => Hub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
        id: json["id"] == null ? '' : json["id"],
        alias: json["alias"] == null ? '' : json["alias"],
        type: json["type"] == null ? '' : json["type"],
        title: json["title"] == null ? '' : json["title"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "type": type,
        "title": title,
        "titleHtml": titleHtml,
      };
}

class Img {
  Img({
    required this.url,
  });

  String url;

  factory Img.fromJson(String str) => Img.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Img.fromMap(Map<String, dynamic> json) => Img(
        url: json["url"] == null ? '' : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}

class PostLabel {
  PostLabel({
    required this.type,
  });

  String type;

  factory PostLabel.fromJson(String str) => PostLabel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostLabel.fromMap(Map<String, dynamic> json) => PostLabel(
        type: json["type"] == null ? '' : json["type"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
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

  factory Statistics.empty() => Statistics(
        commentsCount: 0,
        favoritesCount: 0,
        readingCount: 0,
        score: 0,
        votesCount: 0,
      );

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

class Tag {
  Tag({
    required this.titleHtml,
  });

  String titleHtml;

  factory Tag.fromJson(String str) => Tag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tag.fromMap(Map<String, dynamic> json) => Tag(
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
      );

  Map<String, dynamic> toMap() => {
        "titleHtml": titleHtml,
      };
}
