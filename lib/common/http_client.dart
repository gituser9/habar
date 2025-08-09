import 'package:dio/dio.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/model/comment_list.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/model/hub_company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/news.dart';
import 'package:habar/model/post.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/model/profile_list.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:retrofit/retrofit.dart';

part 'http_client.g.dart';

@RestApi(baseUrl: 'https://habr.com/kek/v2')
abstract class HttpClient {
  factory HttpClient(Dio dio, {String? baseUrl}) = _HttpClient;

  @GET('/articles/{id}')
  Future<Post> post(@Path('id') String id);

  @GET('/articles/{id}/comments')
  Future<CommentList> comments(@Path('id') String postId);

  @GET('/hubs/{name}/profile')
  Future<Hub> hub(@Path('name') String name);

  @GET('/articles')
  Future<PostList> hubArticles(
    @Query('page') int page,
    @Query('sort') String sort,
    @Query('hub') String hub,
  );

  @GET('/hubs/{name}/authors')
  Future<HubAuthorList> hubAuthors(
    @Path('name') String name,
    @Query('page') int page,
    @Query('perPage') int perPage,
  );

  @GET('/hubs/{name}/companies')
  Future<HubCompanyList> hubCompanies(
    @Path('name') String name,
    @Query('page') int page,
    @Query('perPage') int perPage,
    @Query('sector') String sector,
    @Query('order') String order,
    @Query('orderDirection') String orderDirection,
    @Query('hubAlias') String hubAlias,
  );

  @GET('/hubs/search')
  Future<HubList> hubSearch(@Query('q') String query);

  @GET('/hubs')
  Future<HubList> hubs(@Query('page') int page, @Query('perPage') int perPage);

  // todo: remove
  @GET('/hubs')
  Future<HubList> hubsByFilters(
    @Query('page') int page,
    @Query('perPage') int perPage,
    @Query('sort') String sort,
    @Query('order') String order,
  );

  @GET('/users/{login}/card')
  Future<Profile> profile(@Path('login') String login);

  @GET('/users/{login}/whois')
  Future<WhoIs> whois(@Path('login') String login);

  @GET('/users/{login}/hubs')
  Future<HubList> userHubs(@Path('login') String login);

  @GET('/users/{login}/subscriptions/companies')
  Future<CompanyList> userCompanies(@Path('login') String login);

  @GET('/users/{login}/invited')
  Future<ProfileList> invited(@Path('login') String login);

  @GET('/users/search')
  Future<SearchUserResponse> userSearch({
    @Query('q') required String query,
    @Query('page') required int page,
    @Query('order') required String order,
    @Query('target_type') String targetType = 'users',
  });

  @GET('/articles')
  Future<PostList> userArticles(
    @Query('page') int page,
    @Query('perPage') int perPage,
    @Query('user') String login,
  );

  @GET('/users/{login}/comments')
  Future<CommentList> userComments(
    @Path('login') String login,
    @Query('page') int page,
    @Query('user') String userLogin,
  );

  @GET('/articles')
  Future<PostList> articlesByFilters({
    @Query('page') int page = 1,
    @Query('perPage') int perPage = Constant.pageSize,
    @Query('flow') String? flow,
    @Query('sort') String? sort,
    @Query('score') String? score,
    @Query('period') String? period,
    @Query('complexity') String? complexity,
    @Query('myFeed') bool? myFeed,
    @Query('types[0]') String? types,
    @Query('flowNews') bool? flowNews,
  });

  @GET('/articles')
  Future<SearchPostResponse> articlesSearch({
    @Query('query') required String query,
    @Query('order') required String order,
    @Query('page') required int page,
    @Query('perPage') int perPage = Constant.pageSize,
  });

  @GET('/news')
  Future<NewsList> news({
    @Query('page') required int page,
    @Query('selection') required String selection,
    @Query('extend_context') bool? extendContext = false,
    @Query('perPage') int perPage = Constant.pageSize,
  });
}

class HabrClient {
  HabrClient._privateConstructor();

  static final HabrClient _instance = HabrClient._privateConstructor();

  static HabrClient get instance => _instance;

  late final HttpClient _httpClient = HttpClient(_createDio());

  Dio _createDio() {
    var dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters.addAll({
          'fl': 'ru',
          'hl': 'ru',
        });
        return handler.next(options);
      },
    ));

    return dio;
  }

  Future<Post> post(String id) => _httpClient.post(id);

  Future<CommentList> comments(@Path('id') String postId) => _httpClient.comments(postId);

  Future<Hub> hub(@Path('name') String name) => _httpClient.hub(name);

  Future<PostList> hubArticles(int page, String sort, String hub) => _httpClient.hubArticles(page, sort, hub);

  Future<HubAuthorList> hubAuthors(String name, int page, int perPage) => _httpClient.hubAuthors(name, page, perPage);

  Future<HubCompanyList> hubCompanies(
    String name,
    int page,
    int perPage,
    String sector,
    String order,
    String orderDirection,
    String hubAlias,
  ) =>
      _httpClient.hubCompanies(name, page, perPage, sector, order, orderDirection, hubAlias);

  Future<HubList> hubSearch(@Query('q') String query) => _httpClient.hubSearch(query);

  Future<Profile> profile(String login) => _httpClient.profile(login);

  Future<WhoIs> whois(String login) => _httpClient.whois(login);

  Future<HubList> userHubs(String login) => _httpClient.userHubs(login);

  Future<CompanyList> userCompanies(String login) => _httpClient.userCompanies(login);

  Future<ProfileList> invited(String login) => _httpClient.invited(login);

  Future<PostList> userArticles(int page, int perPage, String login) => _httpClient.userArticles(page, perPage, login);

  Future<CommentList> userComments(String login, int page) => _httpClient.userComments(login, page, login);

  Future<HubList> hubsByFilters(
    int page,
    int perPage,
    String sort,
    String order,
  ) =>
      _httpClient.hubsByFilters(page, perPage, sort, order);

  Future<PostList> articlesByFilters({
    int page = 1,
    int perPage = Constant.pageSize,
    String? flow,
    String? sort,
    String? score,
    String? period,
    String? complexity,
    bool? myFeed,
    String? types,
    bool? flowNews,
  }) =>
      _httpClient.articlesByFilters(
        page: page,
        perPage: perPage,
        flow: flow,
        sort: sort,
        score: score,
        period: period,
        complexity: complexity,
        myFeed: myFeed,
        types: types,
        flowNews: flowNews,
      );

  Future<SearchUserResponse> userSearch({
    required String query,
    required int page,
    required String order,
    String targetType = 'users',
  }) =>
      _httpClient.userSearch(
        query: query,
        page: page,
        order: order,
        targetType: targetType,
      );

  Future<SearchPostResponse> articlesSearch({
    required String query,
    required String order,
    required int page,
    int perPage = Constant.pageSize,
  }) =>
      _httpClient.articlesSearch(
        query: query,
        order: order,
        page: page,
        perPage: perPage,
      );

  Future<NewsList> news({
    required int page,
    required String selection,
    bool? extendContext = false,
    int perPage = Constant.pageSize,
  }) =>
      _httpClient.news(page: page, selection: selection, extendContext: extendContext, perPage: perPage);
}
