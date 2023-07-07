import 'dart:convert';

import 'package:habar/model/post.dart';

class CommentList {
  CommentList({
    required this.comments,
    this.commentAccess,
    this.lastCommentTimestamp,
  });

  Map<String, Comment> comments;
  CommentAccess? commentAccess;
  int? lastCommentTimestamp;

  factory CommentList.fromJson(String str) => CommentList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommentList.fromMap(Map<String, dynamic> json) => CommentList(
        comments: json["comments"] == null ? {} : Map.from(json["comments"]).map((k, v) => MapEntry<String, Comment>(k, Comment.fromMap(v))),
        commentAccess: json["commentAccess"] == null ? null : CommentAccess.fromMap(json["commentAccess"]),
        lastCommentTimestamp: json["lastCommentTimestamp"],
      );

  Map<String, dynamic> toMap() => {
        "comments": Map.from(comments).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "commentAccess": commentAccess?.toMap(),
        "lastCommentTimestamp": lastCommentTimestamp,
      };
}

class CommentAccess {
  CommentAccess({
    this.isCanComment,
    this.cantCommentReasonKey,
    this.cantCommentReason,
  });

  bool? isCanComment;
  String? cantCommentReasonKey;
  String? cantCommentReason;

  factory CommentAccess.fromJson(String str) => CommentAccess.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommentAccess.fromMap(Map<String, dynamic> json) => CommentAccess(
        isCanComment: json["isCanComment"],
        cantCommentReasonKey: json["cantCommentReasonKey"],
        cantCommentReason: json["cantCommentReason"],
      );

  Map<String, dynamic> toMap() => {
        "isCanComment": isCanComment,
        "cantCommentReasonKey": cantCommentReasonKey,
        "cantCommentReason": cantCommentReason,
      };
}

class Comment {
  Comment({
    required this.id,
    required this.parentId,
    required this.level,
    required this.timePublished,
    required this.score,
    required this.votesCount,
    required this.message,
    required this.author,
    required this.isAuthor,
    required this.children,
    required this.isPostAuthor,
  });

  String id;
  String parentId;
  int level;
  DateTime? timePublished;
  int score;
  int votesCount;
  String message;
  Author author;
  bool isAuthor;
  bool isPostAuthor;
  List<String> children;

  factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: json["id"] ?? '',
        parentId: json["parentId"] ?? '',
        level: json["level"] ?? 0,
        timePublished: json["timePublished"] == null ? null : DateTime.parse(json["timePublished"]),
        score: json["score"] ?? 0,
        votesCount: json["votesCount"] ?? 0,
        message: json["message"] ?? '',
        author: json["author"] == null ? Author.empty() : Author.fromMap(json["author"]),
        isAuthor: json["isAuthor"] ?? false,
        isPostAuthor: json["isPostAuthor"] ?? false,
        children: json["children"] == null ? [] : List<String>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "parentId": parentId,
        "level": level,
        "timePublished": timePublished?.toIso8601String(),
        "score": score,
        "votesCount": votesCount,
        "message": message,
        "author": author.toMap(),
        "isAuthor": isAuthor,
        "isPostAuthor": isPostAuthor,
        "children": List<dynamic>.from(children.map((x) => x)),
      };
}
