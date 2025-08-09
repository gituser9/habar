import 'package:habar/common/costants.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/model/profile_list.dart';
import 'package:habar/repositories/base_repo.dart';
import 'package:rxdart/rxdart.dart';

class ProfileRepository extends BaseRepo {
  final profileStream = BehaviorSubject<Profile>();
  final whoIsStream = BehaviorSubject<WhoIs>();
  final profileHubsStream = BehaviorSubject<HubList>();
  final profileCompaniesStream = BehaviorSubject<List<Company>>();
  final profileChildrenStream = BehaviorSubject<List<Invited>>();
  final postsStream = BehaviorSubject<PostList>();
  final commentsStream = BehaviorSubject<CommentList>();

  Future getProfile(String login) async {
    final profile = await habrClient.profile(login);

    profileStream.add(profile);
  }

  Future getWhoIs(String login) async {
    final whoIs = await habrClient.whois(login);

    whoIsStream.add(whoIs);
  }

  Future getProfileHubs(String login) async {
    final hubList = await habrClient.userHubs(login);

    profileHubsStream.add(hubList);
  }

  Future getProfileCompanies(String login) async {
    final companyList = await habrClient.userCompanies(login);

    profileCompaniesStream.add(companyList.companyRefs.values.toList());
  }

  Future getInvited(String login) async {
    final profileList = await habrClient.invited(login);
    final profiles = profileList.userRefs.values.toList();

    profileChildrenStream.add(profiles);
  }

  Future getProfileArticles(String login, int page) async {
    final posts = await habrClient.userArticles(page, Constant.pageSize, login);

    postsStream.add(posts);
  }

  Future getProfileComments(String login, int page) async {
    final comments = await habrClient.userComments(login, page);

    commentsStream.add(comments);
  }

  void dispose() {
    profileStream.close();
    profileHubsStream.close();
    profileCompaniesStream.close();
    profileChildrenStream.close();
  }
}
