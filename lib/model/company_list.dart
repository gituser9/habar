import 'dart:convert';

class CompanyList {
  CompanyList({
    required this.companies,
  });

  final List<Company> companies;

  factory CompanyList.fromJson(String str) => CompanyList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompanyList.fromMap(Map<String, dynamic> json) => CompanyList(
        companies: json["data"] == null ? [] : List<Company>.from(json["data"].map((x) => Company.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(companies.map((x) => x.toMap())),
      };
}

class Company {
  Company({
    required this.id,
    required this.alias,
    required this.name,
    required this.specializm,
    required this.description,
    required this.url,
    required this.fansCount,
    required this.icon,
    required this.path,
  });

  final int id;
  final String alias;
  final String name;
  final String specializm;
  final String description;
  final String url;
  final int fansCount;
  final String icon;
  final String path;

  factory Company.fromJson(String str) => Company.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? 0 : json["id"],
        alias: json["alias"] == null ? '' : json["alias"],
        name: json["name"] == null ? '' : json["name"],
        specializm: json["specializm"] == null ? '' : json["specializm"],
        description: json["description"] == null ? '' : json["description"],
        url: json["url"] == null ? '' : json["url"],
        fansCount: json["fans_count"] == null ? 0 : json["fans_count"],
        icon: json["icon"] == null ? '' : json["icon"],
        path: json["path"] == null ? '' : json["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "name": name,
        "specializm": specializm,
        "description": description,
        "url": url,
        "fans_count": fansCount,
        "icon": icon,
        "path": path,
      };
}
