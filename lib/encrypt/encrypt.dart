// ignore_for_file: depend_on_referenced_packages

import 'package:crypto/crypto.dart' show Digest, sha256;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

enum EncryptType { encrypt, decrypt }

class EncryptHelper {
  static const String encryptKey = "1004d916-80bc-4db9-b46d-421dfb4933f3";
  static String encryptData(EncryptType type, String data) {
    String? result;

    List<int> bytes = utf8.encode(encryptKey);
    Digest digest = sha256.convert(bytes);
    String base64Str = base64.encode(digest.bytes);
    encrypt.Key key = encrypt.Key.fromBase64(base64Str);
    List<int> rawIv = utf8.encode('b46d421dfb4933f3');
    String base64Space = base64.encode(rawIv);
    encrypt.IV iv = encrypt.IV.fromBase64(base64Space);
    encrypt.Encrypter encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    if (type == EncryptType.encrypt) {
      encrypt.Encrypted encrypted = encrypter.encrypt(data, iv: iv);
      result = encrypted.base64;
    } else {
      encrypt.Encrypted passwordEncrypted = encrypt.Encrypted.from64(data);
      result = encrypter.decrypt(passwordEncrypted, iv: iv);
    }

    return result;
  }
}
