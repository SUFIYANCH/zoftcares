import 'dart:convert';

PostsModel postsModelFromJson(String str) =>
    PostsModel.fromJson(json.decode(str));

String postsModelToJson(PostsModel data) => json.encode(data.toJson());

class PostsModel {
  bool? status;
  List<Datum>? data;
  int? currentPage;
  int? pageSize;
  int? totalItems;
  int? totalPages;
  int? nextPage;
  dynamic previousPage;
  bool? hasMore;

  PostsModel({
    this.status,
    this.data,
    this.currentPage,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.hasMore,
  });

  factory PostsModel.fromJson(Map<String, dynamic> json) => PostsModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "currentPage": currentPage,
        "pageSize": pageSize,
        "totalItems": totalItems,
        "totalPages": totalPages,
        "nextPage": nextPage,
        "previousPage": previousPage,
        "hasMore": hasMore,
      };
}

class Datum {
  int? id;
  String? title;
  String? body;
  String? image;

  Datum({
    this.id,
    this.title,
    this.body,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "image": image,
      };
}
