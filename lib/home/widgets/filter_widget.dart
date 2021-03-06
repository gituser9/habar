import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/model/filter.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/settings.dart';

class FilterWidget extends StatelessWidget {
  final HomeCtrl ctrl = Get.find();
  final SettingsCtrl _settingsCtrl = Get.find();
  final _segmentCtrl = AdvancedSegmentController('all');

  static const textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    ctrl.postFilter.value.sortType.value = FilterSortType.newPost;

    _segmentCtrl.addListener(() {
      if (_segmentCtrl.value == 'new') {
        ctrl.postFilter.value.sortType.value = FilterSortType.newPost;
      } else {
        ctrl.postFilter.value.sortType.value = FilterSortType.bestPost;
      }
    });

    return SingleChildScrollView(
      child: Container(
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

                      _settingsCtrl.settings.value.filters!.filterKey = ctrl.postFilter.value.filterKey.value;
                      _settingsCtrl.settings.value.filters!.hubFilter = ctrl.postFilter.value.hubFilter.value;

                      await _settingsCtrl.save();
                    },
                    icon: const Icon(Icons.done_all, color: Colors.white),
                    label: const Text('??????????????????', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
        const Text('?????????????? ????????????????????', style: textStyle),
        _buildTypeButtons(),
        const Text('?????????? ????????????????', style: textStyle),
        const SizedBox(height: 10),
        Obx(() => _buildScoreButtonsRow()),
      ],
    );
  }

  Widget _buildHubFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('?????????????????????? ????', style: textStyle),
        const SizedBox(height: 10),
        Wrap(
          children: [
            _buildHubFilterButton(true, '????????????????', ListHubFilter.titleDesc),
            _buildHubFilterButton(false, '????????????????', ListHubFilter.titleAsc),
            _buildHubFilterButton(true, '??????????????', ListHubFilter.rateDesc),
            _buildHubFilterButton(false, '??????????????', ListHubFilter.rateAsc),
            _buildHubFilterButton(true, '????????????????????', ListHubFilter.subscribersDesc),
            _buildHubFilterButton(false, '????????????????????', ListHubFilter.subscribersAsc),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButtons() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.center,
        child: AdvancedSegment(
          controller: _segmentCtrl,
          segments: const {
            'new': '          ??????????          ',
            'best': '????????????',
          },
          backgroundColor: Colors.grey.withOpacity(0.3),
          inactiveStyle: TextStyle(color: _getButtonTextColor()),
          activeStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreButtonsRow() {
    if (ctrl.postFilter.value.sortType.value == FilterSortType.newPost) {
      return Center(
        child: Wrap(
          children: [
            _buildScoreButton('??????', 0, ListFilter.all),
            _buildScoreButton('>= 0', 0, ListFilter.top0),
            _buildScoreButton('>= 10', 0, ListFilter.top10),
            _buildScoreButton('>= 25', 0, ListFilter.top25),
            _buildScoreButton('>= 50', 0, ListFilter.top50),
            _buildScoreButton('>= 100', 0, ListFilter.top100),
          ],
        ),
      );
    }

    return Center(
      child: Wrap(
        children: [
          _buildScoreButton('??????????', 0, ListFilter.daily),
          _buildScoreButton('????????????', 0, ListFilter.weekly),
          _buildScoreButton('??????????', 0, ListFilter.monthly),
          _buildScoreButton('??????', 0, ListFilter.yearly),
          _buildScoreButton('?????? ??????????', 230, ListFilter.alltime),
        ],
      ),
    );
  }

  Widget _buildScoreButton(String value, double width, ListFilter filterKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        final isChosen = filterKey == ctrl.postFilter.value.filterKey.value;

        return Container(
          width: width == 0 ? (Get.width / 2) - 35 : Get.width - 55,
          height: 40,
          decoration: BoxDecoration(
            color: isChosen ? AppColors.primary : Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: TextButton(
              onPressed: () => setFilterValue(filterKey),
              child: Text(
                value,
                style: TextStyle(color: isChosen ? Colors.white : _getButtonTextColor()),
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
            color: ctrl.postFilter.value.hubFilter.value == filterKey ? AppColors.primary : Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                style: TextStyle(color: ctrl.postFilter.value.hubFilter.value == filterKey ? Colors.white : _getButtonTextColor()),
              )),
        );
      }),
    );
  }

  Color _getButtonTextColor() {
    return _settingsCtrl.settings.value.theme == AppThemeType.dark ? Colors.grey.shade400 : Colors.black;
  }

  void setFilterValue(ListFilter filterKey) {
    // for all publications
    if (ctrl.currentFlow == '') {
      ctrl.postFilter.value.filterKey.value = filterKey;
    } else {
      // for publications in flow
      if (ctrl.postFilter.value.sortType.value == FilterSortType.newPost) {
        ctrl.flowFilter.value.score = flowScore[filterKey];
      } else {
        ctrl.flowFilter.value.period = flowPeriod[filterKey] ?? 'all';
      }
    }
  }
}
