import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile({
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
    required this.gender,
    required this.rating,
    required this.ratingPos,
    required this.scoreStats,
    required this.lastActivityDateTime,
    required this.registerDateTime,
    required this.counterStats,
  });

  final String alias;
  final String? fullname;
  final String? avatarUrl;
  final String? speciality;
  final String gender;
  final double rating;
  final double? ratingPos;
  final ScoreStat? scoreStats;
  final DateTime lastActivityDateTime;
  final DateTime registerDateTime;
  final Counters counterStats;

  factory Profile.empty() => Profile(
        alias: '',
        fullname: null,
        avatarUrl: null,
        speciality: null,
        gender: '0',
        rating: 0,
        ratingPos: 0,
        scoreStats: ScoreStat(score: 0, votesCount: 0),
        lastActivityDateTime: DateTime.now(),
        registerDateTime: DateTime.now(),
        counterStats: Counters.empty(),
      );

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

@JsonSerializable()
class ScoreStat {
  final double score;
  final double votesCount;

  ScoreStat({
    required this.score,
    required this.votesCount,
  });

  factory ScoreStat.fromJson(Map<String, dynamic> json) => _$ScoreStatFromJson(json);
}

@JsonSerializable()
class WhoIs {
  final String alias;
  final String aboutHtml;
  final List<Badge> badgets;
  final List<Contact> contacts;

  WhoIs({
    required this.badgets,
    required this.contacts,
    required this.alias,
    required this.aboutHtml,
  });

  factory WhoIs.empty() => WhoIs(
        badgets: [],
        contacts: [],
        alias: '',
        aboutHtml: '',
      );

  factory WhoIs.fromJson(Map<String, dynamic> json) => _$WhoIsFromJson(json);
}

@JsonSerializable()
class Contact {
  final String title;
  final String url;
  final String value;
  final String? siteTitle;
  final String? favicon;

  Contact({
    required this.title,
    required this.url,
    required this.value,
    required this.siteTitle,
    required this.favicon,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}

@JsonSerializable()
class Badge {
  Badge({
    required this.title,
    required this.description,
    required this.url,
    required this.isRemovable,
  });

  final String title;
  final String description;
  final String? url;
  final bool isRemovable;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

@JsonSerializable()
class CommonTag {
  CommonTag({
    required this.name,
    required this.count,
  });

  final String name;
  final int count;

  factory CommonTag.fromJson(Map<String, dynamic> json) => _$CommonTagFromJson(json);

  Map<String, dynamic> toMap() => _$CommonTagToJson(this);
}

@JsonSerializable()
class Counters {
  Counters({
    required this.postCount,
    required this.commentCount,
    required this.favoriteCount,
  });

  final int postCount;
  final int commentCount;
  final int favoriteCount;

  factory Counters.empty() => Counters(postCount: 0, commentCount: 0, favoriteCount: 0);

  factory Counters.fromJson(Map<String, dynamic> json) => _$CountersFromJson(json);

  Map<String, dynamic> toMap() => _$CountersToJson(this);
}
