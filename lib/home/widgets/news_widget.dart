import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/news_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/home/home_ctrl.dart';

class NewsWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();
  final SettingsCtrl _settingsCtrl = Get.find();
  final _savedPostService = Get.put(SavedPostService());

  NewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    if (_settingsCtrl.settings.value.isInfinityScroll!) {
      return Obx(() => _buildNewsList());
    }

    return SingleChildScrollView(
      controller: _ctrl.scrollCtrl,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Obx(() => _buildNewsList(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true)),
          const SizedBox(height: 4),
          Material(
            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            child: Obx(() => PaginationWidget(
                  page: _ctrl.page.value,
                  pageCount: _ctrl.news.value.pagesCount,
                  callback: (int page) async {
                    _ctrl.page.value = page;

                    if (_ctrl.currentFlow == '') {
                      await _ctrl.getAll(
                        _settingsCtrl.settings.value.filters!.filterKey,
                        page: page,
                      );
                    } else {
                      await _ctrl.getFlow(_ctrl.currentFlow, page: page);
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList({ScrollPhysics? physics, bool shrinkWrap = false}) {
    return ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap,
        controller: _ctrl.scrollCtrl,
        itemCount: shrinkWrap ? _ctrl.news.value.newsIds.length : _ctrl.news.value.newsIds.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= _ctrl.news.value.newsIds.length) {
            return const SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2),
                ),
              ),
            );
          }

          final newsId = _ctrl.news.value.newsIds[index];

          if (!_ctrl.news.value.newsRefs.containsKey(newsId)) {
            return Container();
          }

          final newsRef = _ctrl.news.value.newsRefs[newsId]!;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Obx(() => NewsDetailWidget(
                  news: newsRef,
                  isSaved: _savedPostService.isSaved(newsRef.id),
                  imageUrl: Util.getImgUrl(
                    newsRef.leadData.imageUrl ?? '',
                    newsRef.titleHtml,
                  ),
                )),
          );
        });
  }
}
