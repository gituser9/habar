import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/home_ctrl.dart';

class SavedWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();

  SavedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_ctrl.savedPosts.isEmpty) {
        return _buildEmptyWidget();
      }

      return _buildBody();
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        controller: _ctrl.scrollCtrl,
        itemCount: _ctrl.savedPosts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = _ctrl.savedPosts[index];

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
      ),
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
