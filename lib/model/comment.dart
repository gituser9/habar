import 'package:habar/model/author.dart';

class StructuredComment {
  BaseAuthor author;
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
