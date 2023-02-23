import '../../../../core/common/responses/response.dart';
import '../../entities/post.dart';
import '../../repositories/database_repository.dart';

class GetPostsUseCase {
  final DatabaseRepository<Post> repository;

  GetPostsUseCase({
    required this.repository,
  });

  Future<Response> call() => repository.gets();
}
