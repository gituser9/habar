// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      alias: json['alias'] as String,
      fullname: json['fullname'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      speciality: json['speciality'] as String?,
      gender: json['gender'] as String,
      rating: (json['rating'] as num).toDouble(),
      ratingPos: (json['ratingPos'] as num?)?.toDouble(),
      scoreStats: json['scoreStats'] == null
          ? null
          : ScoreStat.fromJson(json['scoreStats'] as Map<String, dynamic>),
      lastActivityDateTime:
          DateTime.parse(json['lastActivityDateTime'] as String),
      registerDateTime: DateTime.parse(json['registerDateTime'] as String),
      counterStats:
          Counters.fromJson(json['counterStats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'alias': instance.alias,
      'fullname': instance.fullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
      'gender': instance.gender,
      'rating': instance.rating,
      'ratingPos': instance.ratingPos,
      'scoreStats': instance.scoreStats,
      'lastActivityDateTime': instance.lastActivityDateTime.toIso8601String(),
      'registerDateTime': instance.registerDateTime.toIso8601String(),
      'counterStats': instance.counterStats,
    };

ScoreStat _$ScoreStatFromJson(Map<String, dynamic> json) => ScoreStat(
      score: (json['score'] as num).toDouble(),
      votesCount: (json['votesCount'] as num).toDouble(),
    );

Map<String, dynamic> _$ScoreStatToJson(ScoreStat instance) => <String, dynamic>{
      'score': instance.score,
      'votesCount': instance.votesCount,
    };

WhoIs _$WhoIsFromJson(Map<String, dynamic> json) => WhoIs(
      badgets: (json['badgets'] as List<dynamic>)
          .map((e) => Badge.fromJson(e as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
      alias: json['alias'] as String,
      aboutHtml: json['aboutHtml'] as String,
    );

Map<String, dynamic> _$WhoIsToJson(WhoIs instance) => <String, dynamic>{
      'alias': instance.alias,
      'aboutHtml': instance.aboutHtml,
      'badgets': instance.badgets,
      'contacts': instance.contacts,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      title: json['title'] as String,
      url: json['url'] as String,
      value: json['value'] as String,
      siteTitle: json['siteTitle'] as String?,
      favicon: json['favicon'] as String?,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'value': instance.value,
      'siteTitle': instance.siteTitle,
      'favicon': instance.favicon,
    };

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String?,
      isRemovable: json['isRemovable'] as bool,
    );

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'isRemovable': instance.isRemovable,
    };

CommonTag _$CommonTagFromJson(Map<String, dynamic> json) => CommonTag(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$CommonTagToJson(CommonTag instance) => <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
    };

Counters _$CountersFromJson(Map<String, dynamic> json) => Counters(
      postCount: (json['postCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      favoriteCount: (json['favoriteCount'] as num).toInt(),
    );

Map<String, dynamic> _$CountersToJson(Counters instance) => <String, dynamic>{
      'postCount': instance.postCount,
      'commentCount': instance.commentCount,
      'favoriteCount': instance.favoriteCount,
    };
