import 'package:flutter/material.dart';

import '../../../domain/entities/post.dart';
import '../../../domain/entities/user.dart';
import 'comment_body.dart';

class CommentPage extends StatelessWidget {
  static const String title = "Comment";
  static const String route = "comment";

  final Post post;
  final User user;

  const CommentPage({
    Key? key,
    required this.post,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          user.name ?? title,
        ),
      ),
      body: CommentBody(
        postId: "${post.id}",
      ),
    );
  }
}
