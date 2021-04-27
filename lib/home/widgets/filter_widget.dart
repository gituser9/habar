import 'package:flutter/material.dart';
import 'package:habar/common/app_data.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/home/home_bloc.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';

class FilterWidget extends StatefulWidget {
  final Filter filter;
  final HomeBloc bloc;

  FilterWidget({
    required this.filter,
    required this.bloc,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState(filter: filter, bloc: bloc);
}

class _FilterWidgetState extends State<FilterWidget> {
  final textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  final HomeBloc bloc;
  Filter filter = AppData.filter;

  _FilterWidgetState({
    required this.filter,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        children: [
          _getFilter(),
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);

                    if (bloc.pageMode == HomeMode.posts) {
                      AppData.filter = filter;
                      await bloc.getAll(AppData.filter.filterKey);
                    } else {
                      await bloc.getHubs(filterKey: filter.hubFilter);
                    }
                  },
                  icon: const Icon(Icons.done_all, color: Colors.white),
                  label: const Text('Применить', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getFilter() {
    return bloc.pageMode == HomeMode.posts ? _buildPostsFilter() : _buildHubFilter();
  }

  Widget _buildPostsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Сначала показывать', style: textStyle),
        _buildTypeButtons(),
        Text('Порог рейтинга', style: textStyle),
        const SizedBox(height: 10),
        _buildScoreButtonsRow(),
      ],
    );
  }

  Widget _buildHubFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Сортировать по', style: textStyle),
        const SizedBox(height: 10),
        Wrap(
          children: [
            _buildHubFilterButton(true, 'Название', ListHubFilter.titleDesc),
            _buildHubFilterButton(false, 'Название', ListHubFilter.titleAsc),
            _buildHubFilterButton(true, 'Рейтинг', ListHubFilter.rateDesc),
            _buildHubFilterButton(false, 'Рейтинг', ListHubFilter.rateAsc),
            _buildHubFilterButton(true, 'Подписчики', ListHubFilter.subscribersDesc),
            _buildHubFilterButton(false, 'Подписчики', ListHubFilter.subscribersAsc),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButtons() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
            height: 40,
            padding: const EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.all(const Radius.circular(15)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            filter.sortType = FilterSortType.newPost;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: filter.sortType == FilterSortType.newPost
                              ? null
                              : const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: const Radius.circular(12),
                                    topLeft: const Radius.circular(12),
                                  ),
                                ),
                          child: Text("Новые",
                              style: TextStyle(
                                color: filter.sortType == FilterSortType.newPost ? Colors.white : Colors.blue,
                                fontSize: 17,
                              )),
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            filter.sortType = FilterSortType.bestPost;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: filter.sortType == FilterSortType.bestPost
                              ? null
                              : const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                  ),
                                ),
                          child: Text("Лучшие",
                              style: TextStyle(
                                color: filter.sortType == FilterSortType.bestPost ? Colors.white : Colors.blue,
                                fontSize: 17,
                              )),
                        )))
              ],
            )),
      ),
    );
  }

  Widget _buildScoreButtonsRow() {
    if (filter.sortType == FilterSortType.newPost) {
      return Wrap(
        children: [
          _buildScoreButton('Все', 80, ListFilter.all),
          _buildScoreButton('>= 0', 80, ListFilter.top0),
          _buildScoreButton('>= 10', 80, ListFilter.top10),
          _buildScoreButton('>= 25', 80, ListFilter.top25),
          _buildScoreButton('>= 50', 80, ListFilter.top50),
          _buildScoreButton('>= 100', 80, ListFilter.top100),
        ],
      );
    }

    return Wrap(
      children: [
        _buildScoreButton('Сутки', 110, ListFilter.daily),
        _buildScoreButton('Неделя', 110, ListFilter.weekly),
        _buildScoreButton('Месяц', 110, ListFilter.monthly),
        _buildScoreButton('Год', 110, ListFilter.yearly),
        _buildScoreButton('Все время', 110, ListFilter.alltime),
      ],
    );
  }

  Widget _buildScoreButton(String value, double width, ListFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: filterKey == filter.filterKey ? AppColors.primary : Colors.white,
          borderRadius: const BorderRadius.all(const Radius.circular(12)),
          border: Border.all(color: AppColors.primary),
        ),
        child: TextButton(
            onPressed: () {
              setState(() {
                filter.filterKey = filterKey;
              });
            },
            child: Text(
              value,
              style: TextStyle(color: filterKey == filter.filterKey ? Colors.white : Colors.black),
            )),
      ),
    );
  }

  Widget _buildHubFilterButton(bool isDown, String label, ListHubFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: filter.hubFilter == filterKey ? AppColors.primary : Colors.white,
          borderRadius: const BorderRadius.all(const Radius.circular(12)),
          border: Border.all(color: AppColors.primary),
        ),
        child: TextButton.icon(
          onPressed: () {
            setState(() {
              filter.hubFilter = filterKey;
            });
          },
          icon: Icon(
            isDown ? Icons.arrow_downward : Icons.arrow_upward,
            color: filter.hubFilter == filterKey ? Colors.white : AppColors.actionIcon,
          ),
          label: Text(
            label,
            style: TextStyle(color: filter.hubFilter == filterKey ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
