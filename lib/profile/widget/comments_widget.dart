import 'package:flutter/material.dart';
import 'package:habar/common/widgets/comment_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/profile/profile_bloc.dart';

class CommentsWidget extends StatelessWidget {
  final ProfileBloc bloc;
  final String login;

  CommentsWidget({
    Key? key,
    required this.bloc,
    required this.login,
  }) : super(key: key) {
    bloc.getProfileComments(login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: StreamBuilder<List<StructuredComment>>(
          stream: bloc.commentsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }

            final comments = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (ctx, index) {
                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CommentWidget(comment: comments[index]),
                  ),
                );
              },
            );
          }),
    );
  }
}
