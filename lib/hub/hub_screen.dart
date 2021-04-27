import 'package:flutter/material.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/no_data_widget.dart';
import 'package:habar/common/widgets/pagination_widget.dart';
import 'package:habar/common/widgets/post_widget.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/hub/hub_bloc.dart';
import 'package:habar/hub/widget/hub_author_llist_widget.dart';
import 'package:habar/hub/widget/hub_company_list_widget.dart';
import 'package:habar/hub/widget/hub_widget.dart';
import 'package:habar/model/hub.dart';
import 'package:habar/model/post_list.dart';

class HubScreen extends StatefulWidget {
  final String name;

  const HubScreen({Key? key, required this.name}) : super(key: key);

  @override
  _HubScreenState createState() => _HubScreenState(name);
}

class _HubScreenState extends State<HubScreen> {
  int _selectedIndex = 0;
  final String name;
  final _bloc = HubBloc();

  _HubScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<Hub>(
                  stream: _bloc.hubStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingWidget();
                    }
                    return HubInfoWidget(hub: snapshot.data!);
                  }),
              Flexible(
                child: _getCurrentPage(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _getBottomBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        _bloc.setup(name);
        return _buildHubPage();
      case 1:
        _bloc.getAuthors(name, 1);
        return HubAuthorListWidget(stream: _bloc.hubAuthorsStream);
      case 2:
        _bloc.getCompanies(name, 1);
        return HubCompanyListWidget(stream: _bloc.hubCompaniesStream);
      default:
        return NoDataWidget();
    }
  }

  Widget _buildHubPage() {
    return StreamBuilder<PostList>(
        stream: _bloc.postsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          final postList = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postList.articleIds.length,
                  itemBuilder: (ctx, index) {
                    String postId = postList.articleIds[index];
                    final articleRef = postList.articleRefs[postId]!;
                    final imgUrl = Util.getImgUrl(articleRef.leadData.imageUrl, articleRef.textHtml);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: PostWidget(article: articleRef, imageUrl: imgUrl),
                    );
                  },
                ),
                StreamBuilder<int>(
                    initialData: 1,
                    stream: _bloc.pageStream,
                    builder: (context, pageSnapshot) {
                      return PaginationWidget(
                        pageCount: snapshot.data!.pagesCount,
                        page: pageSnapshot.data!,
                        callback: (int page) async {
                          _bloc.pageStream.add(page);
                          await _bloc.getPosts(this.name, page);
                        },
                      );
                    }),
              ],
            ),
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
          icon: const Icon(Icons.person, color: Colors.blue),
          label: 'Авторы',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.business, color: Colors.blue),
          label: 'Компании',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedLabelStyle: TextStyle(color: Colors.blue),
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
