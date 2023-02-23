import '../../../../core/common/responses/response.dart';
import '../../entities/user.dart';
import '../../repositories/database_repository.dart';

class GetUserUseCase {
  final DatabaseRepository<User> repository;

  GetUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
  }) async {
    return repository.get(id);
  }
}
