import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/pin_hub_service.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/hub/hub_screen.dart';
import 'package:habar/model/hub_list.dart';

class HubWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();
  final PinHubService _pinHubService = Get.find();

  HubWidget({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'Поиск',
              suffixIcon: const Icon(Icons.search),
              fillColor: Get.isDarkMode ? null : Colors.grey.shade200,
              filled: true,
            ),
            onChanged: (data) => _ctrl.hubSearchStream.add(data),
          ),
        ),
        const SizedBox(height: 16),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Obx(() => _buildHubList(_getList())),
        Container(
          height: 8,
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
        ),
        Obx(() => PaginationWidget(
              page: _ctrl.isShowPinnedHub.value ? 1 : _ctrl.page.value,
              pageCount: _getList().pagesCount,
              callback: (int page) async {
                if (_ctrl.isShowPinnedHub.value) {
                  return;
                }

                _ctrl.page.value = page;
                await _ctrl.getHubs(page: page);
              },
            )),
      ],
    );
  }

  ListView _buildHubList(HubList hubList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: hubList.hubIds.length,
      itemBuilder: (ctx, index) {
        final hubId = hubList.hubIds[index];
        final hub = hubList.hubRefs[hubId]!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            leading: SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: 'https:' + hub.imageUrl,
                placeholder: (context, url) => const Icon(Icons.image),
                errorWidget: (context, url, error) => const Icon(Icons.image),
              ),
            ),
            title: Html(
              data: hub.titleHtml,
              style: {
                'body': Style(
                  fontWeight: FontWeight.bold,
                  margin: Margins.all(0),
                ),
              },
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hub.descriptionHtml,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 10),
                _buildStatRow(hub),
              ],
            ),
            trailing: IconButton(
              icon: Obx(() => Icon(
                    _pinHubService.savedIds.contains(hub.alias) ? Icons.bookmark_outlined : Icons.bookmark_add_outlined,
                  )),
              onPressed: () {
                if (_pinHubService.isSaved(hub.alias)) {
                  _pinHubService.deleteById(hub.alias);
                } else {
                  _pinHubService.save(hub);
                }
              },
            ),
            onTap: () async {
              await Get.to(() => HubScreen(name: hub.alias));
            },
          ),
        );
      },
    );
  }

  Widget _buildStatRow(HubRef hub) {
    if (_ctrl.isShowPinnedHub.value) {
      return Container();
    }

    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.group, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(hub.statistics.subscribersCount.toString()),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.star_rate, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(hub.statistics.rating.toString()),
          ],
        ),
      ],
    );
  }

  HubList _getList() {
    return _ctrl.isShowPinnedHub.value ? _pinHubService.getList() : _ctrl.hubs.value;
  }
}
