import 'package:get/get.dart';
import 'package:habar/comments/comments_repository.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/model/comment_list.dart';

class CommentsCtrl extends GetxController {
  late CommentsRepo _repo;
  final comments = List<StructuredComment>.empty().obs;
  // final isImageLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    _repo = CommentsRepo();
    _repo.commentsStream.map(getStructuredComments).listen((commentList) => comments.value = commentList);
  }

  @override
  void onClose() {
    super.onClose();
    _repo.dispose();
  }

  Future getAll(String postId) async {
    await _repo.getAll(postId);
  }

  List<StructuredComment> getStructuredComments(CommentList commentList) {
    Map<String, Comment> commentsMap = Map.fromIterable(
      commentList.comments.values,
      key: (comment) => comment.id,
      value: (comment) => comment,
    );
    List<StructuredComment> structComments = [];

    commentList.comments.values.where((comment) => comment.level == 0).toList().forEach((comment) {
      final structComment = StructuredComment(
        author: comment.author,
        publishTime: comment.timePublished,
        text: comment.message,
        isPostAuthor: comment.isPostAuthor,
        level: comment.level,
        score: comment.score,
      );

      if (comment.children.isNotEmpty) {
        structComment.children = comment.children.map((id) => commentsMap[id]).map((habrComment) {
          final hComment = habrComment!;
          return StructuredComment(
            author: hComment.author,
            publishTime: hComment.timePublished,
            text: hComment.message,
            isPostAuthor: hComment.isPostAuthor,
            level: hComment.level,
            score: hComment.score,
          );
        }).toList();

        structComment.children.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
      }

      structComments.add(structComment);
    });

    structComments.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);

    return structComments;
  }
}
