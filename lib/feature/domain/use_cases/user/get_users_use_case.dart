import '../../../../core/common/responses/response.dart';
import '../../entities/user.dart';
import '../../repositories/database_repository.dart';

class GetUsersUseCase {
  final DatabaseRepository<User> repository;

  GetUsersUseCase({
    required this.repository,
  });

  Future<Response> call() async => repository.gets();
}
