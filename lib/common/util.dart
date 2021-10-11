import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/profile/profile_screen.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static String getImgUrl(String imgUrl, String textHtml) {
    if (imgUrl.isNotEmpty) {
      return imgUrl;
    }

    final document = parse(textHtml);
    final img = document.querySelector("img");

    if (img == null) {
      return '';
    }

    return img.attributes["src"] ?? '';
  }

  static launchURL(String url) async {
    await launch(url);
  }

  static Future launchInternal(String url) async {
    if (url.contains('habr.com')) {
      final id = getIdFromUrl(url);
      print(id);

      if (url.contains('/post/')) {
        await Get.toNamed('/post/$id');
      } else if (url.contains('/news/')) {
        await Get.toNamed('/post/$id');
      } else if (url.contains('/blog/')) {
        await Get.toNamed('/post/$id');
      } else if (url.contains('/users/')) {
        await Get.to(() => ProfileScreen(login: id));
      }
    } else {
      await launch(url);
    }
  }

  static String dateToString(DateTime date, {String format = 'dd MMM yyyy'}) {
    final formatter = DateFormat(format);
    final formatted = formatter.format(date);

    return formatted;
  }

  static Widget getAvatar(String avatarUrl, double size) {
    if (avatarUrl.isNotEmpty && !avatarUrl.endsWith('.gif')) {
      String url = avatarUrl;

      if (!url.startsWith('https:')) {
        url = 'https:' + url;
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          url,
          width: size,
        ),
      );
    }

    return Icon(Icons.person, size: size);
  }

  static String getIdFromUrl(String url) {
    var parts = url.split('/').where((element) => element.isNotEmpty);
    return parts.last;
  }
}
