import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/footer_item_widget.dart';
import 'package:habar/common/widgets/user_info_widget.dart';
import 'package:habar/model/comment.dart';

class CommentWidget extends StatelessWidget {
  final StructuredComment comment;

  CommentWidget({
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
        Html(
          data: comment.text,
          shrinkWrap: true,
          style: {
            'body': Style(fontSize: const FontSize(18)),
            'blockquote': Style(fontStyle: FontStyle.italic, fontSize: const FontSize(16)),
          },
          onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) async {
            if (url != null) {
              await Util.launchURL(url);
            }
          },
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
