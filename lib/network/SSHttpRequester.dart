/*
 * Author : Johnny Cheung
 * Page: 网路请求
 *
 * 开源库地址：https://pub.dev/packages/dio
 */

import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

enum SSHttpRequesterType {
  none,
  signIn,
  signUp,
  posts, // 所有帖子
  userPost,
  userManage,
}

typedef HttpRequesterCompletion = Function(
    List<dynamic>? result, String? error);

class SSHttpRequester {
  final apiUrlPrefix = "http://api.xxx.com";

  // SSHttpRequester() {}

  String getApiUrl(SSHttpRequesterType requesterType, String params) {
    String apiUrl = "";
    switch (requesterType) {
      case SSHttpRequesterType.none:
        {}
        break;
      case SSHttpRequesterType.signIn:
        {
          apiUrl = "$apiUrlPrefix/api/signin$params";
        }
        break;
      case SSHttpRequesterType.signUp:
        {
          apiUrl = "$apiUrlPrefix/api/signup$params";
        }
        break;
      case SSHttpRequesterType.posts:
        {
          apiUrl = "$apiUrlPrefix/api/saysth/post$params";
        }
        break;
      case SSHttpRequesterType.userPost:
        {
          apiUrl = "$apiUrlPrefix/api/saysth/userpost$params";
        }
        break;
      case SSHttpRequesterType.userManage:
        {
          apiUrl = "$apiUrlPrefix/api/users/manage$params";
        }
        break;
    }
    return apiUrl;
  }

  Map<String, String> getHeadersForHttp() {
    Map<String, String> headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['x-platform'] = 'iOS';
    headers['x-app-name'] = 'SaySth';
    headers["x-authorization"] = "eyJXXXXXX";
    return headers;
  }

  void getWithType(SSHttpRequesterType requesterType, String params,
      HttpRequesterCompletion completion) async {
    var response = await rootBundle.loadString('assets/data.json');
    /*
    final apiUrl = getApiUrl(requesterType, params);
    final dio = Dio();
    dio.options.headers = getHeadersForHttp();
    dynamic response;
    try {
      response = await dio.get(apiUrl);
    } catch (e) {
      print("请求发生了错误！");
      print(e);
    }
    if (response == null) {
      completion(null, response.statusMessage);
      return;
    }
    if (response.statusCode != 200) {
      completion(null, response.statusMessage);
      return;
    }*/
    Map<String, dynamic> postsDict = jsonDecode(response);
    if (!(postsDict["status"] as bool)) {
      completion(null, postsDict["err_msg"].toString());
      return;
    }
    completion(postsDict["data"] as List<dynamic>?, null);
  }
}
