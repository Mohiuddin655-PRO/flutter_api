import 'package:flutter_api/feature/domain/use_cases/comment/add_comment_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/delete_comment_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/get_comment_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/get_comments_use_case.dart';
import 'package:flutter_api/feature/domain/use_cases/comment/update_update_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/states/cubit_state.dart';
import '../../../core/utils/validators/validator.dart';
import '../../domain/entities/comment.dart';

class CommentCubit extends Cubit<CubitState> {
  final AddCommentUseCase addCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final GetCommentUseCase getCommentUseCase;
  final GetCommentsUseCase getCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;

  CommentCubit({
    required this.addCommentUseCase,
    required this.deleteCommentUseCase,
    required this.getCommentUseCase,
    required this.getCommentsUseCase,
    required this.updateCommentUseCase,
  }) : super(CubitState());

  Future<void> create({
    required String postId,
    required Comment entity,
  }) async {
    if (Validator.isValidString("${entity.id}")) {
      final response = await addCommentUseCase.call(
        entity: entity,
        postId: postId,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: entity));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'ID is not valid!'));
    }
  }

  Future<void> update({
    required String id,
    required String postId,
    required Map<String, dynamic> data,
  }) async {
    if (Validator.isValidString(postId) && Validator.isValidString(id)) {
      final response = await updateCommentUseCase.call(
        id: id,
        postId: postId,
        data: data,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: data));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'Requirement not valid!'));
    }
  }

  Future<void> get({
    required String id,
    required String postId,
  }) async {
    if (Validator.isValidString(postId) && Validator.isValidString(id)) {
      final response = await getCommentUseCase.call(
        id: id,
        postId: postId,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: response.result));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'Requirement not valid!'));
    }
  }

  Future<void> gets({
    required String postId,
  }) async {
    final response = await getCommentsUseCase.call(
      postId: postId,
    );
    if (response.isSuccessful) {
      emit(state.copyWith(result: response.result));
    } else {
      emit(state.copyWith(exception: response.message));
    }
  }

  Future<void> delete({
    required String id,
    required String postId,
  }) async {
    if (Validator.isValidString(id)) {
      final response = await deleteCommentUseCase.call(
        id: id,
        postId: postId,
      );
      if (response.isSuccessful) {
        emit(state.copyWith(data: id));
      } else {
        emit(state.copyWith(exception: response.message));
      }
    } else {
      emit(state.copyWith(exception: 'User ID is not valid!'));
    }
  }
}
