import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/search_post.dart';
import 'package:habar/model/search_user.dart';
import 'package:habar/profile/profile_screen.dart';
import 'package:habar/search/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = SearchBloc();
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _getSearchField(),
                const SizedBox(height: 4),
                _getCurrentPage(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _getBottomBar(),
      ),
    );
  }

  Widget _getSearchField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Поиск',
          suffixIcon: const Icon(Icons.search),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
        onChanged: (data) => _bloc.queryStringStream.add(data),
        onSubmitted: (queryString) async {
          _selectedIndex = 0;

          _bloc.postPageStream.add(1);
          _bloc.userPageStream.add(1);

          await Future.wait([
            _bloc.getPosts(),
            _bloc.getUsers(),
          ]);
        },
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildPostList();
      case 1:
        return _buildUserList();
      default:
        return NoDataWidget();
    }
  }

  Widget _buildPostList() {
    return StreamBuilder<SearchPostResponse>(
      stream: _bloc.postsStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.connectionState != ConnectionState.waiting && !snapshot.hasData) {
          return LoadingWidget();
        }

        final postResponse = snapshot.data!;

        return Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postResponse.articleIds.length,
                itemBuilder: (BuildContext context, int index) {
                  String postId = postResponse.articleIds[index];
                  final post = postResponse.articleRefs[postId]!;
                  final imgUrl = Util.getImgUrl(post.leadData.imageUrl, post.textHtml);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: PostWidget(article: post, imageUrl: imgUrl),
                  );
                }),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StreamBuilder<int>(
                  stream: _bloc.postPageStream,
                  initialData: 1,
                  builder: (context, pageSnapshot) {
                    return Material(
                      color: Colors.white,
                      child: PaginationWidget(
                        page: pageSnapshot.data!,
                        pageCount: postResponse.pagesCount,
                        callback: (int page) async {
                          _bloc.postPageStream.add(page);
                          await _bloc.getPosts();
                        },
                      ),
                    );
                  }),
            )
          ],
        );
      },
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<SearchUserResponse>(
      stream: _bloc.usersStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }

        final userResponse = snapshot.data!;

        return Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userResponse.userIds.length,
                itemBuilder: (ctx, index) {
                  final userId = userResponse.userIds[index];
                  final user = userResponse.userRefs[userId]!;

                  return ListTile(
                    leading: Util.getAvatar(user.avatarUrl, 40),
                    title: Row(
                      children: [
                        Text(user.fullname),
                        Text(
                          ' @' + user.alias,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                    subtitle: Text(user.speciality),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(login: user.login)),
                      );
                    },
                  );
                }),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StreamBuilder<int>(
                  stream: _bloc.userPageStream,
                  initialData: 1,
                  builder: (context, pageSnapshot) {
                    return Material(
                      color: Colors.white,
                      child: PaginationWidget(
                        page: pageSnapshot.data!,
                        pageCount: userResponse.pagesCount,
                        callback: (int page) async {
                          _bloc.userPageStream.add(page);
                          await _bloc.getUsers();
                        },
                      ),
                    );
                  }),
            )
          ],
        );
      },
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article, color: Colors.blue),
          label: 'Публикации',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.person, color: Colors.blue),
          label: 'Пользователи',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedLabelStyle: const TextStyle(color: Colors.blue),
      fixedColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
