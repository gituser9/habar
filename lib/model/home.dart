enum HomeMode {
  posts,
  news,
  hubs,
  saved,
}

enum PostContentType {
  articles,
  news,
  posts,
}

class SavedFilter {
  String title = '';
  String hub = '';
  String tag = '';
}
