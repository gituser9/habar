import 'dart:convert';

import 'package:habar/model/author.dart';
import 'package:hive/hive.dart';

part 'post.g.dart';

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

  Map<String, dynamic> toMap();
}

@HiveType(typeId: 1)
class Post {
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
    required this.leadData,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime timePublished;
  @HiveField(2)
  bool isCorporative;
  @HiveField(3)
  String lang;
  @HiveField(4)
  String titleHtml;
  @HiveField(5)
  String postType;
  @HiveField(6)
  List<PostLabel> postLabels;
  @HiveField(7)
  Author author;
  @HiveField(8)
  Statistics statistics;
  @HiveField(9)
  List<HubData> hubs;
  @HiveField(10)
  List<Tag> tags;
  @HiveField(11)
  String status;
  @HiveField(12)
  String textHtml;
  @HiveField(13)
  LeadData leadData;

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
        leadData: LeadData.empty(),
      );

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? '' : json["id"],
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] == null ? false : json["isCorporative"],
        lang: json["lang"] == null ? '' : json["lang"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        postType: json["postType"] == null ? '' : json["postType"],
        postLabels: json["postLabels"] == null ? [] : List<PostLabel>.from(json["postLabels"].map((x) => PostLabel.fromMap(x))),
        author: Author.fromMap(json["author"]),
        statistics: Statistics.fromMap(json["statistics"]),
        hubs: json["hubs"] == null ? [] : List<HubData>.from(json["hubs"].map((x) => HubData.fromMap(x))),
        textHtml: json["textHtml"] == null ? '' : json["textHtml"],
        tags: json["tags"] == null ? [] : List<Tag>.from(json["tags"].map((x) => Tag.fromMap(x))),
        status: json["status"] == null ? '' : json["status"],
        leadData: json["status"] == null ? LeadData.empty() : LeadData.fromMap(json["leadData"]),
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

// todo: separate file
@HiveType(typeId: 2)
class Author {
  Author({
    required this.scoreStats,
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  @HiveField(0)
  ScoreStats scoreStats;
  @HiveField(1)
  String id;
  @HiveField(2)
  String login;
  @HiveField(3)
  String alias;
  @HiveField(4)
  String fullname;
  @HiveField(5)
  String avatarUrl;
  @HiveField(6)
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
        scoreStats: json["scoreStats"] == null ? ScoreStats.empty() : ScoreStats.fromMap(json["scoreStats"]),
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

@HiveType(typeId: 3)
class ScoreStats {
  ScoreStats({
    required this.score,
    required this.votesCount,
  });

  @HiveField(0)
  double score;
  @HiveField(1)
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

@HiveType(typeId: 4)
class HubData {
  HubData({
    required this.id,
    required this.alias,
    required this.type,
    required this.title,
    required this.titleHtml,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String alias;
  @HiveField(2)
  String type;
  @HiveField(3)
  String title;
  @HiveField(4)
  String titleHtml;

  factory HubData.fromJson(String str) => HubData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubData.fromMap(Map<String, dynamic> json) => HubData(
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

// todo: delete?
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

@HiveType(typeId: 5)
class PostLabel {
  PostLabel({
    required this.type,
  });

  @HiveField(0)
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

@HiveType(typeId: 6)
class Statistics {
  Statistics({
    required this.commentsCount,
    required this.favoritesCount,
    required this.readingCount,
    required this.score,
    required this.votesCount,
  });

  @HiveField(0)
  int commentsCount;
  @HiveField(1)
  int favoritesCount;
  @HiveField(2)
  int readingCount;
  @HiveField(3)
  int score;
  @HiveField(4)
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

@HiveType(typeId: 7)
class Tag {
  Tag({
    required this.titleHtml,
  });

  @HiveField(0)
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

@HiveType(typeId: 8)
class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  @HiveField(0)
  final String textHtml;
  @HiveField(1)
  final String imageUrl;

  factory LeadData.empty() => LeadData(textHtml: '', imageUrl: '');

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
