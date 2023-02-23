import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/live_comments_use_case.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../dependency_injection.dart';
import '../../../../utils/helpers/user_helper.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/entity.dart';
import '../../../domain/use_cases/comment/add_comment_use_case.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../../domain/use_cases/user/update_user_use_case.dart';
import '../../widget/error_view.dart';
import 'comment_item.dart';

class CommentBody extends StatefulWidget {
  final String postId;

  const CommentBody({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentBody> createState() => _CommentBodyState();
}

class _CommentBodyState extends State<CommentBody> {
  late final getUser = locator<GetUserUseCase>();
  late final updateUser = locator<UpdateUserUseCase>();
  late final addComment = locator<AddCommentUseCase>();
  late final liveComments = locator<LiveCommentsUseCase>();
  late TextEditingController _controller;
  late List<Comment> items = [];

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Response<dynamic>>(
            stream: liveComments.call(
              postId: widget.postId,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.result;
                  if (data is List<Comment>) {
                    return _Chats(items: data);
                  } else {
                    return const ErrorView(
                      icon: Icons.message,
                      subtitle: "No message found!",
                    );
                  }
              }
            },
          ),
        ),
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(child: _Input(controller: _controller)),
              FutureBuilder(builder: (context, snapshot) {
                return _SendButton(
                  onClick: () {
                    final data = Comment(
                      timeMS: Entity.timeMills,
                      id: int.tryParse(Entity.key),
                      postId: int.tryParse(widget.postId),
                      userId: int.tryParse(AuthHelper.uid),
                      name: AuthHelper.uid,
                      email: AuthHelper.uid,
                      body: _controller.text,
                    );
                    sendMessage(widget.postId, data);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void sendMessage(String postId, Comment data) async {
    if (data.body.isValid) {
      _controller.text = "";
      await addComment.call(postId: postId, entity: data);
    }
  }
}

class _Chats extends StatefulWidget {
  final List<Comment> items;

  const _Chats({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<_Chats> createState() => _ChatsState();
}

class _ChatsState extends State<_Chats> {
  final _controller = ScrollController();
  late final keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> _keyboardSubscription;
  var _disposeIsCalled = false;

  Future<void> _scrollDown({bool isFromKeyboardListen = false}) async {
    if (isFromKeyboardListen) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposeIsCalled) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      _scrollDown(isFromKeyboardListen: true);
    });
    _scrollDown();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _Chats oldWidget) {
    _scrollDown();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _disposeIsCalled = true;
    _keyboardSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      controller: _controller,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return CommentItem(
          item: item,
        );
      },
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;

  const _Input({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            hintText: "Type something...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final Function()? onClick;

  const _SendButton({
    Key? key,
    this.enabled = true,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: enabled ? onClick : null,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
