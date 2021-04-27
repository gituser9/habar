import 'package:habar/model/comment.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_repository.dart';
import 'package:rxdart/subjects.dart';

class ProfileBloc {
  final profileStream = BehaviorSubject<Profile>();
  final profileHubsStream = BehaviorSubject<List<HubRef>>();
  final profileCompaniesStream = BehaviorSubject<List<Company>>();
  final profileChildrenStream = BehaviorSubject<List<ProfileData>>();
  final postsStream = BehaviorSubject<PostList>();
  final commentsStream = BehaviorSubject<List<StructuredComment>>();
  final pageStream = BehaviorSubject<int>();
  final _repo = ProfileRepository();

  ProfileBloc() {
    _repo.profileStream.listen(profileStream.add);

    _repo.profileHubsStream.map((hubList) => hubList.hubRefs.values.toList()).listen(profileHubsStream.add);

    _repo.profileCompaniesStream.map((companyList) => companyList.companies).listen(profileCompaniesStream.add);

    _repo.profileChildrenStream.map((profileList) => profileList.data).listen(profileChildrenStream.add);

    _repo.postsStream.listen(postsStream.add);

    _repo.commentsStream.map(_getStructuredComments).listen(commentsStream.add);
  }

  Future setup(String login) async {
    await getProfile(login);
    await getProfileHubs(login);
    await getProfileCompanies(login);
    await getProfileChildren(login);
  }

  Future getProfile(String login) async {
    await _repo.getProfile(login);
  }

  Future getProfileHubs(String login) async {
    await _repo.getProfileHubs(login);
  }

  Future getProfileCompanies(String login) async {
    await _repo.getProfileCompanies(login);
  }

  Future getProfileChildren(String login) async {
    await _repo.getProfileChildren(login);
  }

  Future getProfileArticles(String login, {int page = 1}) async {
    await _repo.getProfileArticles(login, page);
  }

  Future getProfileComments(String login) async {
    await _repo.getProfileComments(login, 1);
  }

  List<StructuredComment> _getStructuredComments(CommentList commentList) {
    Map<int, Comment> commentsMap = Map.fromIterable(
      commentList.comments.values,
      key: (comment) => comment.id,
      value: (comment) => comment,
    );
    List<StructuredComment> structComments = [];

    commentList.comments.values.toList().forEach((comment) {
      final structComment = StructuredComment(
        author: comment.author,
        publishTime: comment.timePublished,
        text: comment.message,
        isPostAuthor: comment.isPostAuthor,
        level: comment.level,
        score: comment.score,
      );

      if (comment.children.isNotEmpty) {
        comment.children.forEach((id) {
          Comment habrComment = commentsMap[id]!;
          structComment.children.add(StructuredComment(
            author: habrComment.author,
            publishTime: habrComment.timePublished,
            text: habrComment.message,
            isPostAuthor: habrComment.isPostAuthor,
            level: habrComment.level,
            score: habrComment.score,
          ));
        });
        structComment.children.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
      }

      structComments.add(structComment);
    });

    structComments.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
    return structComments;
  }

  void dispose() {
    _repo.dispose();
    profileStream.close();
    profileHubsStream.close();
    profileCompaniesStream.close();
    profileChildrenStream.close();
    postsStream.close();
    commentsStream.close();
    pageStream.close();
  }
}
