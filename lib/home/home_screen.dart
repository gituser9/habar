import 'package:flutter/material.dart';
import 'package:habar/common/app_data.dart';
import 'package:habar/common/http_request.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/home_bloc.dart';
import 'package:habar/home/widgets/filter_widget.dart';
import 'package:habar/home/widgets/hub_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/home.dart';
import 'package:habar/model/post_list.dart';
import 'package:habar/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = HomeBloc();
  final Map<int, HomeMode> pageMode = {
    0: HomeMode.posts,
    1: HomeMode.news,
    2: HomeMode.hubs,
  };
  int _selectedIndex = 0;

  _HomeScreenState() {
    _bloc.setup();
  }

  @override
  void dispose() {
    super.dispose();

    HttpRequest.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _bloc.getAll(AppData.filter.filterKey);
        },
        child: _buildBody(),
      ),
      bottomNavigationBar: _getBottomBar(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<HomeMode>(
              initialData: HomeMode.posts,
              stream: _bloc.homeModeStream,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case HomeMode.posts:
                  case HomeMode.news:
                    return Container(
                      color: Colors.grey.shade200,
                      child: _buildList(),
                    );
                  case HomeMode.hubs:
                    return HubWidget(bloc: _bloc);
                  default:
                    return NoDataWidget();
                }
              }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Habar',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
        StreamBuilder<HomeMode>(
            initialData: HomeMode.posts,
            stream: _bloc.homeModeStream,
            builder: (context, snapshot) {
              if (snapshot.data == HomeMode.news) {
                return Container();
              }

              return IconButton(
                icon: const Icon(Icons.tune, color: Colors.black),
                onPressed: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return FilterWidget(
                          filter: AppData.filter,
                          bloc: _bloc,
                        );
                      });
                },
              );
            }),
      ],
    );
  }

  Widget _buildList() {
    return StreamBuilder<PostList>(
        stream: _bloc.postsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          final postList = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 4),
              StreamBuilder<bool>(
                  stream: _bloc.loadingStream,
                  initialData: true,
                  builder: (context, snapshot) {
                    if (snapshot.data!) {
                      return LoadingWidget();
                    }

                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postList.articleIds.length,
                        itemBuilder: (BuildContext context, int index) {
                          final postId = postList.articleIds[index];
                          final articleRef = postList.articleRefs[postId]!;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: PostWidget(
                                article: articleRef,
                                imageUrl: Util.getImgUrl(
                                  articleRef.leadData.imageUrl,
                                  articleRef.textHtml,
                                )),
                          );
                        });
                  }),
              const SizedBox(height: 4),
              Material(
                color: Colors.white,
                child: StreamBuilder<int>(
                    stream: _bloc.pageStream,
                    initialData: 1,
                    builder: (context, snapshot) {
                      return PaginationWidget(
                        page: snapshot.data!,
                        pageCount: postList.pagesCount,
                        callback: (int page) async {
                          _bloc.pageStream.add(page);
                          await _bloc.getAll(AppData.filter.filterKey, page: page);
                        },
                      );
                    }),
              ),
            ],
          );
        });
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article, color: Colors.blue),
          label: 'Статьи',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article_outlined, color: Colors.blue),
          label: 'Новости',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.device_hub, color: Colors.blue),
          label: 'Хабы',
        ),
        // const BottomNavigationBarItem(
        //   icon: const Icon(Icons.settings, color: Colors.blue),
        //   label: 'Настройки',
        // ),
      ],
      currentIndex: _selectedIndex,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      fixedColor: Colors.blue,
      onTap: (int index) async {
        setState(() {
          _selectedIndex = index;
        });

        final mode = pageMode[index]!;
        _bloc.pageMode = mode;
        _bloc.homeModeStream.add(mode);
        _bloc.resetPage();

        if (mode == HomeMode.hubs) {
          await _bloc.getHubs();
        } else {
          await _bloc.getAll(AppData.filter.filterKey);
        }
      },
    );
  }
}
