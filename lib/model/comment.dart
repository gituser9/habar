import 'package:habar/model/post.dart';

class StructuredComment {
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
  });
}
