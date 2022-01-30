import 'package:flutter/material.dart';

class Constant {
  static const baseUrl = "m.habr.com";
  static const Map<int, String> mothNames = {
    1: 'января',
    2: 'февраля',
    3: 'марта',
    4: 'апреля',
    5: 'мая',
    6: 'июня',
    7: 'июля',
    8: 'августа',
    9: 'сентября',
    10: 'октября',
    11: 'ноября',
    12: 'декабря',
  };
  static const TextStyle profileHeadersStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const List<InfoFlow> postFlows = [
    InfoFlow(title: 'Все потоки', alias: ''),
    InfoFlow(title: 'Разработка', alias: 'develop'),
    InfoFlow(title: 'Администрирование', alias: 'admin'),
    InfoFlow(title: 'Дизайн', alias: 'design'),
    InfoFlow(title: 'Менеджмент', alias: 'management'),
    InfoFlow(title: 'Маркетинг', alias: 'marketing'),
    InfoFlow(title: 'Научпоп', alias: 'popsci'),
  ];
}

class AppColors {
  static Color primary = Colors.blue;
  static Color accent = Colors.purpleAccent;
  static Color actionIcon = Colors.grey.shade600;
}

class InfoFlow {
  final String title;
  final String alias;

  const InfoFlow({
    required this.title,
    required this.alias,
  });
}
