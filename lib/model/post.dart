import 'dart:convert';

import 'package:habar/model/ICommnatble.dart';
import 'package:habar/model/author.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

abstract class BasePost {
  final String id = '';
  final String textHtml = '';
  final String titleHtml = '';
  final DateTime timePublished = DateTime.now();
  late Statistics statistics;
  late BaseAuthor author;

  Map<String, dynamic> toMap();
}

@JsonSerializable()
@HiveType(typeId: 1)
class Post implements ICommentable {
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
    required this.readingTime,
    required this.complexity,
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
  List<PostLabel>? postLabels;
  @HiveField(7)
  Author? author;
  @HiveField(8)
  Statistics? statistics;
  @HiveField(9)
  List<HubData>? hubs;
  @HiveField(10)
  List<Tag> tags;
  @HiveField(11)
  String status;
  @HiveField(12)
  String? textHtml;
  @HiveField(13)
  LeadData leadData;
  @HiveField(14)
  int? readingTime;
  @HiveField(15)
  String? complexity;

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
        readingTime: 0,
        complexity: '',
      );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toMap() => _$PostToJson(this);

  @override
  String authorAlias() {
    return author?.alias ?? '';
  }

  @override
  String avatarUrl() {
    return author?.avatarUrl ?? '';
  }

  @override
  int commentsCount() {
    return statistics?.commentsCount ?? 0;
  }

  @override
  int favoritesCount() {
    return statistics?.favoritesCount ?? 0;
  }

  @override
  String fullName() {
    return author?.fullname ?? '';
  }

  @override
  DateTime publishTime() {
    return timePublished;
  }

  @override
  int readingCount() {
    return statistics?.readingCount ?? 0;
  }

  @override
  int votesCount() {
    return statistics?.votesCount ?? 0;
  }

  @override
  String title() {
    return titleHtml;
  }

  @override
  String itemId() {
    return id;
  }
}

// todo: separate file
@JsonSerializable()
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
  ScoreStats? scoreStats;
  @HiveField(1)
  String id;
  @HiveField(2)
  String? login;
  @HiveField(3)
  String alias;
  @HiveField(4)
  String? fullname;
  @HiveField(5)
  String? avatarUrl;
  @HiveField(6)
  String? speciality;

  factory Author.empty() => Author(
        scoreStats: ScoreStats.empty(),
        id: '',
        login: '',
        alias: '',
        fullname: '',
        avatarUrl: '',
        speciality: '',
      );

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => _$AuthorToJson(this);
}

@JsonSerializable()
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

  factory ScoreStats.fromJson(Map<String, dynamic> json) => _$ScoreStatsFromJson(json);

  Map<String, dynamic> toMap() => _$ScoreStatsToJson(this);
}

@JsonSerializable()
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

  factory HubData.fromJson(Map<String, dynamic> json) => _$HubDataFromJson(json);

  Map<String, dynamic> toMap() => _$HubDataToJson(this);
}

// todo: delete?
@JsonSerializable()
class Img {
  Img({
    required this.url,
  });

  String url;

  factory Img.fromJson(Map<String, dynamic> json) => _$ImgFromJson(json);

  Map<String, dynamic> toMap() => _$ImgToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 5)
class PostLabel {
  PostLabel({
    required this.type,
  });

  @HiveField(0)
  String type;

  factory PostLabel.fromJson(Map<String, dynamic> json) => _$PostLabelFromJson(json);

  Map<String, dynamic> toMap() => _$PostLabelToJson(this);
}

@JsonSerializable()
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

  factory Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => _$StatisticsToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 7)
class Tag {
  Tag({
    required this.titleHtml,
  });

  @HiveField(0)
  String titleHtml;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toMap() => _$TagToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 8)
class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  @HiveField(0)
  final String textHtml;
  @HiveField(1)
  final String? imageUrl;

  factory LeadData.empty() => LeadData(textHtml: '', imageUrl: '');

  factory LeadData.fromJson(Map<String, dynamic> json) => _$LeadDataFromJson(json);

  Map<String, dynamic> toMap() => _$LeadDataToJson(this);
}
