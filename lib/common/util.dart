import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static String dateToString(DateTime date, {String format = 'dd MMM yyyy'}) {
    final formatter = DateFormat(format);
    final formatted = formatter.format(date);

    return formatted;
  }

  static Widget getAvatar(String avatarUrl, double size) {
    if (avatarUrl.isNotEmpty) {
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
}
