class Filter {
  late FilterSortType sortType;
  late Map<String, String> sortValue;
  late ListFilter filterKey;
  late ListHubFilter hubFilter;
}

enum FilterSortType {
  newPost,
  bestPost,
}

enum ListFilter {
  all,
  top0,
  top10,
  top25,
  top50,
  top100,
  daily,
  weekly,
  monthly,
  yearly,
  alltime,
}

final Map<ListFilter, Map<String, String>> listFilterData = {
  ListFilter.all: {'sort': 'rating'},
  ListFilter.top0: {'sort': 'rating', 'score': '0'},
  ListFilter.top10: {'sort': 'rating', 'score': '10'},
  ListFilter.top25: {'sort': 'rating', 'score': '25'},
  ListFilter.top50: {'sort': 'rating', 'score': '50'},
  ListFilter.top100: {'sort': 'rating', 'score': '100'},
  ListFilter.daily: {'period': 'daily', 'sort': 'date'},
  ListFilter.weekly: {'period': 'weekly', 'sort': 'date'},
  ListFilter.monthly: {'period': 'monthly', 'sort': 'date'},
  ListFilter.yearly: {'period': 'yearly', 'sort': 'date'},
  ListFilter.alltime: {'period': 'alltime', 'sort': 'date'},
};

enum ListHubFilter {
  subscribersAsc,
  subscribersDesc,
  rateAsc,
  rateDesc,
  titleAsc,
  titleDesc,
}

class HubFilter {}

final Map<ListHubFilter, Map<String, String>> listHubFilterData = {
  ListHubFilter.titleAsc: {'sort': 'title', 'order': 'asc'},
  ListHubFilter.titleDesc: {'sort': 'title', 'order': 'desc'},
  ListHubFilter.rateDesc: {'sort': 'rating', 'order': 'desc'}, // default
  ListHubFilter.rateAsc: {'sort': 'rating', 'order': 'asc'},
  ListHubFilter.subscribersAsc: {'sort': 'subscribers', 'order': 'asc'},
  ListHubFilter.subscribersDesc: {'sort': 'subscribers', 'order': 'desc'},
};