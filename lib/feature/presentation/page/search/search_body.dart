import 'package:flutter/material.dart';
import 'package:flutter_api/feature/domain/use_cases/user/get_users_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../dependency_injection.dart';
import '../../../domain/entities/user.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/error_view.dart';
import '../../widget/text_view.dart';
import '../comment/comment_page.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  late final userCubit = context.read<UserCubit>();
  late final getUsers = locator<GetUsersUseCase>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: getUsers.call(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            final response = snapshot.data?.result;
            List<User> data = response is List<User> ? response : [];
            if (data.isNotEmpty) {
              return _Users(
                userCubit: userCubit,
                items: data,
              );
            } else {
              return const ErrorView(
                title: "No user found!",
                subtitle: "No user available now",
              );
            }
        }
      },
    );
  }
}

class _Users extends StatelessWidget {
  final List<User> items;
  final UserCubit userCubit;

  const _Users({
    Key? key,
    required this.items,
    required this.userCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _User(
          item: item,
          onClick: (item) {
            Navigator.pushNamed(
              context,
              CommentPage.route,
              arguments: {
                "user": item,
                "user_cubit": userCubit,
              },
            );
          },
        );
      },
    );
  }
}

class _User extends StatelessWidget {
  final User item;
  final Function(User item)? onClick;

  const _User({
    Key? key,
    required this.item,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onClick?.call(item),
      title: TextView(
        text: item.name ?? "",
      ),
      subtitle: TextView(
        text: item.email ?? "",
      ),
      leading: CircleAvatar(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "assets/img/img_user.jpeg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
