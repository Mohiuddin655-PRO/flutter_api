import 'package:flutter_api/feature/components/api_secret.dart';
import 'package:flutter_api/feature/data/remote/data_sources/comment_data_source.dart';
import 'package:flutter_api/feature/data/remote/repository_impls/post_repository.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/delete_comment_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/get_comment_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/get_comments_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/live_comments_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/update_update_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/post/add_post_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/post/delete_post_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/post/get_post_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/post/get_posts_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/post/update_post_use_case.dart';
import 'package:get_it/get_it.dart';

import 'feature/data/remote/data_sources/post_data_source.dart';
import 'feature/data/remote/data_sources/user_data_source.dart';
import 'feature/data/remote/repository_impls/comment_repository.dart';
import 'feature/data/remote/repository_impls/user_repository.dart';
import 'feature/domain/entities/comment.dart';
import 'feature/domain/entities/post.dart';
import 'feature/domain/entities/user.dart';
import 'feature/domain/repositories/database_repository.dart';
import 'feature/domain/use_cases/comment/add_comment_use_case.dart';
import 'feature/domain/use_cases/user/add_user_use_case.dart';
import 'feature/domain/use_cases/user/delete_user_use_case.dart';
import 'feature/domain/use_cases/user/get_user_use_case.dart';
import 'feature/domain/use_cases/user/get_users_use_case.dart';
import 'feature/domain/use_cases/user/update_user_use_case.dart';
import 'feature/presentation/cubits/comment_cubit.dart';
import 'feature/presentation/cubits/user_cubit.dart';

//import 'index.dart';

GetIt locator = GetIt.instance;

Future<void> init() async {
  _repositories();
  _useCases();
  _cubits();
  await locator.allReady();
}

void _repositories() {
  locator.registerLazySingleton<DatabaseRepository<User>>(() {
    return UserRepository(
      remote: UserDataSource(),
    );
  });
  locator.registerLazySingleton<DatabaseRepository<Post>>(() {
    return PostRepository(
      remote: PostDataSource(service: service),
    );
  });
  locator.registerLazySingleton<DatabaseRepository<Comment>>(() {
    return CommentRepository(
      remote: CommentDataSource(),
    );
  });
}

void _useCases() {
  // USER
  locator.registerLazySingleton<AddUserUseCase>(() {
    return AddUserUseCase(repository: locator());
  });
  locator.registerLazySingleton<DeleteUserUseCase>(() {
    return DeleteUserUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetUserUseCase>(() {
    return GetUserUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetUsersUseCase>(() {
    return GetUsersUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdateUserUseCase>(() {
    return UpdateUserUseCase(repository: locator());
  });

  // POST
  locator.registerLazySingleton<AddPostUseCase>(() {
    return AddPostUseCase(repository: locator());
  });
  locator.registerLazySingleton<DeletePostUseCase>(() {
    return DeletePostUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetPostUseCase>(() {
    return GetPostUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetPostsUseCase>(() {
    return GetPostsUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdatePostUseCase>(() {
    return UpdatePostUseCase(repository: locator());
  });

  // COMMENTS
  locator.registerLazySingleton<AddCommentUseCase>(() {
    return AddCommentUseCase(repository: locator());
  });
  locator.registerLazySingleton<DeleteCommentUseCase>(() {
    return DeleteCommentUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetCommentUseCase>(() {
    return GetCommentUseCase(repository: locator());
  });
  locator.registerLazySingleton<GetCommentsUseCase>(() {
    return GetCommentsUseCase(repository: locator());
  });
  locator.registerLazySingleton<LiveCommentsUseCase>(() {
    return LiveCommentsUseCase(repository: locator());
  });
  locator.registerLazySingleton<UpdateCommentUseCase>(() {
    return UpdateCommentUseCase(repository: locator());
  });
}

void _cubits() {
  locator.registerFactory<UserCubit>(() => UserCubit(
        addUserUseCase: locator(),
        deleteUserUseCase: locator(),
        getUserUseCase: locator(),
        getUsersUseCase: locator(),
        updateUserUseCase: locator(),
      ));
  locator.registerFactory<CommentCubit>(() => CommentCubit(
        addCommentUseCase: locator(),
        deleteCommentUseCase: locator(),
        getCommentUseCase: locator(),
        getCommentsUseCase: locator(),
        updateCommentUseCase: locator(),
      ));
}
