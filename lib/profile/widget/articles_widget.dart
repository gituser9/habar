import 'package:flutter/material.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/profile/profile_bloc.dart';

class PostsWidget extends StatelessWidget {
  final ProfileBloc bloc;
  final String login;

  PostsWidget({Key? key, required this.bloc, required this.login}) : super(key: key) {
    bloc.getProfileArticles(login);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<PostList>(
        stream: bloc.postsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          PostList postList = snapshot.data!;

          return Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postList.articleIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    String postId = postList.articleIds[index];
                    final articleRef = postList.articleRefs[postId]!;
                    final imgUrl = Util.getImgUrl(articleRef.leadData.imageUrl, articleRef.textHtml);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: PostWidget(article: articleRef, imageUrl: imgUrl),
                    );
                  }),
              const SizedBox(height: 4),
              Material(
                color: Colors.white,
                child: StreamBuilder<int>(
                    stream: bloc.pageStream,
                    initialData: 1,
                    builder: (context, snapshot) {
                      return PaginationWidget(
                        page: snapshot.data!,
                        pageCount: postList.pagesCount,
                        callback: (int page) async {
                          bloc.pageStream.add(page);
                          await bloc.getProfileArticles(login, page: page);
                        },
                      );
                    }),
              ),
            ],
          );
        });
  }
}
