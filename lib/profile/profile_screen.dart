import 'package:flutter/material.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/profile.dart';
import 'package:habar/profile/profile_bloc.dart';
import 'package:habar/profile/widget/articles_widget.dart';
import 'package:habar/profile/widget/comments_widget.dart';
import 'package:habar/profile/widget/user_children_widget.dart';
import 'package:habar/profile/widget/user_hubs_widget.dart';
import 'package:habar/profile/widget/user_medals_widget.dart';
import 'package:habar/profile/widget/user_person_widget.dart';
import 'package:habar/profile/widget/user_subscriptions_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String login;

  const ProfileScreen({Key? key, required this.login}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(login: login);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String login;
  final _bloc = ProfileBloc();
  int _selectedIndex = 0;

  _ProfileScreenState({required this.login}) {
    _bloc.setup(login);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _getCurrentPage(),
      ),
      bottomNavigationBar: _getBottomBar(),
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.person, color: Colors.blue),
          label: 'Профиль',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.article, color: Colors.blue),
          label: 'Публикации',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.mode_comment_rounded, color: Colors.blue),
          label: 'Комментарии',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      fixedColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 1:
        return PostsWidget(bloc: _bloc, login: login);
      case 2:
        return CommentsWidget(bloc: _bloc, login: login);
      default:
        _bloc.setup(login);
        return _buildProfilePage();
    }
  }

  Widget _buildProfilePage() {
    return StreamBuilder<Profile>(
        stream: _bloc.profileStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          final profile = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 40),
              UserPersonWidget(profile: profile),
              UserMedalsWidget(profile: profile),
              StreamBuilder<List<HubRef>>(
                  stream: _bloc.profileHubsStream,
                  builder: (context, hubSnapshot) {
                    if (!hubSnapshot.hasData) {
                      return Container();
                    }
                    if (hubSnapshot.data!.isEmpty) {
                      return Container();
                    }

                    return UserHubsWidget(hubs: hubSnapshot.data!);
                  }),
              StreamBuilder<List<ProfileData>>(
                  stream: _bloc.profileChildrenStream,
                  builder: (context, profilesSnapshot) {
                    if (!profilesSnapshot.hasData) {
                      return Container();
                    }
                    if (profilesSnapshot.data!.isEmpty) {
                      return Container();
                    }

                    return UserChildrenWidget(profiles: profilesSnapshot.data!);
                  }),
              StreamBuilder<List<Company>>(
                  stream: _bloc.profileCompaniesStream,
                  builder: (context, companySnapshot) {
                    if (!companySnapshot.hasData) {
                      return Container();
                    }
                    if (companySnapshot.data!.isEmpty) {
                      return Container();
                    }

                    return UserSubscriptions(companies: companySnapshot.data!);
                  }),
              const SizedBox(height: 50),
            ],
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
