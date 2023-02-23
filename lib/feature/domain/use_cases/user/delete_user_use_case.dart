import '../../../../core/common/responses/response.dart';
import '../../entities/user.dart';
import '../../repositories/database_repository.dart';

class DeleteUserUseCase {
  final DatabaseRepository<User> repository;

  DeleteUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
  }) async {
    return repository.delete(id);
  }
}
