import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/util.dart';
import 'package:habar/model/post.dart';
import 'package:habar/profile/profile_screen.dart';

import '../costants.dart';

class UserInfoWidget extends StatelessWidget {
  final DateTime publishTime;
  final Author author;

  UserInfoWidget({
    required this.publishTime,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => Get.to(() => ProfileScreen(login: author.alias)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Util.getAvatar(author.avatarUrl, 30),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getFullname(),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
              ),
              Text(
                _getTimeString(),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  String _getFullname() {
    if (author.alias.isNotEmpty) {
      return author.alias + ' ';
    }

    if (author.fullname.isNotEmpty) {
      return author.fullname + ' ';
    }

    return '';
  }

  String _getTimeString() {
    final now = DateTime.now();
    final hours = publishTime.hour.toString().padLeft(2, '0');
    final minutes = publishTime.minute.toString().padLeft(2, '0');
    final day = publishTime.day;

    bool today = day == now.day && publishTime.month == now.month && publishTime.year == now.year;

    if (today) {
      return 'сегодня, в $hours:$minutes';
    }

    if (publishTime.year != now.year) {
      return '$day ${Constant.mothNames[publishTime.month]} ${publishTime.year}, в $hours:$minutes';
    }

    if (publishTime.month != now.month) {
      return '$day ${Constant.mothNames[publishTime.month]}, в $hours:$minutes';
    }

    switch (now.day - publishTime.day) {
      case 1:
        return 'вчера, в $hours:$minutes';
      case 2:
        return 'позавчера, в $hours:$minutes';
      default:
        return '$day ${Constant.mothNames[publishTime.month]}, в $hours:$minutes';
    }
  }
}
