import 'package:habar/common/http_request.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/model/profile_list.dart';
import 'package:rxdart/rxdart.dart';

class ProfileRepository {
  final profileStream = BehaviorSubject<Profile>();
  final profileHubsStream = BehaviorSubject<HubList>();
  final profileCompaniesStream = BehaviorSubject<CompanyList>();
  final profileChildrenStream = BehaviorSubject<ProfileList>();
  final postsStream = BehaviorSubject<PostList>();
  final commentsStream = BehaviorSubject<CommentList>();

  Future getProfile(String login) async {
    final jsonString = await HttpRequest.get('/users/$login/profile', version: 1);

    if (jsonString.isEmpty) {
      return;
    }

    final profile = Profile.fromJson(jsonString);
    profileStream.add(profile);
  }

  Future getProfileHubs(String login) async {
    final jsonString = await HttpRequest.get('/users/$login/hubs');

    if (jsonString.isEmpty) {
      return;
    }

    final hubList = HubList.fromJson(jsonString);
    profileHubsStream.add(hubList);
  }

  Future getProfileCompanies(String login) async {
    final jsonString = await HttpRequest.get('/users/$login/companies/fan', version: 1);

    if (jsonString.isEmpty) {
      return;
    }

    final companyList = CompanyList.fromJson(jsonString);
    profileCompaniesStream.add(companyList);
  }

  Future getProfileChildren(String login) async {
    final jsonString = await HttpRequest.get('/users/$login/children', version: 1);

    if (jsonString.isEmpty) {
      return;
    }

    final profileList = ProfileList.fromJson(jsonString);
    profileChildrenStream.add(profileList);
  }

  Future getProfileArticles(String login, int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'user': login,
    };

    String jsonString = await HttpRequest.get('/articles', params: params);

    if (jsonString.isEmpty) {
      return;
    }

    var posts = PostList.fromJson(jsonString);
    postsStream.add(posts);
  }

  Future getProfileComments(String login, int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'comments': 'true',
      'user': login,
    };
    final jsonString = await HttpRequest.get('/users/$login/comments', params: params);

    if (jsonString.isEmpty) {
      return;
    }

    final comments = CommentList.fromJson(jsonString);
    commentsStream.add(comments);
  }

  void dispose() {
    profileStream.close();
    profileHubsStream.close();
    profileCompaniesStream.close();
    profileChildrenStream.close();
  }
}
