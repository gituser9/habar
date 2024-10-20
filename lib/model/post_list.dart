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
  Map<String, Post> articleRefs;

  factory PostList.empty() => PostList(pagesCount: 0, articleIds: [], articleRefs: {});

  factory PostList.fromJson(String str) => PostList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostList.fromMap(Map<String, dynamic> json) => PostList(
        pagesCount: json["pagesCount"] ?? 0,
        articleIds: json["publicationIds"] == null ? [] : List<String>.from(json["publicationIds"].map((x) => x)),
        articleRefs: json["publicationRefs"] == null ? {} : _getPosts(json["publicationRefs"]),
      );

  Map<String, dynamic> toMap() => {
        "pagesCount": pagesCount,
        "articleIds": List<dynamic>.from(articleIds.map((x) => x)),
        "articleRefs": Map.from(articleRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };

  static Map<String, Post> _getPosts(Map<String, dynamic> json) {
    Map<String, Post> posts = {};

    json.forEach((key, value) {
      if (value['id'] == null) {
        return;
      }

      if (value['author'] == null) {
        return;
      }

      if (value['timePublished'] == null) {
        return;
      }

      posts[key] = Post.fromMap(value);
    });

    return posts;
  }
}

// todo: delete?
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

  @override
  String id;
  @override
  DateTime timePublished;
  bool isCorporative;
  @override
  String titleHtml;

  // PostType postType;
  // List<PostLabel> postLabels;
  @override
  BaseAuthor author;
  @override
  BaseStatistic statistics;
  List<PostHub> hubs;
  LeadData leadData;

  factory ArticleRef.fromJson(String str) => ArticleRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleRef.fromMap(Map<String, dynamic> json) => ArticleRef(
        id: json["id"] ?? 0,
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] ?? false,
        titleHtml: json["titleHtml"] ?? '',
        // postType: postTypeValues.map[json["postType"]] ?? PostType.ARTICLE,
        // postLabels: json["postLabels"] == null ? [] : List<PostLabel>.from(json["postLabels"].map((x) => PostLabel.fromMap(x))),
        author: PostAuthor.fromMap(json["author"]),
        statistics: PostStatistics.fromMap(json["statistics"]),
        leadData: LeadData.fromMap(json["leadData"]),
        hubs: json["hubs"] == null ? [] : List<PostHub>.from(json["hubs"].map((x) => PostHub.fromMap(x))),
      );

  @override
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
        textHtml: json["textHtml"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
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

  @override
  String id;
  String login;
  @override
  String alias;
  @override
  String fullname;
  @override
  String avatarUrl;
  @override
  String speciality;

  factory PostAuthor.fromJson(String str) => PostAuthor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostAuthor.fromMap(Map<String, dynamic> json) => PostAuthor(
        id: json["id"] ?? '',
        login: json["login"] ?? '',
        alias: json["alias"] ?? '',
        fullname: json["fullname"] ?? '',
        avatarUrl: json["avatarUrl"] ?? '',
        speciality: json["speciality"] ?? '',
      );

  @override
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
        id: json["id"] ?? '',
        alias: json["alias"] ?? '',
        title: json["title"] ?? '',
        titleHtml: json["titleHtml"] ?? '',
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
        type: json["type"] ?? '',
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
        originalAuthorName: json["originalAuthorName"] ?? '',
        originalUrl: json["originalUrl"] ?? '',
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

  @override
  int commentsCount;
  @override
  int favoritesCount;
  @override
  int readingCount;
  @override
  int score;
  @override
  int votesCount;

  factory PostStatistics.fromJson(String str) => PostStatistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostStatistics.fromMap(Map<String, dynamic> json) => PostStatistics(
        commentsCount: json["commentsCount"] ?? 0,
        favoritesCount: json["favoritesCount"] ?? 0,
        readingCount: json["readingCount"] ?? 0,
        score: json["score"] ?? 0,
        votesCount: json["votesCount"] ?? 0,
      );

  @override
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
    return map.map((k, v) => MapEntry(v, k));
  }
}
