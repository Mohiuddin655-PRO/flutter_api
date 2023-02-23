import 'package:flutter_api/core/common/data_sources/api_data_source.dart';

import '../../../../contents.dart';
import '../../../domain/entities/user.dart';

class UserDataSource extends ApiDataSource<User> {
  UserDataSource({
    super.api = ApiPaths.api,
    super.path = ApiPaths.users,
  });

  @override
  User build(source) {
    return User.from(source);
  }
}
