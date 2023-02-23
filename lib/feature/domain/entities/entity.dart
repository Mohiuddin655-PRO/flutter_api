import 'package:equatable/equatable.dart';
import 'package:flutter_api/utils/helpers/user_helper.dart';
import 'package:intl/intl.dart';

abstract class Entity extends Equatable {
  final int? id;
  final int? timeMS;

  const Entity({
    this.id,
    this.timeMS,
  });

  Map<String, dynamic> get source;

  static String get key => "$timeMills";

  static int get timeMills => DateTime.now().millisecondsSinceEpoch;

  String get time {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMS ?? 0);
    return DateFormat("hh:mm a").format(date);
  }

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMS ?? 0);
    return DateFormat("MMM dd, yyyy").format(date);
  }

  @override
  String toString() => source.toString();
}

extension StringValidator on String? {
  bool get isValid {
    return (this ?? "").isNotEmpty;
  }

  bool get isCurrentUser {
    return (this ?? "") == AuthHelper.uid;
  }
}

extension NumValidator on num? {
  String? get key {
    return this != null ? "$this" : null;
  }

  bool get isValid {
    return (this ?? 0) > 0;
  }

  bool get isCurrentUid {
    return (this ?? 0) == int.tryParse(AuthHelper.uid);
  }
}
