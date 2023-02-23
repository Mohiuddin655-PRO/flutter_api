import 'package:flutter/material.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../dependency_injection.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../widget/text_view.dart';
import '../../widget/view.dart';

class PostItem extends StatefulWidget {
  final bool visible;
  final Post item;
  final Function(Post item, User user)? onClick;

  const PostItem({
    Key? key,
    required this.item,
    this.visible = true,
    this.onClick,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final getUser = locator<GetUserUseCase>();

  @override
  Widget build(BuildContext context) {
    return View(
      visible: widget.visible,
      child: FutureBuilder<Response>(
        future: getUser.call(
          id: "${widget.item.userId}",
        ),
        builder: (context, snapshot) {
          final user = snapshot.data?.result;
          if (user is User) {
            return ListTile(
              onTap: () => widget.onClick?.call(widget.item, user),
              title: TextView(text: user.name ?? ""),
              subtitle: TextView(
                text: widget.item.body ?? "",
                textSize: 12,
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
