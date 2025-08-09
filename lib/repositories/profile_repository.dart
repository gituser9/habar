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
  final profileCompaniesStream = BehaviorSubject<CompanyList>();
  final profileChildrenStream = BehaviorSubject<ProfileList>();
  final postsStream = BehaviorSubject<PostList>();
  final commentsStream = BehaviorSubject<CommentList>();

  Future getProfile(String login) async {
    /*final jsonString = await HttpRequest.get('/users/$login/card', version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    final profile = Profile.fromJson(jsonString);*/

    final profile = await habrClient.profile(login);

    profileStream.add(profile);
  }

  Future getWhoIs(String login) async {
    /*final jsonString = await HttpRequest.get('/users/$login/whois', version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    final whoIs = WhoIs.fromJson(jsonString);*/

    final whoIs = await habrClient.whois(login);

    whoIsStream.add(whoIs);
  }

  Future getProfileHubs(String login) async {
    /*final jsonString = await HttpRequest.get('/users/$login/hubs');

    if (jsonString.isEmpty) {
      return;
    }

    final hubList = HubList.fromJson(jsonString);*/

    final hubList = await habrClient.userHubs(login);

    profileHubsStream.add(hubList);
  }

  Future getProfileCompanies(String login) async {
    /*final jsonString = await HttpRequest.get('/users/$login/subscriptions/companies', version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    final companyList = CompanyList.fromJson(jsonString);*/

    final companyList = await habrClient.userCompanies(login);

    profileCompaniesStream.add(companyList);
  }

  Future getInvited(String login) async {
    /*final jsonString = await HttpRequest.get('/users/$login/invited', version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    final profileList = ProfileList.fromJson(jsonString);*/

    final profileList = await habrClient.invited(login);

    profileChildrenStream.add(profileList);
  }

  Future getProfileArticles(String login, int page) async {
    /*Map<String, String> params = {
      'page': page.toString(),
      'user': login,
      'perPage': '20',
    };

    String jsonString = await HttpRequest.get('/articles', params: params, version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    var posts = PostList.fromJsonOld(jsonString);*/

    final posts = await habrClient.userArticles(page, 20, login);

    postsStream.add(posts);
  }

  Future getProfileComments(String login, int page) async {
    /*Map<String, String> params = {
      'page': page.toString(),
      'comments': 'true',
      'user': login,
    };
    final jsonString = await HttpRequest.get('/users/$login/comments', params: params, version: 2);

    if (jsonString.isEmpty) {
      return;
    }

    final comments = CommentList.fromJsonOld(jsonString);*/

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
