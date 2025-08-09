import 'package:habar/model/ICommnatble.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class NewsList {
  List<String> newsIds;
  Map<String, NewsRef> newsRefs;
  int pagesCount;

  NewsList({
    required this.newsIds,
    required this.newsRefs,
    required this.pagesCount,
  });

  factory NewsList.empty() => NewsList(newsIds: [], newsRefs: {}, pagesCount: 0);

  factory NewsList.fromJson(Map<String, dynamic> json) => _$NewsListFromJson(json);
}

@JsonSerializable()
class NewsRef implements ICommentable {
  NewsAuthor author;
  dynamic checked;
  dynamic complexity;
  String editorVersion;
  dynamic flowNew;
  List<Flow> flows;
  dynamic format;
  List<NewsHub> hubs;
  String id;
  bool isCorporative;
  dynamic isInBlacklist;
  Lang lang;
  NewsLeadData leadData;
  dynamic plannedPublishTime;
  List<dynamic> postLabels;
  PostTypeEnum postType;
  PostTypeEnum publicationType;
  dynamic readingTime;
  NewsRelatedData relatedData;
  NewsStatistics statistics;
  Status status;
  DateTime timePublished;
  String titleHtml;

  NewsRef({
    required this.author,
    required this.checked,
    required this.complexity,
    required this.editorVersion,
    required this.flowNew,
    required this.flows,
    required this.format,
    required this.hubs,
    required this.id,
    required this.isCorporative,
    required this.isInBlacklist,
    required this.lang,
    required this.leadData,
    required this.plannedPublishTime,
    required this.postLabels,
    required this.postType,
    required this.publicationType,
    required this.readingTime,
    required this.relatedData,
    required this.statistics,
    required this.status,
    required this.timePublished,
    required this.titleHtml,
  });

  factory NewsRef.fromJson(Map<String, dynamic> json) => _$NewsRefFromJson(json);

  @override
  String authorAlias() {
    return author.alias;
  }

  @override
  String avatarUrl() {
    return author.avatarUrl ?? '';
  }

  @override
  int commentsCount() {
    return statistics.commentsCount;
  }

  @override
  int favoritesCount() {
    return statistics.favoritesCount;
  }

  @override
  String fullName() {
    return author.fullname ?? '';
  }

  @override
  DateTime publishTime() {
    return timePublished;
  }

  @override
  int readingCount() {
    return statistics.readingCount;
  }

  @override
  int votesCount() {
    return statistics.votesCount;
  }

  @override
  String title() {
    return titleHtml;
  }

  @override
  String itemId() {
    return id;
  }
}

@JsonSerializable()
class NewsAuthor {
  String alias;
  String? avatarUrl;
  String? fullname;
  String id;
  Speciality? speciality;

  NewsAuthor({
    required this.alias,
    required this.avatarUrl,
    required this.fullname,
    required this.id,
    required this.speciality,
  });

  factory NewsAuthor.fromJson(Map<String, dynamic> json) => _$NewsAuthorFromJson(json);
}

enum Speciality { EMPTY, THE_80_PA_SECU_ROM_KEYGEN_SONY_DADC_AG }

final specialityValues = EnumValues({"Информационная служба Хабра": Speciality.EMPTY, "80_PA SecuROM keygen (Sony DADC AG)": Speciality.THE_80_PA_SECU_ROM_KEYGEN_SONY_DADC_AG});

@JsonSerializable()
class Flow {
  Alias alias;
  String id;
  Title title;
  Title titleHtml;

  Flow({
    required this.alias,
    required this.id,
    required this.title,
    required this.titleHtml,
  });

  factory Flow.fromJson(Map<String, dynamic> json) => _$FlowFromJson(json);
}

enum Alias { ADMIN, DESIGN, DEVELOP, MANAGEMENT, MARKETING, POPSCI }

final aliasValues =
    EnumValues({"admin": Alias.ADMIN, "design": Alias.DESIGN, "develop": Alias.DEVELOP, "management": Alias.MANAGEMENT, "marketing": Alias.MARKETING, "popsci": Alias.POPSCI});

enum Title { EMPTY, FLUFFY, PURPLE, STICKY, TENTACLED, TITLE }

final titleValues = EnumValues(
    {"Разработка": Title.EMPTY, "Менеджмент": Title.FLUFFY, "Научпоп": Title.PURPLE, "Дизайн": Title.STICKY, "Маркетинг": Title.TENTACLED, "Администрирование": Title.TITLE});

@JsonSerializable()
class NewsHub {
  String alias;
  String id;
  bool isProfiled;
  String title;
  String titleHtml;
  Type type;

  NewsHub({
    required this.alias,
    required this.id,
    required this.isProfiled,
    required this.title,
    required this.titleHtml,
    required this.type,
  });

  factory NewsHub.fromJson(Map<String, dynamic> json) => _$NewsHubFromJson(json);
}

enum Type { COLLECTIVE, CORPORATIVE }

final typeValues = EnumValues({"collective": Type.COLLECTIVE, "corporative": Type.CORPORATIVE});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

@JsonSerializable()
class NewsLeadData {
  ButtonTextHtml buttonTextHtml;
  NewsImage? image;
  String? imageUrl;
  String textHtml;

  NewsLeadData({
    required this.buttonTextHtml,
    required this.image,
    required this.imageUrl,
    required this.textHtml,
  });

  factory NewsLeadData.fromJson(Map<String, dynamic> json) => _$NewsLeadDataFromJson(json);
}

enum ButtonTextHtml { EMPTY }

final buttonTextHtmlValues = EnumValues({"Читать далее": ButtonTextHtml.EMPTY});

@JsonSerializable()
class NewsImage {
  Fit fit;
  int positionX;
  int positionY;
  String url;

  NewsImage({
    required this.fit,
    required this.positionX,
    required this.positionY,
    required this.url,
  });

  factory NewsImage.fromJson(Map<String, dynamic> json) => _$NewsImageFromJson(json);
}

enum Fit { COVER }

final fitValues = EnumValues({"cover": Fit.COVER});

enum PostTypeEnum { NEWS }

final postTypeEnumValues = EnumValues({"news": PostTypeEnum.NEWS});

@JsonSerializable()
class NewsRelatedData {
  bool bookmarked;
  bool canComment;
  bool canEdit;
  bool canViewVotes;
  int unreadCommentsCount;
  dynamic vote;
  NewsVote voteMinus;
  NewsVote votePlus;

  NewsRelatedData({
    required this.bookmarked,
    required this.canComment,
    required this.canEdit,
    required this.canViewVotes,
    required this.unreadCommentsCount,
    required this.vote,
    required this.voteMinus,
    required this.votePlus,
  });

  factory NewsRelatedData.fromJson(Map<String, dynamic> json) => _$NewsRelatedDataFromJson(json);
}

@JsonSerializable()
class NewsVote {
  bool canVote;
  bool isChargeEnough;
  bool isKarmaEnough;
  bool isPublicationLimitEnough;
  bool isVotingOver;

  NewsVote({
    required this.canVote,
    required this.isChargeEnough,
    required this.isKarmaEnough,
    required this.isPublicationLimitEnough,
    required this.isVotingOver,
  });

  factory NewsVote.fromJson(Map<String, dynamic> json) => _$NewsVoteFromJson(json);
}

@JsonSerializable()
class NewsStatistics {
  int commentsCount;
  int favoritesCount;
  int readingCount;
  int score;
  int votesCount;
  int votesCountMinus;
  int votesCountPlus;

  NewsStatistics({
    required this.commentsCount,
    required this.favoritesCount,
    required this.readingCount,
    required this.score,
    required this.votesCount,
    required this.votesCountMinus,
    required this.votesCountPlus,
  });

  factory NewsStatistics.fromJson(Map<String, dynamic> json) => _$NewsStatisticsFromJson(json);
}

enum Status { PUBLISHED }

final statusValues = EnumValues({"published": Status.PUBLISHED});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
