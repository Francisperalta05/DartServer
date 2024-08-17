import 'dart:developer';

import 'package:dart_server/jwt/jwt.dart';
import 'package:dart_server/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import '../mongo_connection.dart';

class UserController {
  static UserModel getUserByToken(String token) {
    final decodeToken = decodificarJWT(token);
    final user = UserModel.fromJson(decodeToken ?? {});
    if (user.userUID == null) {
      throw Exception("Error al decodificar el JWT");
    }
    return user;
  }

  static Future<Map<String, dynamic>> registerUser(UserModel body) async {
    try {
      final tablaUsuarios = dataBase.collection("usuarios");

      final user =
          await tablaUsuarios.findOne(where.eq("user_name", body.userName));

      if (user != null) {
        throw Exception("Este nombre de usuario ya está en uso");
      }

      body.userUID = Uuid().v4().toUpperCase();
      final response = {
        "token": generarJWT(body.toJson()),
      };
      await tablaUsuarios.insert(body.toJson());
      log(tablaUsuarios.toString());

      return response;
    } on Exception catch (e) {
      return {"error": e.toString().replaceAll("Exception: ", "")};
    }
  }

  static Future<Map<String, dynamic>> loginUser(UserModel body) async {
    try {
      final tablaUsuarios = dataBase.collection("usuarios");

      final userMap = await tablaUsuarios.findOne(
          where.eq("user_name", body.userName).eq("password", body.password));

      if (userMap == null) throw Exception("Usuario o contraseña incorrecto");

      final userModel = UserModel.fromJson(userMap);
      final token = generarJWT(userModel.toJson());
      final decode = decodificarJWT(token);
      final response = {
        "token": token,
        "decode": decode,
      };
      log(tablaUsuarios.toString());

      return response;
    } on Exception catch (e) {
      return {"error": e.toString().replaceAll("Exception: ", "")};
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> users = [];

    final chequeos = dataBase.collection("usuarios");
    await chequeos.find().forEach((element) {
      log(element.runtimeType.toString());

      element.forEach((key, value) {
        if (value is DateTime) {
          element[key] = value.toIso8601String();
        }
      });

      users.add(element);
    });

    return users;
  }

  static Future<List<Map<String, dynamic>>> getUserByName(
      String userName) async {
    final tablaUsuarios = dataBase.collection("usuarios");

    List<Map<String, dynamic>> users = await tablaUsuarios.find().toList();

    for (var user in users) {
      user.forEach((key, value) {
        if (value is DateTime) {
          user[key] = value.toIso8601String();
        }
      });
    }

    users.removeWhere(
        (element) => !element["nombre"].toString().contains(userName));

    log("UserLenght: ${users.length}");

    return users;
  }
}
