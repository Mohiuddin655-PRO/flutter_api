import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';

class ApiService {
  final String api;
  final String key;
  final String iv;
  final String passcode;
  final String body;
  final RequestType type;
  final Map<String, dynamic> Function(
    String request,
    String passcode,
  ) request;
  final dynamic Function(Map<String, dynamic> data) response;

  const ApiService({
    required this.api,
    required this.key,
    required this.iv,
    required this.passcode,
    required this.body,
    required this.request,
    required this.response,
    this.type = RequestType.post,
  });

  crypto.Key get _key => crypto.Key.fromUtf8(key);

  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  crypto.Encrypter get _en {
    return crypto.Encrypter(
      crypto.AES(_key, mode: crypto.AESMode.cbc),
    );
  }

  Future<Map<String, dynamic>> input(Map<String, dynamic> data) {
    return compute(_encoder, jsonEncode(data));
  }

  dynamic output(dynamic data) {
    return compute(_decoder, jsonEncode(data));
  }

  Future<Map<String, dynamic>> _encoder(String data) async {
    final encrypted = _en.encrypt(data, iv: _iv);
    return request.call(encrypted.base64, passcode);
  }

  Future<Map<String, dynamic>> _decoder(String source) async {
    final value = response.call(jsonDecode(source));
    final encrypted = crypto.Encrypted.fromBase64(value);
    final data = _en.decrypt(encrypted, iv: _iv);
    return jsonDecode(data);
  }
}

enum RequestType { get, post }
