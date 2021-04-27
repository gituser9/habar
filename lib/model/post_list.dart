// To parse this JSON data, do
//
//     final postList = postListFromMap(jsonString);

import 'dart:convert';

import 'package:habar/model/author.dart';
import 'package:habar/model/post.dart';

class PostList {
  PostList({
    required this.pagesCount,
    required this.articleIds,
    required this.articleRefs,
  });

  int pagesCount;
  List<String> articleIds;
  Map<String, ArticleRef> articleRefs;

  factory PostList.fromJson(String str) => PostList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostList.fromMap(Map<String, dynamic> json) => PostList(
        pagesCount: json["pagesCount"] == null ? 0 : json["pagesCount"],
        articleIds: json["articleIds"] == null ? [] : List<String>.from(json["articleIds"].map((x) => x)),
        articleRefs:
            json["articleRefs"] == null ? {} : Map.from(json["articleRefs"]).map((k, v) => MapEntry<String, ArticleRef>(k, ArticleRef.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "pagesCount": pagesCount,
        "articleIds": List<dynamic>.from(articleIds.map((x) => x)),
        "articleRefs": Map.from(articleRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

class ArticleRef extends BasePost {
  ArticleRef({
    required this.id,
    required this.timePublished,
    required this.isCorporative,
    required this.titleHtml,
    // required this.postType,
    // required this.postLabels,
    required this.author,
    required this.statistics,
    required this.hubs,
    required this.leadData,
  });

  String id;
  DateTime timePublished;
  bool isCorporative;
  String titleHtml;
  // PostType postType;
  // List<PostLabel> postLabels;
  BaseAuthor author;
  BaseStatistic statistics;
  List<PostHub> hubs;
  LeadData leadData;

  factory ArticleRef.fromJson(String str) => ArticleRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleRef.fromMap(Map<String, dynamic> json) => ArticleRef(
        id: json["id"] == null ? 0 : json["id"],
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] == null ? false : json["isCorporative"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        // postType: postTypeValues.map[json["postType"]] ?? PostType.ARTICLE,
        // postLabels: json["postLabels"] == null ? [] : List<PostLabel>.from(json["postLabels"].map((x) => PostLabel.fromMap(x))),
        author: PostAuthor.fromMap(json["author"]),
        statistics: PostStatistics.fromMap(json["statistics"]),
        leadData: LeadData.fromMap(json["leadData"]),
        hubs: json["hubs"] == null ? [] : List<PostHub>.from(json["hubs"].map((x) => PostHub.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "timePublished": timePublished.toIso8601String(),
        "isCorporative": isCorporative,
        "titleHtml": titleHtml,
        "postType": postTypeValues.reverse(),
        // "postLabels": List<dynamic>.from(postLabels.map((x) => x.toMap())),
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

class PostAuthor extends BaseAuthor {
  PostAuthor({
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

  factory PostAuthor.fromJson(String str) => PostAuthor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostAuthor.fromMap(Map<String, dynamic> json) => PostAuthor(
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

class PostHub {
  PostHub({
    required this.id,
    required this.alias,
    required this.type,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  Type type;
  String title;
  String titleHtml;

  factory PostHub.fromJson(String str) => PostHub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostHub.fromMap(Map<String, dynamic> json) => PostHub(
        id: json["id"] == null ? '' : json["id"],
        alias: json["alias"] == null ? '' : json["alias"],
        title: json["title"] == null ? '' : json["title"],
        titleHtml: json["titleHtml"] == null ? '' : json["titleHtml"],
        type: typeValues.map[json["type"]] ?? Type.COLLECTIVE,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "type": typeValues.reverse(),
        "title": title,
        "titleHtml": titleHtml,
      };
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

class PostLabel {
  PostLabel({
    required this.type,
    // required this.data,
  });

  String type;
  // Data data;

  factory PostLabel.fromJson(String str) => PostLabel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostLabel.fromMap(Map<String, dynamic> json) => PostLabel(
        type: json["type"] == null ? '' : json["type"],
        // data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        // "data": data.toMap(),
      };
}

class Data {
  Data({
    required this.originalAuthorName,
    required this.originalUrl,
  });

  String originalAuthorName;
  String originalUrl;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        originalAuthorName: json["originalAuthorName"] == null ? '' : json["originalAuthorName"],
        originalUrl: json["originalUrl"] == null ? '' : json["originalUrl"],
      );

  Map<String, dynamic> toMap() => {
        "originalAuthorName": originalAuthorName,
        "originalUrl": originalUrl,
      };
}

enum PostType { ARTICLE }

final postTypeValues = EnumValues({"article": PostType.ARTICLE});

class PostStatistics extends BaseStatistic {
  PostStatistics({
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

  factory PostStatistics.fromJson(String str) => PostStatistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostStatistics.fromMap(Map<String, dynamic> json) => PostStatistics(
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

class EnumValues<T> {
  Map<String, T> map;
  // Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> reverse() {
    return map.map((k, v) => new MapEntry(v, k));
  }
}
