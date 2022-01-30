import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'filter.g.dart';

@HiveType(typeId: 12)
class Filter {
  @HiveField(0)
  var sortType = FilterSortType.newPost;

  @HiveField(1)
  var sortValue = listFilterData[ListFilter.all]!;

  @HiveField(2)
  var filterKey = ListFilter.all;

  @HiveField(3)
  var hubFilter = ListHubFilter.rateDesc;
}

class UserFilter {
  var sortType = FilterSortType.newPost.obs;
  var sortValue = listFilterData[ListFilter.all]!.obs;
  var filterKey = ListFilter.all.obs;
  var hubFilter = ListHubFilter.rateDesc.obs;

  UserFilter();

  factory UserFilter.fromFilter(Filter filter) => UserFilter()
    ..sortType = filter.sortType.obs
    ..sortValue = filter.sortValue.obs
    ..filterKey = filter.filterKey.obs
    ..hubFilter = filter.hubFilter.obs;
}

@HiveType(typeId: 13)
enum FilterSortType {
  @HiveField(0)
  newPost,

  @HiveField(1)
  bestPost,
}

@HiveType(typeId: 14)
enum ListFilter {
  @HiveField(0)
  all,

  @HiveField(1)
  top0,

  @HiveField(2)
  top10,

  @HiveField(3)
  top25,

  @HiveField(4)
  top50,

  @HiveField(5)
  top100,

  @HiveField(6)
  daily,

  @HiveField(7)
  weekly,

  @HiveField(8)
  monthly,

  @HiveField(9)
  yearly,

  @HiveField(10)
  alltime,
}

class FlowFilter {
  String flow = '';
  String? score = '';
  String period = 'all';
}

final Map<ListFilter, String> flowScore = {
  ListFilter.top0: '0',
  ListFilter.top10: '10',
  ListFilter.top25: '25',
  ListFilter.top50: '50',
  ListFilter.top100: '100',
};

final Map<ListFilter, String> flowPeriod = {
  ListFilter.daily: 'daily',
  ListFilter.weekly: 'weekly',
  ListFilter.monthly: 'monthly',
  ListFilter.yearly: 'yearly',
  ListFilter.alltime: 'alltime',
};

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

@HiveType(typeId: 15)
enum ListHubFilter {
  @HiveField(0)
  subscribersAsc,

  @HiveField(1)
  subscribersDesc,

  @HiveField(2)
  rateAsc,

  @HiveField(3)
  rateDesc,

  @HiveField(4)
  titleAsc,

  @HiveField(5)
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
