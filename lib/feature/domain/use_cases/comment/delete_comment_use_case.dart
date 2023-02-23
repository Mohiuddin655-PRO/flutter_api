import 'package:flutter_api/feature/domain/entities/comment.dart';

import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class DeleteCommentUseCase {
  final DatabaseRepository<Comment> repository;

  DeleteCommentUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String postId,
    required String id,
    R? Function(R parent)? source,
  }) async {
    return repository.delete(id, (parent) {
      return "$parent/$postId/${ApiPaths.comments}";
    });
  }
}
