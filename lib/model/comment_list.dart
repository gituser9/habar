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
        lastCommentTimestamp: json["lastCommentTimestamp"] == null ? null : json["lastCommentTimestamp"],
      );

  Map<String, dynamic> toMap() => {
        "comments": Map.from(comments).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "commentAccess": commentAccess == null ? null : commentAccess?.toMap(),
        "lastCommentTimestamp": lastCommentTimestamp == null ? null : lastCommentTimestamp,
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
        isCanComment: json["isCanComment"] == null ? null : json["isCanComment"],
        cantCommentReasonKey: json["cantCommentReasonKey"] == null ? null : json["cantCommentReasonKey"],
        cantCommentReason: json["cantCommentReason"] == null ? null : json["cantCommentReason"],
      );

  Map<String, dynamic> toMap() => {
        "isCanComment": isCanComment == null ? null : isCanComment,
        "cantCommentReasonKey": cantCommentReasonKey == null ? null : cantCommentReasonKey,
        "cantCommentReason": cantCommentReason == null ? null : cantCommentReason,
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
  DateTime timePublished;
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
        id: json["id"] == null ? '' : json["id"],
        parentId: json["parentId"] == null ? '' : json["parentId"],
        level: json["level"] == null ? 0 : json["level"],
        timePublished: DateTime.parse(json["timePublished"]),
        score: json["score"] == null ? 0 : json["score"],
        votesCount: json["votesCount"] == null ? 0 : json["votesCount"],
        message: json["message"] == null ? '' : json["message"],
        author: Author.fromMap(json["author"]),
        isAuthor: json["isAuthor"] == null ? false : json["isAuthor"],
        isPostAuthor: json["isPostAuthor"] == null ? false : json["isPostAuthor"],
        children: json["children"] == null ? [] : List<String>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "parentId": parentId,
        "level": level,
        "timePublished": timePublished.toIso8601String(),
        "score": score,
        "votesCount": votesCount,
        "message": message,
        "author": author.toMap(),
        "isAuthor": isAuthor,
        "isPostAuthor": isPostAuthor,
        "children": List<dynamic>.from(children.map((x) => x)),
      };
}

// class Author extends BaseAuthor {
//   Author({
//     required this.id,
//     required this.login,
//     required this.alias,
//     required this.fullname,
//     required this.avatarUrl,
//   });

//   String id;
//   String login;
//   String alias;
//   String fullname;
//   String avatarUrl;

//   factory Author.fromJson(String str) => Author.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Author.fromMap(Map<String, dynamic> json) => Author(
//         id: json["id"] == null ? 0 : json["id"],
//         login: json["login"] == null ? '' : json["login"],
//         alias: json["alias"] == null ? '' : json["alias"],
//         fullname: json["fullname"] == null ? '' : json["fullname"],
//         avatarUrl: json["avatarUrl"] == null ? '' : json["avatarUrl"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "login": login,
//         "alias": alias,
//         "fullname": fullname,
//         "avatarUrl": avatarUrl,
//       };
// }
