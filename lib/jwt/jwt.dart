import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

const secretKey = "dart_server_key";

String generateJwt(Map<String, dynamic> payload) {
  // Codificar el encabezado
  final Map<String, String> header = {'alg': 'HS256', 'typ': 'JWT'};
  final String encodedHeader =
      base64Url.encode(utf8.encode(jsonEncode(header)));

  // Codificar el cuerpo (payload)
  final String encodedPayload =
      base64Url.encode(utf8.encode(jsonEncode(payload)));

  // Crear el encabezado y el cuerpo combinados
  final String combined = '$encodedHeader.$encodedPayload';

  // Firmar el token
  final Hmac hmac = Hmac(sha256, utf8.encode(secretKey));
  final Uint8List bytes = utf8.encode(combined);
  final Digest digest = hmac.convert(bytes);
  final String signature = base64Url.encode(digest.bytes);

  // Combinar el encabezado, el cuerpo y la firma
  final String jwt = '$combined.$signature';

  return jwt;
}
