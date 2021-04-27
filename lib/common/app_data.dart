import 'package:habar/model/filter.dart';

// TODO: to DB
class AppData {
  static Filter filter = Filter()
    ..filterKey = ListFilter.all
    ..sortType = FilterSortType.newPost
    ..sortValue = listFilterData[ListFilter.all]!
    ..hubFilter = ListHubFilter.rateDesc;
}
