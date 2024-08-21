import 'dart:convert';

VersionModel versionModelFromJson(String str) =>
    VersionModel.fromJson(json.decode(str));

String versionModelToJson(VersionModel data) => json.encode(data.toJson());

class VersionModel {
  bool? status;
  Data? data;

  VersionModel({
    this.status,
    this.data,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? version;

  Data({
    this.version,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
      };
}
