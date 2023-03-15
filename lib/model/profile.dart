import 'dart:convert';

class Profile {
  Profile({
    required this.data,
  });

  final ProfileData data;

  factory Profile.empty() => Profile(data: ProfileData.empty());

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        data: ProfileData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.birthday,
    required this.descriptionHtml,
    required this.commonTags,
    required this.login,
    required this.timeRegistered,
    required this.fullname,
    required this.specializm,
    required this.rating,
    required this.invitedByLogin,
    required this.displayChildren,
    required this.path,
    required this.counters,
    required this.badges,
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
  final String fullname;
  final String specializm;
  final double rating;
  final DateTime? timeInvited;
  final String invitedByLogin;
  final bool displayChildren;
  final String path;
  final Counters counters;
  final List<Badge> badges;
  final String avatar;
  final double score;
  final double ratingPosition;

  factory ProfileData.empty() => ProfileData(
        id: 0,
        birthday: '',
        descriptionHtml: '',
        commonTags: [],
        login: '',
        timeRegistered: DateTime.now(),
        fullname: '',
        specializm: '',
        rating: 0.0,
        invitedByLogin: '',
        displayChildren: false,
        path: '',
        counters: Counters.empty(),
        badges: [],
        avatar: '',
        score: 0,
        ratingPosition: 0,
      );

  factory ProfileData.fromJson(String str) => ProfileData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileData.fromMap(Map<String, dynamic> json) => ProfileData(
        id: json["id"] ?? 0,
        birthday: json["birthday"] ?? '',
        descriptionHtml: json["description_html"] ?? '',
        commonTags: json["common_tags"] == null
            ? []
            : List<CommonTag>.from(json["common_tags"].map((x) => CommonTag.fromMap(x))),
        login: json["login"] ?? '',
        timeRegistered: DateTime.parse(json["time_registered"]),
        fullname: json["fullname"] == null ? "" : json['fullname'],
        specializm: json["specializm"] ?? '',
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
        timeInvited:
            json["time_invited"] == null || json["time_invited"] == '' ? null : DateTime.parse(json["time_invited"]),
        invitedByLogin: json["invited_by_login"] ?? '',
        displayChildren: json["display_children"] ?? false,
        path: json["path"] ?? '',
        counters: Counters.fromMap(json["counters"]),
        badges: json["badges"] == null ? [] : List<Badge>.from(json["badges"].map((x) => Badge.fromMap(x))),
        avatar: json["avatar"] ?? '',
        score: json["score"] == null ? 0.0 : json["score"].toDouble(),
        ratingPosition: json["ratingPosition"] == null ? 0.0 : json["ratingPosition"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "birthday": birthday,
        "description_html": descriptionHtml,
        "common_tags": List<dynamic>.from(commonTags.map((x) => x.toMap())),
        "login": login,
        "time_registered": timeRegistered.toIso8601String(),
        "fullname": fullname,
        "specializm": specializm,
        "rating": rating,
        "time_invited": timeInvited?.toIso8601String(),
        "invited_by_login": invitedByLogin,
        "display_children": displayChildren,
        "path": path,
        "counters": counters.toMap(),
        "badges": List<dynamic>.from(badges.map((x) => x.toMap())),
        "avatar": avatar,
        "score": score,
        "ratingPosition": ratingPosition,
      };
}

class Badge {
  Badge({
    required this.id,
    required this.title,
    required this.alias,
    required this.description,
    required this.url,
    required this.isRemovable,
    required this.isDisabled,
  });

  final int id;
  final String title;
  final String alias;
  final String description;
  final String url;
  final bool isRemovable;
  final bool isDisabled;

  factory Badge.fromJson(String str) => Badge.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Badge.fromMap(Map<String, dynamic> json) => Badge(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        alias: json["alias"] ?? '',
        description: json["description"] ?? '',
        url: json["url"] ?? '',
        isRemovable: json["is_removable"] ?? false,
        isDisabled: json["is_disabled"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alias": alias,
        "description": description,
        "url": url,
        "is_removable": isRemovable,
        "is_disabled": isDisabled,
      };
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
        posts: json["posts"] ?? '',
        comments: json["comments"] ?? 0,
        followed: json["followed"] ?? 0,
        followers: json["followers"] ?? 0,
        favorites: json["favorites"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "posts": posts,
        "comments": comments,
        "followed": followed,
        "followers": followers,
        "favorites": favorites,
      };
}
