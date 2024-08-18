import '../jwt/jwt.dart';
import '../models/user_model.dart';

class UserHelper {
  static UserModel getUserByToken(String token) {
    final decodeToken = decodificarJWT(token);
    final user = UserModel.fromJson(decodeToken ?? {});
    if (user.userUID == null) {
      throw Exception("Error al decodificar el JWT");
    }
    return user;
  }
}
