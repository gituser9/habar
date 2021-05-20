import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/util.dart';
import 'package:habar/hub/hub_ctrl.dart';
import 'package:habar/model/hub_authors.dart';
import 'package:habar/profile/profile_screen.dart';

class HubAuthorListWidget extends StatelessWidget {
  final HubCtrl ctrl = Get.find();
  final String name;

  HubAuthorListWidget({Key? key, required this.name}) : super(key: key) {
    ctrl.getAuthors(name, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 16),
      child: Obx(() => _buildBody(ctrl.hubAuthors.value)),
    );
  }

  Widget _buildBody(HubAuthorList authors) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: authors.authorIds.length,
      itemBuilder: (context, index) {
        final login = authors.authorIds[index];
        final author = authors.authorRefs[login]!;

        return ListTile(
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
    );
  }
}
