import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/constants/app_info.dart';
import '../../../../dependency_injection.dart';
import '../../../../utils/helpers/user_helper.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/screen.dart';
import '../profile/profile_body.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';
import 'home_body.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  static const String title = "Home";
  static const String route = "home";

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final getUser = locator<GetUserUseCase>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: getUser.call(id: AuthHelper.uid),
      builder: (context, snapshot) {
        final data = snapshot.data?.result;
        final user = data is User ? data : const User();
        return Screen(
          title: index == 0 ? AppInfo.fullName : ProfilePage.title,
          titleAllCaps: true,
          titleCenter: true,
          titleStyle: FontWeight.bold,
          //background: KColors.primary.withOpacity(0.5),
          body: index == 1 ? const ProfileBody() : HomeBody(user: user),
          drawer: HomeDrawer(
            currentIndex: index,
            title: user.name,
            subtitle: user.email,
            photo: user.website,
            onStateChanged: (index) async {
              if (index == 2) {
                resignIn();
              } else {
                setState(() => this.index = index);
              }
            },
          ),
          actions: [
            ActionButton(
              action: () {
                return Navigator.pushNamed(
                  context,
                  SearchPage.route,
                  arguments: {
                    "user": user,
                    "user_cubit": context.read<UserCubit>(),
                  },
                );
              },
              icon: Icons.search,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        );
      },
    );
  }

  void resignIn() {}
}
