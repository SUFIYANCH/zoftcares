import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoftcares_interview/models/login_model.dart';
import 'package:zoftcares_interview/models/posts_model.dart';
import 'package:zoftcares_interview/models/version_model.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: "https://mock-api.zoft.care/"));

  Future<LoginModel?> loginApi(String email, String password) async {
    try {
      Response response =
          await dio.post("login", data: {"email": email, "password": password});
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return loginModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Login error:$e");
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

  Future<VersionModel?> versionApi() async {
    try {
      Response response = await dio.get("version");
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return versionModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Version error:$e");
    }
    return null;
  }

  Future<PostsModel?> postApi(String token) async {
    try {
      Response response = await dio.get("posts?page=1&size=10",
          options: Options(headers: {"x-auth-key": token}));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        String json = jsonEncode(response.data);

        return postsModelFromJson(json);
      }
    } on DioException catch (e) {
      log("Posts error:$e");
    }
    return null;
  }
}

final postsProvider = FutureProvider.family<PostsModel?, String>((ref, token) {
  return ApiService().postApi(token);
});
final versionProvider = FutureProvider<VersionModel?>((ref) {
  return ApiService().versionApi();
});
