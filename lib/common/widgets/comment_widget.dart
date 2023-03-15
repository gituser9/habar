import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/html_text.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/comment.dart';

class CommentWidget extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();
  final StructuredComment comment;

  CommentWidget({super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: comment.isPostAuthor ? Colors.lightGreen.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserInfoWidget(publishTime: comment.publishTime, author: comment.author),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SelectionArea(
            child: HtmlText(htmlText: comment.text),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _buildCommentFooterRow(comment),
        ),
      ],
    );
  }

  Widget _buildCommentFooterRow(StructuredComment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(
          icon: Icons.thumbs_up_down,
          value: comment.score,
          isMinus: comment.score < 0,
          isPlus: comment.score > 0,
        ),
      ],
    );
  }

}
