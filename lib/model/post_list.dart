import 'package:habar/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_list.g.dart';

@JsonSerializable()
class PostList {
  PostList({
    required this.pagesCount,
    required this.publicationIds,
    required this.publicationRefs,
  });

  int pagesCount;
  List<String> publicationIds;
  Map<String, Post> publicationRefs;

  factory PostList.empty() => PostList(pagesCount: 0, publicationIds: [], publicationRefs: {});

  factory PostList.fromJson(Map<String, dynamic> json) => _$PostListFromJson(json);

  Map<String, dynamic> toMap() => _$PostListToJson(this);
}

// todo: delete?
@JsonSerializable()
class ArticleRef {
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
  Author author;
  Statistics statistics;
  List<PostHub> hubs;
  LeadData leadData;

  factory ArticleRef.fromJson(Map<String, dynamic> json) => _$ArticleRefFromJson(json);

  // factory ArticleRef.fromJson(String str) => ArticleRef.fromMap(json.decode(str));
  //
  // String toJson() => json.encode(toMap());

  /*factory ArticleRef.fromMap(Map<String, dynamic> json) => ArticleRef(
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
      );*/

  Map<String, dynamic> toMap() => _$ArticleRefToJson(this);
}

@JsonSerializable()
class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  final String textHtml;
  final String imageUrl;

  // factory LeadData.fromJson(String str) => LeadData.fromMap(json.decode(str));
  factory LeadData.fromJson(Map<String, dynamic> json) => _$LeadDataFromJson(json);

  Map<String, dynamic> toMap() => _$LeadDataToJson(this);
}

@JsonSerializable()
class PostAuthor {
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

  // factory PostAuthor.fromJson(String str) => PostAuthor.fromMap(json.decode(str));
  factory PostAuthor.fromJson(Map<String, dynamic> json) => _$PostAuthorFromJson(json);

  Map<String, dynamic> toMap() => _$PostAuthorToJson(this);
}

@JsonSerializable()
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

  // factory PostHub.fromJson(String str) => PostHub.fromMap(json.decode(str));
  factory PostHub.fromJson(Map<String, dynamic> json) => _$PostHubFromJson(json);

  Map<String, dynamic> toMap() => _$PostHubToJson(this);
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

@JsonSerializable()
class PostLabel {
  PostLabel({
    required this.type,
    // required this.data,
  });

  String type;

  // Data data;

  factory PostLabel.fromJson(Map<String, dynamic> json) => _$PostLabelFromJson(json);

  Map<String, dynamic> toMap() => _$PostLabelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.originalAuthorName,
    required this.originalUrl,
  });

  String originalAuthorName;
  String originalUrl;

  // factory Data.fromJson(String str) => Data.fromMap(json.decode(str));
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toMap() => _$DataToJson(this);
}

enum PostType { ARTICLE }

final postTypeValues = EnumValues({"article": PostType.ARTICLE});

@JsonSerializable()
class PostStatistics {
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

  // factory PostStatistics.fromJson(String str) => PostStatistics.fromMap(json.decode(str));
  factory PostStatistics.fromJson(Map<String, dynamic> json) => _$PostStatisticsFromJson(json);

  Map<String, dynamic> toMap() => _$PostStatisticsToJson(this);
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
