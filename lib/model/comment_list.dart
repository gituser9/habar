import 'package:habar/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_list.g.dart';

@JsonSerializable()
class CommentList {
  CommentList({
    required this.comments,
    this.commentAccess,
    this.lastCommentTimestamp,
  });

  Map<String, Comment> comments;
  CommentAccess? commentAccess;
  int? lastCommentTimestamp;

  factory CommentList.fromJson(Map<String, dynamic> json) => _$CommentListFromJson(json);

  Map<String, dynamic> toMap() => _$CommentListToJson(this);
}

@JsonSerializable()
class CommentAccess {
  CommentAccess({
    this.isCanComment,
    this.cantCommentReasonKey,
    this.cantCommentReason,
  });

  bool? isCanComment;
  String? cantCommentReasonKey;
  String? cantCommentReason;

  factory CommentAccess.fromJson(Map<String, dynamic> json) => _$CommentAccessFromJson(json);

  Map<String, dynamic> toMap() => _$CommentAccessToJson(this);
}

@JsonSerializable()
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
  String? parentId;
  int? level;
  DateTime? timePublished;
  int score;
  int votesCount;
  String message;
  Author? author;
  bool isAuthor;
  bool isPostAuthor;
  List<String> children;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toMap() => _$CommentToJson(this);
}
