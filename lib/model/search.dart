enum SearchFilter {
  relevance,
  date,
  rating,
}

extension ParseToString on SearchFilter {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
