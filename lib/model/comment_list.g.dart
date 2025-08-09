// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentList _$CommentListFromJson(Map<String, dynamic> json) => CommentList(
      comments: (json['comments'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Comment.fromJson(e as Map<String, dynamic>)),
      ),
      commentAccess: json['commentAccess'] == null
          ? null
          : CommentAccess.fromJson(
              json['commentAccess'] as Map<String, dynamic>),
      lastCommentTimestamp: (json['lastCommentTimestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommentListToJson(CommentList instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'commentAccess': instance.commentAccess,
      'lastCommentTimestamp': instance.lastCommentTimestamp,
    };

CommentAccess _$CommentAccessFromJson(Map<String, dynamic> json) =>
    CommentAccess(
      isCanComment: json['isCanComment'] as bool?,
      cantCommentReasonKey: json['cantCommentReasonKey'] as String?,
      cantCommentReason: json['cantCommentReason'] as String?,
    );

Map<String, dynamic> _$CommentAccessToJson(CommentAccess instance) =>
    <String, dynamic>{
      'isCanComment': instance.isCanComment,
      'cantCommentReasonKey': instance.cantCommentReasonKey,
      'cantCommentReason': instance.cantCommentReason,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      level: (json['level'] as num?)?.toInt(),
      timePublished: json['timePublished'] == null
          ? null
          : DateTime.parse(json['timePublished'] as String),
      score: (json['score'] as num).toInt(),
      votesCount: (json['votesCount'] as num).toInt(),
      message: json['message'] as String,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      isAuthor: json['isAuthor'] as bool,
      children:
          (json['children'] as List<dynamic>).map((e) => e as String).toList(),
      isPostAuthor: json['isPostAuthor'] as bool,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'level': instance.level,
      'timePublished': instance.timePublished?.toIso8601String(),
      'score': instance.score,
      'votesCount': instance.votesCount,
      'message': instance.message,
      'author': instance.author,
      'isAuthor': instance.isAuthor,
      'isPostAuthor': instance.isPostAuthor,
      'children': instance.children,
    };
