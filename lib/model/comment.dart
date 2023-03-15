import 'package:habar/model/post.dart';

import 'comment_list.dart';

class StructuredComment {
  String id;
  Author author;
  DateTime publishTime;
  String text;
  bool isPostAuthor;
  int level;
  int score;
  List<StructuredComment> children = [];

  StructuredComment({
    required this.author,
    required this.publishTime,
    required this.text,
    required this.isPostAuthor,
    required this.level,
    required this.score,
    required this.id,
  });

  factory StructuredComment.fromComment(Comment comment) => StructuredComment(
        author: comment.author,
        publishTime: comment.timePublished!,
        text: comment.message,
        isPostAuthor: comment.isPostAuthor,
        level: comment.level,
        score: comment.score,
        id: comment.id,
      );
}
