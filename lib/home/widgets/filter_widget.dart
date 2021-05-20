import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';

class FilterWidget extends StatelessWidget {
  final HomeCtrl ctrl = Get.find();

  static const textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

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
                    Get.back();

                    if (ctrl.pageMode == HomeMode.posts) {
                      await ctrl.getAll(ctrl.postFilter.value.filterKey.value);
                    } else {
                      await ctrl.getHubs(filterKey: ctrl.postFilter.value.hubFilter.value);
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
    return ctrl.pageMode == HomeMode.posts ? _buildPostsFilter() : _buildHubFilter();
  }

  Widget _buildPostsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Сначала показывать', style: textStyle),
        _buildTypeButtons(),
        const Text('Порог рейтинга', style: textStyle),
        const SizedBox(height: 10),
        Obx(() => _buildScoreButtonsRow()),
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
        child: Obx(() {
          return Container(
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
                          ctrl.postFilter.value.sortType.value = FilterSortType.newPost;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: ctrl.postFilter.value.sortType.value == FilterSortType.newPost
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
                                color: ctrl.postFilter.value.sortType.value == FilterSortType.newPost
                                    ? Colors.white
                                    : Colors.blue,
                                fontSize: 17,
                              )),
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          ctrl.postFilter.value.sortType.value = FilterSortType.bestPost;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: ctrl.postFilter.value.sortType.value == FilterSortType.bestPost
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
                                color: ctrl.postFilter.value.sortType.value == FilterSortType.bestPost
                                    ? Colors.white
                                    : Colors.blue,
                                fontSize: 17,
                              )),
                        )))
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScoreButtonsRow() {
    if (ctrl.postFilter.value.sortType.value == FilterSortType.newPost) {
      return Center(
        child: Wrap(
          children: [
            _buildScoreButton('Все', 80, ListFilter.all),
            _buildScoreButton('>= 0', 80, ListFilter.top0),
            _buildScoreButton('>= 10', 80, ListFilter.top10),
            _buildScoreButton('>= 25', 80, ListFilter.top25),
            _buildScoreButton('>= 50', 80, ListFilter.top50),
            _buildScoreButton('>= 100', 80, ListFilter.top100),
          ],
        ),
      );
    }

    return Center(
      child: Wrap(
        children: [
          _buildScoreButton('Сутки', 110, ListFilter.daily),
          _buildScoreButton('Неделя', 110, ListFilter.weekly),
          _buildScoreButton('Месяц', 110, ListFilter.monthly),
          _buildScoreButton('Год', 110, ListFilter.yearly),
          _buildScoreButton('Все время', 110, ListFilter.alltime),
        ],
      ),
    );
  }

  Widget _buildScoreButton(String value, double width, ListFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        final isChoosen = filterKey == ctrl.postFilter.value.filterKey.value;

        return Container(
          width: width,
          height: 40,
          decoration: BoxDecoration(
            color: isChoosen ? AppColors.primary : Colors.white,
            borderRadius: const BorderRadius.all(const Radius.circular(12)),
            border: Border.all(color: AppColors.primary),
          ),
          child: TextButton(
              onPressed: () {
                ctrl.postFilter.value.filterKey.value = filterKey;
              },
              child: Text(
                value,
                style: TextStyle(color: isChoosen ? Colors.white : Colors.black),
              )),
        );
      }),
    );
  }

  Widget _buildHubFilterButton(bool isDown, String label, ListHubFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(
            color: ctrl.postFilter.value.hubFilter.value == filterKey ? AppColors.primary : Colors.white,
            borderRadius: const BorderRadius.all(const Radius.circular(12)),
            border: Border.all(color: AppColors.primary),
          ),
          child: TextButton.icon(
              onPressed: () {
                ctrl.postFilter.value.hubFilter.value = filterKey;
              },
              icon: Icon(
                isDown ? Icons.arrow_downward : Icons.arrow_upward,
                color: ctrl.postFilter.value.hubFilter.value == filterKey ? Colors.white : AppColors.actionIcon,
              ),
              label: Text(
                label,
                style:
                    TextStyle(color: ctrl.postFilter.value.hubFilter.value == filterKey ? Colors.white : Colors.black),
              )),
        );
      }),
    );
  }
}
