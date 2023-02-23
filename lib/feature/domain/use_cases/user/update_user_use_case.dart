import '../../../../core/common/responses/response.dart';
import '../../entities/user.dart';
import '../../repositories/database_repository.dart';

class UpdateUserUseCase {
  final DatabaseRepository<User> repository;

  UpdateUserUseCase({
    required this.repository,
  });

  Future<Response> call({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return repository.update(id, data);
  }
}
