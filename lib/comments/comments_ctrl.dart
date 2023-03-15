import 'package:get/get.dart';
import 'package:habar/comments/comments_repository.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/model/comment_list.dart';

class CommentsCtrl extends GetxController {
  late CommentsRepo _repo;
  final comments = List<StructuredComment>.empty().obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _repo = CommentsRepo();
    _repo.commentsStream.map(getStructuredComments).listen((commentList) {
      comments.value = commentList;
      isLoading.value = false;
    });
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
    List<StructuredComment> structComments = commentList.comments.values
        .where((comment) => comment.level == 0 && comment.timePublished != null)
        .map((comment) => convertToStructured(commentsMap, comment))
        .toList();

    structComments
        .sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);

    return structComments;
  }

  StructuredComment convertToStructured(Map<String, Comment> commentsMap, Comment comment) {
    final structComment = StructuredComment.fromComment(comment);

    if (comment.children.isNotEmpty) {
      structComment.children = getChildren(commentsMap, comment);
    }

    return structComment;
  }

  List<StructuredComment> getChildren(Map<String, Comment> commentsMap, Comment comment) {
    if (comment.children.isEmpty) {
      return [];
    }

    List<StructuredComment> list = [];

    for (final id in comment.children) {
      if (!commentsMap.containsKey(id)) {
        continue;
      }

      var child = commentsMap[id]!;
      var structComment = StructuredComment.fromComment(child);

      if (child.children.isNotEmpty) {
        var structChildren = getChildren(commentsMap, child);
        structComment.children = structChildren;
      }

      list.add(structComment);
    }

    return list;
  }
}
