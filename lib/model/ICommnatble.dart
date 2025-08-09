abstract class ICommentable {
  DateTime publishTime();

  String authorAlias();

  String avatarUrl();

  String fullName();

  String title();

  int commentsCount();

  int votesCount();

  int readingCount();

  int favoritesCount();

  String itemId();
}
