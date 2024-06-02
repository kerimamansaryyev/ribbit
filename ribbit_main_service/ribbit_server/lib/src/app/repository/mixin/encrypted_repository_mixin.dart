import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

mixin EncryptedRepositoryMixin {
  @protected
  String hasString(String original) {
    final hashed = utf8.encode(original);
    final encrypted = sha256.convert(hashed);

    return encrypted.toString();
  }

  @protected
  bool validateString({
    required String given,
    required String hashed,
  }) =>
      hasString(given) == hashed;
}
