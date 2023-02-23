import 'dart:developer';

import 'package:flutter_api/feature/domain/entities/entity.dart';

class Comment extends Entity {
  final int? postId;
  final int? userId;
  final String? name;
  final String? email;
  final String? body;

  const Comment({
    super.id,
    super.timeMS,
    this.postId,
    this.userId,
    this.name,
    this.email,
    this.body,
  });

  Comment copyWith({
    int? timeMS,
    int? id,
    int? postId,
    int? userId,
    String? name,
    String? email,
    String? body,
  }) {
    return Comment(
      timeMS: timeMS ?? this.timeMS,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      body: body ?? this.body,
    );
  }

  factory Comment.from(dynamic data) {
    dynamic timeMS, id, postId, userId, name, email, body;
    try {
      timeMS = data['time_mills'];
      id = data['id'];
      postId = data['postId'];
      userId = data['userId'];
      name = data['name'];
      email = data['email'];
      body = data['body'];
    } catch (e) {
      log(e.toString());
    }
    return Comment(
      timeMS: timeMS is int ? timeMS : null,
      id: id is int ? id : null,
      postId: postId is int ? postId : null,
      userId: userId is int ? userId : null,
      name: name is String ? name : null,
      email: email is String ? email : null,
      body: body is String ? body : null,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "time_mills": timeMS,
      "id": id,
      "postId": postId,
      "userId": userId,
      "name": name,
      "email": email,
      "body": body,
    };
  }

  @override
  List<Object?> get props => [
        timeMS,
        id,
        postId,
        name,
        email,
        body,
      ];
}
