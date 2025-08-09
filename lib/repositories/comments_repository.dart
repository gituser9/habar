import 'package:habar/model/comment_list.dart';
import 'package:habar/repositories/base_repo.dart';
import 'package:rxdart/subjects.dart';

class CommentsRepo extends BaseRepo {
  final commentsStream = BehaviorSubject<CommentList>();
  final errorStream = BehaviorSubject<String>();

  Future getAll(String postId) async {
    var comments = await habrClient.comments(postId);
    commentsStream.add(comments);
  }

  void dispose() {
    commentsStream.close();
    errorStream.close();
  }
}
