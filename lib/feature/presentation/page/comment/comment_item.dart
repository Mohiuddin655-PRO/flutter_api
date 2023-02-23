import 'package:flutter/material.dart';
import 'package:flutter_api/feature/domain/entities/entity.dart';

import '../../../../core/constants/colors.dart';
import '../../../../dependency_injection.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';

class CommentItem extends StatefulWidget {
  final Comment item;

  const CommentItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late final size = MediaQuery.of(context).size;
  late final getUser = locator<GetUserUseCase>();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    const borderRadius = Radius.circular(20);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: FutureBuilder(
        future: getUser.call(id: "${widget.item.userId}"),
        builder: (context, snapshot) {
          final sender = snapshot.data?.result;
          if (sender is User) {
            return Row(
              mainAxisAlignment: item.userId.isCurrentUid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!item.userId.isCurrentUid)
                  _UserAvatar(
                    isMe: item.userId.isCurrentUid,
                    item: sender,
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: item.userId.isCurrentUid
                        ? KColors.primary.shade200
                        : KColors.primary.shade50,
                    borderRadius: item.userId.isCurrentUid
                        ? const BorderRadius.only(
                            topLeft: borderRadius,
                            topRight: borderRadius,
                            bottomLeft: borderRadius,
                          )
                        : const BorderRadius.only(
                            topLeft: borderRadius,
                            topRight: borderRadius,
                            bottomRight: borderRadius,
                          ),
                  ),
                  child: Text(
                    item.body ?? "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: item.userId.isCurrentUid
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                if (item.userId.isCurrentUid)
                  _UserAvatar(
                    isMe: item.userId.isCurrentUid,
                    item: sender,
                  ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final bool isMe;
  final User item;

  const _UserAvatar({
    Key? key,
    required this.isMe,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(
        left: isMe ? 4 : 0,
        right: isMe ? 0 : 4,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.25),
      ),
      child: item.website.isValid
          ? Image.network(
              item.website ?? "",
              fit: BoxFit.cover,
            )
          : Image.asset(
              "assets/img/img_user.jpeg",
              fit: BoxFit.cover,
            ),
    );
  }
}
