import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/services/saved_post_service.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/home_ctrl.dart';

class SavedWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();
  final SavedPostService _savedPostService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Obx(() {
          final ids = _savedPostService.savedIds;

          if (ids.isEmpty) {
            return _buildEmptyWidget();
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ids.length,
            itemBuilder: (BuildContext context, int index) {
              final id = ids[index];
              final post = _ctrl.savedPosts.firstWhere((item) => item.id == id);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: PostWidget(
                    article: post,
                    isSaved: true,
                    imageUrl: Util.getImgUrl(
                      post.leadData.imageUrl,
                      post.textHtml,
                    )),
              );
            },
          );
        }),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text(
        'Вы пока ничего не сохранили',
        style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
