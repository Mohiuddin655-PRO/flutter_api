import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/user/add_user_use_case.dart';
import '../../domain/use_cases/user/delete_user_use_case.dart';
import '../../domain/use_cases/user/get_user_use_case.dart';
import '../../domain/use_cases/user/get_users_use_case.dart';
import '../../domain/use_cases/user/update_user_use_case.dart';

class UserCubit extends Cubit<CubitState> {
  final AddUserUseCase addUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final GetUserUseCase getUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserUseCase updateUserUseCase;

  UserCubit({
    required this.addUserUseCase,
    required this.deleteUserUseCase,
    required this.getUserUseCase,
    required this.getUsersUseCase,
    required this.updateUserUseCase,
  }) : super(CubitState());

  Future<void> create({
    required User entity,
  }) async {
    if (Validator.isValidString("${entity.id}")) {
      final response = await addUserUseCase.call(entity: entity);
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> update({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await updateUserUseCase.call(id: uid, data: data);
      if (response.isSuccessful) {
        emit(state.copyWith(data: data));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> updateState({
    required User entity,
  }) async {
    emit(state.copyWith(data: entity));
  }

  Future<void> get({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await getUserUseCase.call(id: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: response.result));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> gets() async {
    final response = await getUsersUseCase.call();
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> delete({
    required String uid,
  }) async {
    if (Validator.isValidString(uid)) {
      final response = await deleteUserUseCase.call(id: uid);
      if (response.isSuccessful) {
        emit(state.copyWith(data: uid));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }

  Future<void> save({
    required User entity,
  }) async {
    if (Validator.isValidString("${entity.id}")) {
      final response = await updateUserUseCase.call(
        id: "uid",
        data: entity.source,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }
}
