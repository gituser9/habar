import 'dart:convert';

class Profile {
  Profile({
    required this.data,
  });

  final ProfileData data;

  factory Profile.empty() => Profile(data: ProfileData.empty());

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        data: ProfileData.fromMap(json),
      );
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.birthday,
    required this.descriptionHtml,
    required this.commonTags,
    required this.login,
    required this.timeRegistered,
    required this.lastActivityDateTime,
    required this.fullname,
    required this.specializm,
    required this.rating,
    required this.invitedByLogin,
    required this.displayChildren,
    required this.path,
    required this.counters,
    required this.avatar,
    required this.score,
    required this.ratingPosition,
    this.timeInvited,
  });

  final int id;
  final String birthday;
  final String descriptionHtml;
  final List<CommonTag> commonTags;
  final String login;
  final DateTime timeRegistered;
  final DateTime lastActivityDateTime;
  final String fullname;
  final String specializm;
  final double rating;
  final DateTime? timeInvited;
  final String invitedByLogin;
  final bool displayChildren;
  final String path;
  final Counters counters;
  final String avatar;
  final ScoreStat score;
  final int ratingPosition;

  factory ProfileData.empty() => ProfileData(
        id: 0,
        birthday: '',
        descriptionHtml: '',
        commonTags: [],
        login: '',
        timeRegistered: DateTime.now(),
        lastActivityDateTime: DateTime.now(),
        fullname: '',
        specializm: '',
        rating: 0.0,
        invitedByLogin: '',
        displayChildren: false,
        path: '',
        counters: Counters.empty(),
        avatar: '',
        score: ScoreStat(score: 0, votesCount: 0),
        ratingPosition: 0,
      );

  factory ProfileData.fromJson(String str) => ProfileData.fromMap(json.decode(str));

  factory ProfileData.fromMap(Map<String, dynamic> json) => ProfileData(
        id: json["id"] ?? 0,
        birthday: json["birthday"] ?? '',
        descriptionHtml: json["description_html"] ?? '',
        commonTags: json["common_tags"] == null ? [] : List<CommonTag>.from(json["common_tags"].map((x) => CommonTag.fromMap(x))),
        login: json["alias"] ?? '',
        timeRegistered: DateTime.parse(json["registerDateTime"]),
        lastActivityDateTime: DateTime.parse(json["lastActivityDateTime"]),
        fullname: json["fullname"] == null ? "" : json['fullname'],
        specializm: json["speciality"] ?? '',
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
        timeInvited: json["time_invited"] == null || json["time_invited"] == '' ? null : DateTime.parse(json["time_invited"]),
        invitedByLogin: json["invited_by_login"] ?? '',
        displayChildren: json["display_children"] ?? false,
        path: json["path"] ?? '',
        counters: Counters.fromMap(json["counterStats"]),
        avatar: json["avatarUrl"] ?? '',
        score: json["scoreStats"] == null ? ScoreStat(score: 0, votesCount: 0) : ScoreStat.fromMap(json["scoreStats"]),
        ratingPosition: json["ratingPos"] == null ? 0 : json["ratingPos"].toInt(),
      );
}

class ScoreStat {
  final int score;
  final int votesCount;

  ScoreStat({
    required this.score,
    required this.votesCount,
  });

  factory ScoreStat.fromMap(Map<String, dynamic> json) => ScoreStat(
        score: json["score"] ?? 0.0,
        votesCount: json["votesCount"] ?? 0,
      );
}

class WhoIs {
  final List<Badge> badges;
  final List<Contact> contacts;
  final String alias;
  final String about;

  WhoIs({
    required this.badges,
    required this.contacts,
    required this.alias,
    required this.about,
  });

  factory WhoIs.empty() => WhoIs(
        badges: [],
        contacts: [],
        alias: '',
        about: '',
      );

  factory WhoIs.fromJson(String str) => WhoIs.fromMap(json.decode(str));

  factory WhoIs.fromMap(Map<String, dynamic> json) => WhoIs(
        badges: json["badgets"] == null ? [] : List<Badge>.from(json["badgets"].map((x) => Badge.fromMap(x))),
        contacts: json["contacts"] == null ? [] : List<Contact>.from(json["contacts"].map((x) => Contact.fromMap(x))),
        alias: json["alias"] ?? '',
        about: json["about"] ?? '',
      );
}

class Contact {
  final String title;
  final String url;
  final String value;
  final String siteTitle;

  Contact({
    required this.title,
    required this.url,
    required this.value,
    required this.siteTitle,
    required this.favicon,
  });

  final String favicon;

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        title: json["title"] ?? '',
        url: json["url"] ?? '',
        value: json["value"] ?? '',
        siteTitle: json["siteTitle"] ?? '',
        favicon: json["favicon"] ?? '',
      );
}

class Badge {
  Badge({
    required this.title,
    required this.description,
    required this.url,
    required this.isRemovable,
  });

  final String title;
  final String description;
  final String url;
  final bool isRemovable;

  factory Badge.fromJson(String str) => Badge.fromMap(json.decode(str));

  factory Badge.fromMap(Map<String, dynamic> json) => Badge(
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        url: json["url"] ?? '',
        isRemovable: json["is_removable"] ?? false,
      );
}

class CommonTag {
  CommonTag({
    required this.name,
    required this.count,
  });

  final String name;
  final int count;

  factory CommonTag.fromJson(String str) => CommonTag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CommonTag.fromMap(Map<String, dynamic> json) => CommonTag(
        name: json["name"] ?? '',
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "count": count,
      };
}

class Counters {
  Counters({
    required this.posts,
    required this.comments,
    required this.followed,
    required this.followers,
    required this.favorites,
  });

  final int posts;
  final int comments;
  final int followed;
  final int followers;
  final int favorites;

  factory Counters.empty() => Counters(posts: 0, comments: 0, followed: 0, followers: 0, favorites: 0);

  factory Counters.fromJson(String str) => Counters.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Counters.fromMap(Map<String, dynamic> json) => Counters(
        posts: json["postCount"] ?? '',
        comments: json["commentCount"] ?? 0,
        followed: json["followed"] ?? 0,
        followers: json["followers"] ?? 0,
        favorites: json["favoriteCount"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "posts": posts,
        "comments": comments,
        "followed": followed,
        "followers": followers,
        "favorites": favorites,
      };
}
