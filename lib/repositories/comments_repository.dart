import 'package:habar/common/http_request.dart';
import 'package:habar/model/comment_list.dart';
import 'package:rxdart/subjects.dart';

class CommentsRepo {
  final commentsStream = BehaviorSubject<CommentList>();
  final errorStream = BehaviorSubject<String>();

  Future getAll(String postId) async {
    String json = await HttpRequest.get('/articles/$postId/comments');

    if (json.isEmpty) {
      return;
    }

    var comments = CommentList.fromJson(json);
    commentsStream.add(comments);
  }

  void dispose() {
    commentsStream.close();
    errorStream.close();
  }
}
