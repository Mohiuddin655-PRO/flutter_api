import '../../../../core/common/responses/response.dart';
import '../../entities/user.dart';
import '../../repositories/database_repository.dart';

class AddUserUseCase {
  final DatabaseRepository<User> repository;

  AddUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required User entity,
  }) async {
    return repository.create(entity);
  }
}
