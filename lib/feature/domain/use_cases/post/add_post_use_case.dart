import '../../../../core/common/responses/response.dart';
import '../../entities/post.dart';
import '../../repositories/database_repository.dart';

class AddPostUseCase {
  final DatabaseRepository<Post> repository;

  AddPostUseCase({
    required this.repository,
  });

  Future<Response> call({
    required Post entity,
  }) async {
    return repository.create(entity);
  }
}
