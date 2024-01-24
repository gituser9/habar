import 'dart:convert';

class CompanyList {
  CompanyList({
    required this.companies,
    required this.pagesCount,
    required this.companyIds,
  });

  final int pagesCount;
  final List<Company> companies;
  final List<String> companyIds;

  factory CompanyList.fromJson(String str) => CompanyList.fromMap(json.decode(str));

  factory CompanyList.fromMap(Map<String, dynamic> json) => CompanyList(
        companies: json["companyRefs"] == null ? [] : Company.buildListFromJson(json["companyRefs"]),
        pagesCount: json["pagesCount"] ?? 0,
        companyIds: json["companyIds"] == null ? [] : List<String>.from(json["companyIds"]),
      );
}

class Company {
  Company({
    required this.id,
    required this.alias,
    required this.name,
    required this.description,
    required this.icon,
    required this.stat,
  });

  final String id;
  final String alias;
  final String name;
  final String description;
  final String icon;
  final CompanyStat stat;

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  factory Company.fromMap2(Map<String, dynamic> json) {
    var name = json.keys.first;

    return Company.fromMap(json[name]);
  }

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json["id"] ?? '0',
        alias: json["alias"] ?? '',
        name: json["titleHtml"] ?? '',
        description: json["descriptionHtml"] ?? '',
        icon: json["imageUrl"] ?? '',
        stat: CompanyStat.fromMap(json["statistics"]),
      );

  static List<Company> buildListFromJson(Map<String, dynamic> json) {
    var names = json.keys;
    List<Company> companies = [];

    for (final name in names) {
      var js = json[name];

      companies.add(Company.fromMap(js));
    }

    return companies;
  }
}

class CompanyStat {
  CompanyStat({
    required this.rating,
    required this.subscribersCount,
  });

  final int subscribersCount;
  final double rating;

  factory CompanyStat.fromJson(String str) => CompanyStat.fromMap(json.decode(str));

  factory CompanyStat.fromMap(Map<String, dynamic> json) => CompanyStat(
        rating: json["rating"] ?? 0,
        subscribersCount: json["subscribersCount"] ?? 0,
      );
}
