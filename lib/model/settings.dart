import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 11)
enum AppThemeType {
  @HiveField(0)
  light,

  @HiveField(1)
  dark,
}

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

  @HiveField(5)
  AppThemeType? theme;

  Settings({
    this.isShowImage = true,
    this.isShowPostPreview = false,
    this.postTextSize = 18,
    this.commentTextSize = 18,
    this.isInfinityScroll = false,
    this.theme = AppThemeType.light,
  });

  factory Settings.empty() => Settings(
        isShowImage: true,
        isShowPostPreview: false,
        postTextSize: 18,
        commentTextSize: 18,
        isInfinityScroll: false,
        theme: AppThemeType.light,
      );

  void setDefault() {
    if (isInfinityScroll == null) {
      isInfinityScroll = false;
    }

    if (theme == null) {
      theme = AppThemeType.light;
    }
  }
}
