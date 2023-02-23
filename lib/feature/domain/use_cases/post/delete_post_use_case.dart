import '../../../../core/common/responses/response.dart';
import '../../entities/post.dart';
import '../../repositories/database_repository.dart';

class DeletePostUseCase {
  final DatabaseRepository<Post> repository;

  DeletePostUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
  }) async {
    return repository.delete(id);
  }
}
