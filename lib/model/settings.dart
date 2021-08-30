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

  @HiveField(4)
  bool? isInfinityScroll;

  Settings({
    this.isShowImage = true,
    this.isShowPostPreview = false,
    this.postTextSize = 18,
    this.commentTextSize = 18,
    this.isInfinityScroll = false,
  });

  factory Settings.empty() => Settings(
        isShowImage: true,
        isShowPostPreview: false,
        postTextSize: 18,
        commentTextSize: 18,
        isInfinityScroll: false,
      );

  void setDefault() {
    if (isInfinityScroll == null) {
      isInfinityScroll = false;
    }
  }
}
