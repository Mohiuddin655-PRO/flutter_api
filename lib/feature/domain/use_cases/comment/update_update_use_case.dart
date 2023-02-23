import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../entities/comment.dart';
import '../../repositories/database_repository.dart';

class UpdateCommentUseCase {
  final DatabaseRepository<Comment> repository;

  UpdateCommentUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String postId,
    required String id,
    required Map<String, dynamic> data,
    R? Function(R parent)? source,
  }) async {
    return repository.update(id, data, (parent) {
      return "$parent/$postId/${ApiPaths.comments}";
    });
  }
}
