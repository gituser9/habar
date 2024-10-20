import 'package:get/get.dart';
import 'package:habar/model/comment.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/model/profile_list.dart';
import 'package:habar/profile/profile_repository.dart';

class ProfileCtrl extends GetxController {
  late ProfileRepository _repo;
  final profile = Profile.empty().obs;
  final whoIs = WhoIs.empty().obs;
  final profileHubs = List<HubRef>.empty().obs;
  final profileCompanies = List<Company>.empty().obs;
  final inviteds = List<Invited>.empty().obs;
  final posts = PostList.empty().obs;
  final comments = List<StructuredComment>.empty().obs;
  final page = 1.obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();

    _repo = ProfileRepository();
    _repo.profileStream.listen((profileData) {
      profile.value = profileData;
      isLoading.value = false;
    });

    _repo.profileHubsStream.map((hubList) => hubList.hubRefs.values.toList()).listen((refs) => profileHubs.value = refs);

    _repo.profileCompaniesStream.map((companyList) => companyList.companies).listen((companies) => profileCompanies.value = companies);

    _repo.profileChildrenStream.map((profileList) => profileList.userRefs).listen((children) => inviteds.value = children);

    _repo.postsStream.listen((postList) => posts.value = postList);

    _repo.commentsStream.map(_getStructuredComments).listen((commentList) => comments.value = commentList);

    _repo.whoIsStream.map((wh) => wh).listen((wh) => whoIs.value = wh);
  }

  @override
  void onClose() {
    super.onClose();

    _repo.dispose();
  }

  Future setup(String login) async {
    await getProfile(login);
    await getWhoIs(login);
    await getProfileHubs(login);
    await getProfileCompanies(login);
    await getInvited(login);
    await getProfileArticles(login);
    await getProfileComments(login);
  }

  Future getProfile(String login) async {
    isLoading.value = true;
    await _repo.getProfile(login);
  }

  Future getWhoIs(String login) async {
    isLoading.value = true;
    await _repo.getWhoIs(login);
  }

  Future getProfileHubs(String login) async {
    await _repo.getProfileHubs(login);
  }

  Future getProfileCompanies(String login) async {
    await _repo.getProfileCompanies(login);
  }

  Future getInvited(String login) async {
    await _repo.getInvited(login);
  }

  Future getProfileArticles(String login, {int page = 1}) async {
    await _repo.getProfileArticles(login, page);
  }

  Future getProfileComments(String login) async {
    await _repo.getProfileComments(login, 1);
  }

  List<StructuredComment> _getStructuredComments(CommentList commentList) {
    Map<String, Comment> commentsMap = { for (var comment in commentList.comments.values) comment.id : comment };
    List<StructuredComment> structComments = [];

    for (final comment in commentList.comments.values) {
      final structComment = StructuredComment.fromComment(comment);

      if (comment.children.isNotEmpty) {
        for (final id in comment.children) {
          Comment habrComment = commentsMap[id]!;
          structComment.children.add(StructuredComment.fromComment(habrComment));
        }
        structComment.children.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
      }

      structComments.add(structComment);
    }

    structComments.sort((commentLeft, commentRight) => commentLeft.publishTime.isBefore(commentRight.publishTime) ? 0 : 1);
    return structComments;
  }
}
