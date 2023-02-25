import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_api/feature/domain/entities/entity.dart';

import '../../../../core/common/responses/response.dart';
import 'data_source.dart';

abstract class ApiDataSource<T extends Entity> extends DataSource<T> {
  final String api;
  final String path;

  ApiDataSource({
    required this.path,
    required this.api,
  });

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String _source<R>(
    R? Function(R parent)? source,
  ) {
    final reference = "$api/$path";
    dynamic current = source?.call(reference as R);
    if (current is String) {
      return current;
    } else {
      return reference;
    }
  }

  String _url<R>(String id, R? Function(R parent)? source) =>
      "${_source(source)}/$id";

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final url =
          id != null && id.isNotEmpty ? _url(id, source) : _source(source);
      final reference = await database.post(url, data: data);
      if (reference.statusCode == 200 || reference.statusCode == 201) {
        final result = reference.data;
        log.put("INSERT", "$url : $result");
        return response.copyWith(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        log.put("INSERT", "$url : $error");
        return response.copyWith(snapshot: reference, message: error);
      }
    } else {
      final error = "Undefined data $data";
      log.put("INSERT", error);
      return response.copyWith(message: error);
    }
  }

  @override
  Future<Response> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      if (data.isNotEmpty) {
        final url = _url(id, source);
        final reference = await database.put(url, data: data);
        if (reference.statusCode == 200 || reference.statusCode == 201) {
          final result = reference.data;
          log.put("UPDATE", "$url : $result");
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("UPDATE", "$url : $error");
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined data $data";
        log.put("UPDATE", error);
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("UPDATE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      if (id.isNotEmpty) {
        final url = _url(id, source);
        final reference = await database.delete(url);
        if (reference.statusCode == 200 || reference.statusCode == 201) {
          final result = reference.data;
          log.put("DELETE", "$url : $result");
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("DELETE", "$url : $error");
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        log.put("DELETE", error);
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("DELETE", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        final url = _url(id, source);
        final reference = await database.get(url);
        final data = reference.data;
        if (reference.statusCode == 200 && data is Map) {
          final result = build(data);
          log.put("GET", "$url : $result");
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("GET", "$url : $error");
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        log.put("GET", error);
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("GET", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets<R>({
    bool onlyUpdatedData = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<List<T>>();
    try {
      final url = _source(source);
      final reference = await database.get(url);
      final data = reference.data;
      if (reference.statusCode == 200 && data is List<dynamic>) {
        List<T> result = data.map((item) {
          return build(item);
        }).toList();
        log.put("GETS", "$url : $result");
        return response.copyWith(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        log.put("GETS", "$url : $error");
        return response.copyWith(snapshot: reference, message: error);
      }
    } catch (_) {
      log.put("GETS", _.toString());
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates<R>({
    R? Function(R parent)? source,
  }) {
    return gets(
      onlyUpdatedData: true,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        final url = _url(id, source);
        Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
          final reference = await database.get(url);
          final data = reference.data;
          if (reference.statusCode == 200 && data is Map) {
            final result = build(data);
            log.put("LIVE", "$url : $result");
            controller.add(
              response.copyWith(result: result),
            );
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log.put("LIVE", "$url : $error");
            controller.addError(
              response.copyWith(snapshot: reference, message: error),
            );
          }
        });
      } else {
        final error = "Undefined ID [$id]";
        log.put("LIVE", error);
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("LIVE", _.toString());
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<List<T>>> lives<R>({
    bool onlyUpdatedData = false,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      final url = _source(source);
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        final reference = await database.get(url);
        final data = reference.data;
        if (reference.statusCode == 200 && data is List<dynamic>) {
          List<T> result = data.map((item) {
            return build(item);
          }).toList();
          log.put("LIVES", "$url : $result");
          controller.add(
            response.copyWith(result: result),
          );
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("LIVES", "$url : $error");
          controller.addError(
            response.copyWith(snapshot: reference, message: error),
          );
        }
      });
    } catch (_) {
      log.put("LIVES", _.toString());
      controller.addError(_);
    }

    return controller.stream;
  }
}
