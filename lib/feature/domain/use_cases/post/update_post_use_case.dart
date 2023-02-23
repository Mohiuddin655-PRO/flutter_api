import '../../../../core/common/responses/response.dart';
import '../../entities/post.dart';
import '../../repositories/database_repository.dart';

class UpdatePostUseCase {
  final DatabaseRepository<Post> repository;

  UpdatePostUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return repository.update(id, data);
  }
}
