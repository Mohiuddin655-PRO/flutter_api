import 'package:flutter_api/contents.dart';
import 'package:flutter_api/feature/domain/entities/comment.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class AddCommentUseCase {
  final DatabaseRepository<Comment> repository;

  AddCommentUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String postId,
    required Comment entity,
  }) async {
    return repository.create(entity, (parent) {
      return "$parent/$postId/${ApiPaths.comments}";
    });
  }
}
