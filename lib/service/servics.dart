import 'dart:convert';
import 'package:http/http.dart';

import '../model/model.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.unsplash.com";
  static String SERVER_PRODUCTION = "api.unsplash.com/photos??page=1&per_page=3";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Authorization': 'Client-ID sLy7DxJOs-rkxl2TqpgNrZz89z70WV-ecUyq9VGnncg',
      'Accept-Version': 'v1',
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /// /* Http Requests */

  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await post(uri, headers: getHeaders(), body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201)
      return response.body;
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await put(uri, headers: getHeaders(), body: jsonEncode(params));

    if (response.statusCode == 200) return response.body;
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await patch(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /// /* Http Apis */
  //photos??page=1&per_page=3
  static String API_LIST = "/photos";
  static String API_SEARCH = "/search/photos";
  static String API_ONE = "/photos"; //{id}
  static String API_CREATE = "/api/v1/create";
  static String API_UPDATE = "/api/v1/update/"; //{id}
  static String API_DELETE = "/api/v1/delete/"; //{id}

  /// /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> paramsGetUnsplashPage() {
    Map<String, String> params = {'?page': '1', 'per_page': '14'};
    return params;
  }

  ///#########
  static Map<String , String> paramsPage(int pageNum){
    Map<String ,  String> params = {};
    params.addAll({
      "page": pageNum.toString()
    });
    return params;
  }


  ///#Search
  static Map<String , String> paramsSearch({required String search, required int pageNum}){
    Map<String ,  String> params = {};
    params.addAll({
      "page": pageNum.toString(),
      "query": search
    });
    return params;
  }


  // static Map<String, String> paramsCreate(Post post) {
  //   Map<String, String> params = {};
  //   params.addAll({
  //     'title': post.title!,
  //     'body': post.body!,
  //     'userId': post.userId.toString(),
  //   });
  //   return params;
  // }
  //
  // static Map<String, String> paramsUpdate(Post post) {
  //   Map<String, String> params = {};
  //   params.addAll({
  //     'id': post.id.toString(),
  //     'title': post.title!,
  //     'body': post.body!,
  //     'userId': post.userId.toString(),
  //   });
  //   return params;
  // }
  // static Map<String, String> paramsCreate(Employee employee) {
  //   Map<String, String> params = {};
  //   params.addAll({
  //     "employee_name": employee.name,
  //     "employee_salary": employee.salary.toString(),
  //     "employee_age": employee.age.toString(),
  //     "profile_image": employee.image,
  //   });
  //   return params;
  // }
  //
  // static Map<String, String> paramsUpdate(Employee employee) {
  //   Map<String, String> params = {};
  //   params.addAll({
  //     "id": employee.id.toString(),
  //     "employee_name": employee.name,
  //     "employee_salary": employee.salary.toString(),
  //     "employee_age": employee.age.toString(),
  //     "profile_image": employee.image,
  //   });
  //   return params;
  // }

  /// /* Http parsing */

  static List<Post> parsePostList(String response) {
    List<Post> list = Post.postFromJson(response);
    return list;

  }

  /// /* Http parsing */

  static List<UserLinks> parseUserLinksList(String response) {
    List<UserLinks> list2 = UserLinks.userLinkFromJson(response);
    return list2;
  }

  static List<Post> parseSearchList(String response) {
    List<Post> list = Post.postFromJson(jsonEncode(jsonDecode(response)["results"]));
    return list;

  }


}
