import 'dart:developer';

import 'package:flutter_api/feature/domain/entities/entity.dart';

class Post extends Entity {
  final int? userId;
  final String? title;
  final String? body;

  const Post({
    super.timeMS,
    super.id,
    this.userId,
    this.title,
    this.body,
  });

  Post copyWith({
    int? timeMS,
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      timeMS: timeMS ?? this.timeMS,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  factory Post.from(dynamic data) {
    dynamic timeMS, id, userId, title, body;
    try {
      timeMS = data['time_mills'];
      id = data['id'];
      userId = data['userId'];
      title = data['title'];
      body = data['body'];
    } catch (e) {
      log(e.toString());
    }
    return Post(
      timeMS: timeMS is int ? timeMS : null,
      id: id is int ? id : null,
      userId: userId is int ? userId : null,
      title: title is String ? title : null,
      body: body is String ? body : null,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "time_mills": timeMS,
      "id": id,
      "userId": userId,
      "body": body,
      "title": title,
    };
  }

  @override
  List<Object?> get props => [
        timeMS,
        id,
        userId,
        title,
        body,
      ];
}
