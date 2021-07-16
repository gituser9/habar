import 'package:hive/hive.dart';

part 'post_position.g.dart';

@HiveType(typeId: 9)
class PostPosition {
  PostPosition({
    required this.postId,
    required this.position,
  });

  @HiveField(0)
  final String postId;
  @HiveField(1)
  final double position;

  factory PostPosition.empty() => PostPosition(postId: '', position: 0);
}
