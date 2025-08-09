// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsList _$NewsListFromJson(Map<String, dynamic> json) => NewsList(
      newsIds:
          (json['newsIds'] as List<dynamic>).map((e) => e as String).toList(),
      newsRefs: (json['newsRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, NewsRef.fromJson(e as Map<String, dynamic>)),
      ),
      pagesCount: (json['pagesCount'] as num).toInt(),
    );

Map<String, dynamic> _$NewsListToJson(NewsList instance) => <String, dynamic>{
      'newsIds': instance.newsIds,
      'newsRefs': instance.newsRefs,
      'pagesCount': instance.pagesCount,
    };

NewsRef _$NewsRefFromJson(Map<String, dynamic> json) => NewsRef(
      author: NewsAuthor.fromJson(json['author'] as Map<String, dynamic>),
      checked: json['checked'],
      complexity: json['complexity'],
      editorVersion: json['editorVersion'] as String,
      flowNew: json['flowNew'],
      flows: (json['flows'] as List<dynamic>)
          .map((e) => Flow.fromJson(e as Map<String, dynamic>))
          .toList(),
      format: json['format'],
      hubs: (json['hubs'] as List<dynamic>)
          .map((e) => NewsHub.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      isCorporative: json['isCorporative'] as bool,
      isInBlacklist: json['isInBlacklist'],
      lang: $enumDecode(_$LangEnumMap, json['lang']),
      leadData: NewsLeadData.fromJson(json['leadData'] as Map<String, dynamic>),
      plannedPublishTime: json['plannedPublishTime'],
      postLabels: json['postLabels'] as List<dynamic>,
      postType: $enumDecode(_$PostTypeEnumEnumMap, json['postType']),
      publicationType:
          $enumDecode(_$PostTypeEnumEnumMap, json['publicationType']),
      readingTime: json['readingTime'],
      relatedData:
          NewsRelatedData.fromJson(json['relatedData'] as Map<String, dynamic>),
      statistics:
          NewsStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
      status: $enumDecode(_$StatusEnumMap, json['status']),
      timePublished: DateTime.parse(json['timePublished'] as String),
      titleHtml: json['titleHtml'] as String,
    );

Map<String, dynamic> _$NewsRefToJson(NewsRef instance) => <String, dynamic>{
      'author': instance.author,
      'checked': instance.checked,
      'complexity': instance.complexity,
      'editorVersion': instance.editorVersion,
      'flowNew': instance.flowNew,
      'flows': instance.flows,
      'format': instance.format,
      'hubs': instance.hubs,
      'id': instance.id,
      'isCorporative': instance.isCorporative,
      'isInBlacklist': instance.isInBlacklist,
      'lang': _$LangEnumMap[instance.lang]!,
      'leadData': instance.leadData,
      'plannedPublishTime': instance.plannedPublishTime,
      'postLabels': instance.postLabels,
      'postType': _$PostTypeEnumEnumMap[instance.postType]!,
      'publicationType': _$PostTypeEnumEnumMap[instance.publicationType]!,
      'readingTime': instance.readingTime,
      'relatedData': instance.relatedData,
      'statistics': instance.statistics,
      'status': _$StatusEnumMap[instance.status]!,
      'timePublished': instance.timePublished.toIso8601String(),
      'titleHtml': instance.titleHtml,
    };

const _$LangEnumMap = {
  Lang.RU: 'RU',
};

const _$PostTypeEnumEnumMap = {
  PostTypeEnum.NEWS: 'NEWS',
};

const _$StatusEnumMap = {
  Status.PUBLISHED: 'PUBLISHED',
};

NewsAuthor _$NewsAuthorFromJson(Map<String, dynamic> json) => NewsAuthor(
      alias: json['alias'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      fullname: json['fullname'] as String?,
      id: json['id'] as String,
      speciality: $enumDecodeNullable(_$SpecialityEnumMap, json['speciality']),
    );

Map<String, dynamic> _$NewsAuthorToJson(NewsAuthor instance) =>
    <String, dynamic>{
      'alias': instance.alias,
      'avatarUrl': instance.avatarUrl,
      'fullname': instance.fullname,
      'id': instance.id,
      'speciality': _$SpecialityEnumMap[instance.speciality],
    };

const _$SpecialityEnumMap = {
  Speciality.EMPTY: 'EMPTY',
  Speciality.THE_80_PA_SECU_ROM_KEYGEN_SONY_DADC_AG:
      'THE_80_PA_SECU_ROM_KEYGEN_SONY_DADC_AG',
};

Flow _$FlowFromJson(Map<String, dynamic> json) => Flow(
      alias: $enumDecode(_$AliasEnumMap, json['alias']),
      id: json['id'] as String,
      title: $enumDecode(_$TitleEnumMap, json['title']),
      titleHtml: $enumDecode(_$TitleEnumMap, json['titleHtml']),
    );

Map<String, dynamic> _$FlowToJson(Flow instance) => <String, dynamic>{
      'alias': _$AliasEnumMap[instance.alias]!,
      'id': instance.id,
      'title': _$TitleEnumMap[instance.title]!,
      'titleHtml': _$TitleEnumMap[instance.titleHtml]!,
    };

const _$AliasEnumMap = {
  Alias.ADMIN: 'ADMIN',
  Alias.DESIGN: 'DESIGN',
  Alias.DEVELOP: 'DEVELOP',
  Alias.MANAGEMENT: 'MANAGEMENT',
  Alias.MARKETING: 'MARKETING',
  Alias.POPSCI: 'POPSCI',
};

const _$TitleEnumMap = {
  Title.EMPTY: 'EMPTY',
  Title.FLUFFY: 'FLUFFY',
  Title.PURPLE: 'PURPLE',
  Title.STICKY: 'STICKY',
  Title.TENTACLED: 'TENTACLED',
  Title.TITLE: 'TITLE',
};

NewsHub _$NewsHubFromJson(Map<String, dynamic> json) => NewsHub(
      alias: json['alias'] as String,
      id: json['id'] as String,
      isProfiled: json['isProfiled'] as bool,
      title: json['title'] as String,
      titleHtml: json['titleHtml'] as String,
      type: $enumDecode(_$TypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NewsHubToJson(NewsHub instance) => <String, dynamic>{
      'alias': instance.alias,
      'id': instance.id,
      'isProfiled': instance.isProfiled,
      'title': instance.title,
      'titleHtml': instance.titleHtml,
      'type': _$TypeEnumMap[instance.type]!,
    };

const _$TypeEnumMap = {
  Type.COLLECTIVE: 'COLLECTIVE',
  Type.CORPORATIVE: 'CORPORATIVE',
};

NewsLeadData _$NewsLeadDataFromJson(Map<String, dynamic> json) => NewsLeadData(
      buttonTextHtml:
          $enumDecode(_$ButtonTextHtmlEnumMap, json['buttonTextHtml']),
      image: json['image'] == null
          ? null
          : NewsImage.fromJson(json['image'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      textHtml: json['textHtml'] as String,
    );

Map<String, dynamic> _$NewsLeadDataToJson(NewsLeadData instance) =>
    <String, dynamic>{
      'buttonTextHtml': _$ButtonTextHtmlEnumMap[instance.buttonTextHtml]!,
      'image': instance.image,
      'imageUrl': instance.imageUrl,
      'textHtml': instance.textHtml,
    };

const _$ButtonTextHtmlEnumMap = {
  ButtonTextHtml.EMPTY: 'EMPTY',
};

NewsImage _$NewsImageFromJson(Map<String, dynamic> json) => NewsImage(
      fit: $enumDecode(_$FitEnumMap, json['fit']),
      positionX: (json['positionX'] as num).toInt(),
      positionY: (json['positionY'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$NewsImageToJson(NewsImage instance) => <String, dynamic>{
      'fit': _$FitEnumMap[instance.fit]!,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'url': instance.url,
    };

const _$FitEnumMap = {
  Fit.COVER: 'COVER',
};

NewsRelatedData _$NewsRelatedDataFromJson(Map<String, dynamic> json) =>
    NewsRelatedData(
      bookmarked: json['bookmarked'] as bool,
      canComment: json['canComment'] as bool,
      canEdit: json['canEdit'] as bool,
      canViewVotes: json['canViewVotes'] as bool,
      unreadCommentsCount: (json['unreadCommentsCount'] as num).toInt(),
      vote: json['vote'],
      voteMinus: NewsVote.fromJson(json['voteMinus'] as Map<String, dynamic>),
      votePlus: NewsVote.fromJson(json['votePlus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsRelatedDataToJson(NewsRelatedData instance) =>
    <String, dynamic>{
      'bookmarked': instance.bookmarked,
      'canComment': instance.canComment,
      'canEdit': instance.canEdit,
      'canViewVotes': instance.canViewVotes,
      'unreadCommentsCount': instance.unreadCommentsCount,
      'vote': instance.vote,
      'voteMinus': instance.voteMinus,
      'votePlus': instance.votePlus,
    };

NewsVote _$NewsVoteFromJson(Map<String, dynamic> json) => NewsVote(
      canVote: json['canVote'] as bool,
      isChargeEnough: json['isChargeEnough'] as bool,
      isKarmaEnough: json['isKarmaEnough'] as bool,
      isPublicationLimitEnough: json['isPublicationLimitEnough'] as bool,
      isVotingOver: json['isVotingOver'] as bool,
    );

Map<String, dynamic> _$NewsVoteToJson(NewsVote instance) => <String, dynamic>{
      'canVote': instance.canVote,
      'isChargeEnough': instance.isChargeEnough,
      'isKarmaEnough': instance.isKarmaEnough,
      'isPublicationLimitEnough': instance.isPublicationLimitEnough,
      'isVotingOver': instance.isVotingOver,
    };

NewsStatistics _$NewsStatisticsFromJson(Map<String, dynamic> json) =>
    NewsStatistics(
      commentsCount: (json['commentsCount'] as num).toInt(),
      favoritesCount: (json['favoritesCount'] as num).toInt(),
      readingCount: (json['readingCount'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      votesCount: (json['votesCount'] as num).toInt(),
      votesCountMinus: (json['votesCountMinus'] as num).toInt(),
      votesCountPlus: (json['votesCountPlus'] as num).toInt(),
    );

Map<String, dynamic> _$NewsStatisticsToJson(NewsStatistics instance) =>
    <String, dynamic>{
      'commentsCount': instance.commentsCount,
      'favoritesCount': instance.favoritesCount,
      'readingCount': instance.readingCount,
      'score': instance.score,
      'votesCount': instance.votesCount,
      'votesCountMinus': instance.votesCountMinus,
      'votesCountPlus': instance.votesCountPlus,
    };
