import 'package:flutter_api/feature/domain/entities/post.dart';

import '../../../../core/common/responses/response.dart';
import '../../repositories/database_repository.dart';

class GetPostUseCase {
  final DatabaseRepository<Post> repository;

  GetPostUseCase({
    required this.repository,
  });

  Future<Response> call<R>({
    required String id,
  }) async {
    return repository.get(id);
  }
}
