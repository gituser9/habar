import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/hub/hub_screen.dart';
import 'package:habar/model/hub_list.dart';

class HubWidget extends StatelessWidget {
  final HomeCtrl ctrl = Get.find();

  HubWidget({Key? key}) : super(key: key) {
    // ctrl.getHubs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
              onChanged: (data) => ctrl.hubSearchStream.add(data),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => _buildBody(ctrl.hubs.value))
        ],
      ),
    );
  }

  Widget _buildBody(HubList hubList) {
    return Column(
      children: [
        ListView.builder(
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
                title: Text(
                  hub.titleHtml,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hub.descriptionHtml,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.group, color: Colors.grey, size: 16),
                            const SizedBox(width: 5),
                            Text(hub.statistics.subscribersCount.toString()),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.star_rate, color: Colors.grey, size: 16),
                            const SizedBox(width: 5),
                            Text(hub.statistics.rating.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () async {
                  await Get.to(() => HubScreen(name: hub.alias));
                },
              ),
            );
          },
        ),
        Container(
          height: 8,
          color: Colors.grey.shade200,
        ),
        PaginationWidget(
          page: ctrl.page.value,
          pageCount: hubList.pagesCount,
          callback: (int page) async {
            ctrl.page.value = page;
            await ctrl.getHubs(page: page);
          },
        )
      ],
    );
  }
}
