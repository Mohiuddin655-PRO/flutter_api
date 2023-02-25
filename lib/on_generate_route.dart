import 'package:flutter/material.dart';
import 'package:flutter_api/feature/presentation/page/search/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection.dart';
import 'feature/domain/entities/post.dart';
import 'feature/domain/entities/user.dart';
import 'feature/presentation/cubits/comment_cubit.dart';
import 'feature/presentation/cubits/user_cubit.dart';
import 'feature/presentation/page/comment/comment_page.dart';
import 'feature/presentation/page/error/error_page.dart';
import 'feature/presentation/page/home/home_page.dart';
import 'feature/presentation/page/profile/profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final data = settings.arguments;
    switch (settings.name) {
      case HomePage.route:
        return routeBuilder(widget: _home(data));
      case CommentPage.route:
        return routeBuilder(widget: _comment(settings.arguments));
      case SearchPage.route:
        return routeBuilder(widget: _search(settings.arguments));
      case ProfilePage.route:
        return routeBuilder(widget: _profile());
      default:
        return routeBuilder(widget: const ErrorPage());
    }
  }
}

MaterialPageRoute routeBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}

// Default
Widget _home(dynamic data) {
  final uid = data is String ? data : "";
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => locator<UserCubit>()
          ..get(uid: uid)
          ..gets(),
      ),
    ],
    child: const HomePage(),
  );
}

Widget _comment(dynamic arguments) {
  final data = arguments is Map<String, dynamic> ? arguments : null;
  final post = data?["post"];
  final user = data?["user"];
  final userCubit = data?["user_cubit"];
  return MultiBlocProvider(
    providers: [
      if (userCubit is UserCubit) BlocProvider.value(value: userCubit),
      BlocProvider(
        create: (context) => locator<CommentCubit>(),
      ),
    ],
    child: CommentPage(
      user: user is User ? user : const User(),
      post: post is Post ? post : const Post(),
    ),
  );
}

Widget _profile() {
  return const ProfilePage();
}

Widget _search(dynamic arguments) {
  final data = arguments is Map<String, dynamic> ? arguments : null;
  final userCubit = data?["user_cubit"];
  return MultiBlocProvider(
    providers: [
      if (userCubit is UserCubit) BlocProvider.value(value: userCubit),
    ],
    child: const SearchPage(),
  );
}
