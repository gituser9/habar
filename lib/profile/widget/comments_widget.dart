import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/widgets/comment_widget.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/profile/profile_ctrl.dart';

class CommentsWidget extends StatelessWidget {
  final ProfileCtrl ctrl = Get.find();
  final String login;

  CommentsWidget({Key? key, required this.login}) : super(key: key) {
    ctrl.getProfileComments(login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade200,
      child: Obx(() => _buildList(ctrl.comments)),
    );
  }

  Widget _buildList(List<StructuredComment> comments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (ctx, index) {
        return Container(
          // color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CommentWidget(comment: comments[index]),
          ),
        );
      },
    );
  }
}
