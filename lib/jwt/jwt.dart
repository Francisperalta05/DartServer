import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
// Usamos el paquete integrado 'crypto' para firmar el JWT

const secretKey = "dart_server_key";

// Función para codificar en Base64URL sin relleno (sin padding)
String base64UrlEncodeNoPadding(List<int> data) {
  return base64Url
      .encode(data)
      .replaceAll('=', '')
      .replaceAll('+', '-')
      .replaceAll('/', '_');
}

// Función para decodificar de Base64URL
Uint8List base64UrlDecode(String data) {
  String normalizedData =
      base64Url.normalize(data.replaceAll('-', '+').replaceAll('_', '/'));
  return base64.decode(normalizedData);
}

// Generar un JWT manualmente
String generarJWT(Map<String, dynamic> payload) {
  // Header
  final header = {"alg": "HS256", "typ": "JWT"};

  // Codificar header y payload
  final headerEncoded =
      base64UrlEncodeNoPadding(utf8.encode(json.encode(header)));
  final payloadEncoded =
      base64UrlEncodeNoPadding(utf8.encode(json.encode(payload)));

  // Crear la firma utilizando HMAC SHA256
  final hmac = Hmac(sha256, utf8.encode(secretKey));
  final signature = hmac.convert(utf8.encode('$headerEncoded.$payloadEncoded'));
  final signatureEncoded = base64UrlEncodeNoPadding(signature.bytes);

  // Combinar header, payload y firma
  return '$headerEncoded.$payloadEncoded.$signatureEncoded';
}

// Decodificar un JWT manualmente
Map<String, dynamic>? decodificarJWT(String token) {
  try {
    // Dividir el token en partes
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token inválido');
    }

    // Decodificar header y payload
    // final header = json.decode(utf8.decode(base64UrlDecode(parts[0])));
    final payload = json.decode(utf8.decode(base64UrlDecode(parts[1])));

    // Verificar la firma
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final signature = hmac.convert(utf8.encode('${parts[0]}.${parts[1]}'));
    final signatureEncoded = base64UrlEncodeNoPadding(signature.bytes);

    if (signatureEncoded != parts[2]) {
      throw Exception('Firma inválida');
    }

    return payload;
  } catch (e) {
    print('Error al decodificar el JWT: $e');
    return null;
  }
}

 
// const secretKey = "dart_server_key";

// String generateJwt(Map<String, dynamic> payload) {
//   // final key2 = Uuid().v4();

//   // Codificar el encabezado
//   final Map<String, String> header = {'alg': 'HS256', 'typ': 'JWT'};
//   final String encodedHeader =
//       base64Url.encode(utf8.encode(jsonEncode(header)));

//   // Codificar el cuerpo (payload)
//   final String encodedPayload =
//       base64Url.encode(utf8.encode(jsonEncode(payload)));

//   // Crear el encabezado y el cuerpo combinados
//   final String combined = '$encodedHeader.$encodedPayload';

//   // Firmar el token
//   final Hmac hmac = Hmac(sha256, utf8.encode(secretKey));
//   final Uint8List bytes = utf8.encode(combined);
//   final Digest digest = hmac.convert(bytes);
//   final String signature = base64Url.encode(digest.bytes);

//   // Combinar el encabezado, el cuerpo y la firma
//   final String jwt = '$combined.$signature';

//   return jwt;
// }
