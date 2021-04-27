import 'package:flutter/material.dart';
import 'package:habar/common/util.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/profile/profile_screen.dart';

class HubAuthorListWidget extends StatelessWidget {
  final Stream<HubAuthorList> stream;

  const HubAuthorListWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HubAuthorList>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          final hubAuthorList = snapshot.data!;

          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: hubAuthorList.authorIds.length,
              itemBuilder: (context, index) {
                final login = hubAuthorList.authorIds[index];
                final author = hubAuthorList.authorRefs[login]!;

                return ListTile(
                  // leading: CircleAvatar(
                  //   backgroundColor: Colors.transparent,
                  //   backgroundImage: NetworkImage('https:' + author.avatarUrl),
                  // ),
                  leading: Util.getAvatar(author.avatarUrl, 40),
                  title: Wrap(
                    children: [
                      Text(
                        author.fullname,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '@' + author.alias,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    author.speciality,
                    style: const TextStyle(fontSize: 13),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(login: author.alias)),
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
