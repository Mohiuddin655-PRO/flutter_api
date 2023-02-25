import 'dart:async';
import 'dart:core';

import 'package:flutter_api/feature/domain/entities/entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../utils/providers/api_service.dart';
import 'api_data_source.dart';

abstract class EncryptApiDataSource<T extends Entity> extends ApiDataSource<T> {
  final ApiService service;

  EncryptApiDataSource({
    required super.path,
    required this.service,
  }) : super(api: service.api);

  Future<Map<String, dynamic>> input(Map<String, dynamic>? data) async =>
      service.input(data ?? {});

  Future<Map<String, dynamic>> output(String data) async =>
      service.output(data);

  @override
  Future<Response> insert<R>({
    required Map<String, dynamic> data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    if (data.isNotEmpty) {
      final value = await input(data);
      if (value.isNotEmpty) {
        final url = id != null && id.isNotEmpty
            ? currentUrl(id, source)
            : currentSource(source);
        final reference = await database.post(url, data: value);
        if (reference.statusCode == 200 || reference.statusCode == 201) {
          final result = reference.data;
          log
              .put("Type", "INSERT")
              .put("URL", url)
              .put("RESULT", result)
              .build();
          return response.copyWith(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          log.put("Type", "INSERT").put("URL", url).put("ERROR", error).build();
          return response.copyWith(snapshot: reference, message: error);
        }
      } else {
        const error = "Unacceptable request!";
        log.put("Type", "INSERT").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } else {
      const error = "Undefined data!";
      log.put("Type", "INSERT").put("ERROR", error).build();
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
        final value = await input(data);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.put(url, data: value);
          if (reference.statusCode == 200 || reference.statusCode == 201) {
            final result = reference.data;
            log
                .put("Type", "GET")
                .put("URL", url)
                .put("RESULT", result)
                .build();
            return response.copyWith(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log
                .put("Type", "UPDATE")
                .put("URL", url)
                .put("ERROR", error)
                .build();
            return response.copyWith(snapshot: reference, message: error);
          }
        } else {
          const error = "Unacceptable request!";
          log.put("Type", "UPDATE").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined data!";
        log.put("Type", "UPDATE").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "UPDATE").put("ERROR", _).build();
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    const response = Response();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.delete(url, data: value);
          if (reference.statusCode == 200 || reference.statusCode == 201) {
            final result = reference.data;
            log
                .put("Type", "DELETE")
                .put("URL", url)
                .put("RESULT", result)
                .build();
            return response.copyWith(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log
                .put("Type", "DELETE")
                .put("URL", url)
                .put("ERROR", error)
                .build();
            return response.copyWith(snapshot: reference, message: error);
          }
        } else {
          const error = "Unacceptable request!";
          log.put("Type", "DELETE").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined request!";
        log.put("Type", "DELETE").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "DELETE").put("ERROR", _).build();
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = service.type == RequestType.get
              ? await database.get(url, data: value)
              : await database.post(url, data: value);
          final data = reference.data;
          if (reference.statusCode == 200 && data is Map) {
            final result = build(data);
            log
                .put("Type", "GET")
                .put("URL", url)
                .put("RESULT", result.runtimeType)
                .build();
            return response.copyWith(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            log.put("Type", "GET").put("URL", url).put("ERROR", error).build();
            return response.copyWith(snapshot: reference, message: error);
          }
        } else {
          const error = "Unacceptable request.";
          log.put("Type", "GET").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Undefined request.";
        log.put("Type", "GET").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("Type", "GET").put("ERROR", _).build();
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> gets<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<List<T>>();
    try {
      final value = await input(extra);
      if (value.isNotEmpty) {
        final url = currentSource(source);
        final reference = service.type == RequestType.get
            ? await database.get(url, data: value)
            : await database.post(url, data: value);
        final encryptor = reference.data;
        if (encryptor is Map) {
          final second = await service.output(encryptor);
          if (second is Map) {
            final data = second[service.body];
            if (reference.statusCode == 200 && data is List<dynamic>) {
              List<T> result = data.map((item) {
                return build(item);
              }).toList();
              log
                  .put("Type", "GETS")
                  .put("URL", url)
                  .put("SIZE", result.length)
                  .put("RESULT", result.map((e) => e.runtimeType).toList())
                  .build();
              return response.copyWith(result: result);
            } else {
              final error = "Data unmodified [${reference.statusCode}]";
              log
                  .put("TYPE", "GETS")
                  .put("URL", url)
                  .put("ERROR", error)
                  .build();
              return response.copyWith(snapshot: reference, message: error);
            }
          } else {
            const error = "Unacceptable source!";
            log.put("TYPE", "GETS").put("ERROR", error).build();
            return response.copyWith(message: error);
          }
        } else {
          const error = "Unacceptable encryptor!";
          log.put("TYPE", "GETS").put("ERROR", error).build();
          return response.copyWith(message: error);
        }
      } else {
        const error = "Unacceptable request!";
        log.put("TYPE", "GETS").put("ERROR", error).build();
        return response.copyWith(message: error);
      }
    } catch (_) {
      log.put("TYPE", "GETS").put("ERROR", _).build();
      return response.copyWith(message: _.toString());
    }
  }

  @override
  Future<Response<List<T>>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    return gets(
      onlyUpdatedData: true,
      extra: extra,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async* {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = service.type == RequestType.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            if (reference.statusCode == 200 && data is Map) {
              final result = build(data);
              log.put("LIVE", "$url : $result");
              log
                  .put("TYPE", "LIVE")
                  .put("URL", url)
                  .put("RESULT", result.runtimeType)
                  .build();
              controller.add(
                response.copyWith(result: result),
              );
            } else {
              final error = "Data unmodified [${reference.statusCode}]";
              log
                  .put("TYPE", "LIVE")
                  .put("URL", url)
                  .put("ERROR", error)
                  .build();
              controller.addError(
                response.copyWith(snapshot: reference, message: error),
              );
            }
          });
        } else {
          const error = "Unacceptable request!";
          log.put("TYPE", "LIVE").put("ERROR", error).build();
          controller.addError(
            response.copyWith(message: error),
          );
        }
      } else {
        const error = "Undefined request!";
        log.put("TYPE", "LIVE").put("ERROR", error).build();
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("TYPE", "LIVE").put("ERROR", _).build();
      controller.addError(_);
    }
    controller.stream;
  }

  @override
  Stream<Response<List<T>>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async* {
    final controller = StreamController<Response<List<T>>>();
    final response = Response<List<T>>();
    try {
      if (extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentSource(source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = service.type == RequestType.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            if (reference.statusCode == 200 && data is List<dynamic>) {
              List<T> result = data.map((item) {
                return build(item);
              }).toList();
              log
                  .put("TYPE", "LIVES")
                  .put("URL", url)
                  .put("SIZE", result.length)
                  .put("RESULT", result.map((e) => e.runtimeType).toList())
                  .build();
              controller.add(
                response.copyWith(result: result),
              );
            } else {
              final error = "Data unmodified [${reference.statusCode}]";
              log.put("TYPE", "LIVES").put("ERROR", error).build();
              controller.addError(
                response.copyWith(snapshot: reference, message: error),
              );
            }
          });
        } else {
          const error = "Unacceptable request!";
          log.put("TYPE", "LIVES").put("ERROR", error).build();
          controller.addError(
            response.copyWith(message: error),
          );
        }
      } else {
        const error = "Undefined request!";
        log.put("TYPE", "LIVE").put("ERROR", error).build();
        controller.addError(
          response.copyWith(message: error),
        );
      }
    } catch (_) {
      log.put("TYPE", "LIVES").put("ERROR", _).build();
      controller.addError(_);
    }

    controller.stream;
  }
}
