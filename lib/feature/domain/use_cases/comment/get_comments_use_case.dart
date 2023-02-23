import '../../../../contents.dart';
import '../../../../core/common/responses/response.dart';
import '../../entities/comment.dart';
import '../../repositories/database_repository.dart';

class GetCommentsUseCase {
  final DatabaseRepository<Comment> repository;

  GetCommentsUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String postId,
    R? Function(R parent)? source,
  }) async {
    return repository.gets((parent) {
      return "$parent/$postId/${ApiPaths.comments}";
    });
  }
}
