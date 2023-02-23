import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../entities/comment.dart';
import '../../repositories/database_repository.dart';

class LiveCommentsUseCase {
  final DatabaseRepository<Comment> repository;

  LiveCommentsUseCase({
    required this.repository,
  });

  Stream<Response> call<R>({
    required String postId,
    R? Function(R parent)? source,
  }) {
    return repository.lives((parent) {
      return "$parent/$postId/${ApiPaths.comments}";
    }, );
  }
}
