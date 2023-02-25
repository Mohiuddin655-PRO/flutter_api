import 'package:flutter_api/feature/domain/entities/comment.dart';

import '../../../../core/common/data_sources/data_source.dart';
import '../../../../core/common/responses/response.dart';
import '../../../domain/repositories/database_repository.dart';

class CommentRepository extends DatabaseRepository<Comment> {
  final DataSource remote;

  CommentRepository({
    required this.remote,
  });

  @override
  Future<Response> create<R>(
    Comment entity, [
    R? Function(R parent)? source,
  ]) {
    return remote.insert(
      // id: entity.id.key, auto generate key
      data: entity.source,
      source: source,
    );
  }

  @override
  Future<Response> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.delete(
      id,
      source: source,
    );
  }

  @override
  Future<Response> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.get(
      id,
      source: source,
    );
  }

  @override
  Future<Response> getUpdates<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.getUpdates(
      source: source,
    );
  }

  @override
  Future<Response> gets<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.gets(
      source: source,
    );
  }

  @override
  Stream<Response> live<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.live(
      id,
      source: source,
    );
  }

  @override
  Stream<Response> lives<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.lives(
      source: source,
    );
  }

  @override
  Future<Response> update<R>(
    String id,
    Map<String, dynamic> map, [
    R? Function(R parent)? source,
  ]) {
    return remote.update(
      id,
      map,
      source: source,
    );
  }
}
