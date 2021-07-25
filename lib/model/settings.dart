import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 10)
class Settings {
  @HiveField(0)
  bool isShowImage;

  @HiveField(1)
  bool isShowPostPreview;

  @HiveField(2)
  double postTextSize;

  @HiveField(3)
  double commentTextSize;

  Settings({
    required this.isShowImage,
    required this.isShowPostPreview,
    required this.postTextSize,
    required this.commentTextSize,
  });

  factory Settings.empty() => Settings(
        isShowImage: true,
        isShowPostPreview: false,
        postTextSize: 18,
        commentTextSize: 18,
      );
}
