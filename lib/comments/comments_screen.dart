import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/comments/comments_ctrl.dart';
import 'package:habar/common/widgets/comment_widget.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/model/post.dart';

class CommentsScreen extends StatelessWidget {
  final ctrl = Get.put(CommentsCtrl());
  final Post post;

  CommentsScreen({required this.post}) {
    ctrl.getAll(post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                child: UserInfoWidget(publishTime: post.timePublished, author: post.author),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    post.titleHtml,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20, bottom: 16),
                child: _buildFooterRow(),
              ),
              Container(
                height: 40,
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text('Комментарии',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    if (post.statistics.commentsCount > 0)
                      Text(
                        ' ${post.statistics.commentsCount}',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: Obx(() => _buildList(ctrl.comments))),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<StructuredComment> comments) {
    if (comments.isEmpty) {
      return Container();
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        var comment = comments[index];

        return _buildCommentTree(comment);
      },
    );
  }

  // todo: common widget
  Widget _buildFooterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FooterItemWidget(icon: Icons.thumbs_up_down, value: post.statistics.votesCount),
        FooterItemWidget(icon: Icons.visibility, value: post.statistics.readingCount),
        FooterItemWidget(icon: Icons.bookmark, value: post.statistics.favoritesCount),
        FooterItemWidget(icon: Icons.mode_comment_rounded, value: post.statistics.commentsCount),
      ],
    );
  }

  Widget _buildCommentTree(StructuredComment comment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CommentWidget(comment: comment),
        ),
        for (final subComment in comment.children)
          Padding(
            padding: EdgeInsets.only(left: 40.0 * subComment.level, bottom: 16),
            child: CommentWidget(comment: subComment),
          ),
      ],
    );
  }
}
