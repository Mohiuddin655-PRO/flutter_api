import 'package:flutter_api/core/common/data_sources/api_data_source.dart';

class AppContents {}

class ApiPaths {
  const ApiPaths._();

  static const Api api = Api(api: "https://jsonplaceholder.typicode.com");
  static const String posts = "posts";
  static const String comments = "comments";
  static const String users = "users";
}
