import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../dependency_injection.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/post/get_posts_use_case.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/error_view.dart';
import '../../widget/view.dart';
import '../comment/comment_page.dart';
import 'post_item.dart';

class HomeBody extends StatefulWidget {
  final User user;

  const HomeBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final userCubit = context.read<UserCubit>();
  late final getPosts = locator<GetPostsUseCase>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: getPosts.call(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const View(
              gravity: Alignment.center,
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            var data = snapshot.data?.result;
            if (data is List<Post>) {
              return _Posts(
                user: widget.user,
                userCubit: userCubit,
                items: data,
              );
            }

            return const ErrorView(
              title: "No post found!",
              subtitle: "You haven't post yet",
              icon: Icons.person_outline,
            );
        }
      },
    );
  }
}

class _Posts extends StatelessWidget {
  final User user;
  final List<Post> items;
  final UserCubit userCubit;

  const _Posts({
    Key? key,
    required this.user,
    required this.items,
    required this.userCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PostItem(
          item: item,
          onClick: (item, user) {
            Navigator.pushNamed(
              context,
              CommentPage.route,
              arguments: {
                "post": item,
                "user": user,
                "user_cubit": userCubit,
              },
            );
          },
        );
      },
    );
  }
}
