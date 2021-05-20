import 'package:get/get.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_repository.dart';

class ProfileCtrl extends GetxController {
  late ProfileRepository _repo;
  final profile = Profile.empty().obs;
  final profileHubs = List<HubRef>.empty().obs;
  final profileCompanies = List<Company>.empty().obs;
  final profileChildren = List<ProfileData>.empty().obs;
  final posts = PostList.empty().obs;
  final comments = List<StructuredComment>.empty().obs;
  final page = 1.obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _repo = ProfileRepository();
    _repo.profileStream.listen((profileData) {
      profile.value = profileData;
      isLoading.value = false;
    });

    _repo.profileHubsStream
        .map((hubList) => hubList.hubRefs.values.toList())
        .listen((refs) => profileHubs.value = refs);

    _repo.profileCompaniesStream
        .map((companyList) => companyList.companies)
        .listen((companies) => profileCompanies.value = companies);

    _repo.profileChildrenStream
        .map((profileList) => profileList.data)
        .listen((children) => profileChildren.value = children);

    _repo.postsStream.listen((postList) => posts.value = postList);

    _repo.commentsStream.map(_getStructuredComments).listen((commentList) => comments.value = commentList);
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
  }

  Future setup(String login) async {
    await getProfile(login);
    // await getProfileHubs(login);
    // await getProfileCompanies(login);
    // await getProfileChildren(login);
  }

  Future getProfile(String login) async {
    isLoading.value = true;
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
    Map<String, Comment> commentsMap = Map.fromIterable(
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
        structComment.children
            .sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
      }

      structComments.add(structComment);
    });

    structComments
        .sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
    return structComments;
  }
}
