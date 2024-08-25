import 'dart:developer';

import 'package:dart_server/jwt/jwt.dart';
import 'package:dart_server/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../exception/http_exception.dart';
import '../helpers/id_helper.dart';
import '../mongo_connection.dart';

class UserController {
  static Future<Map<String, dynamic>> registerUser(UserModel body) async {
    final tablaUsuarios = dataBase.collection("usuarios");

    final user =
        await tablaUsuarios.findOne(where.eq("user_name", body.userName));

    if (user != null) {
      throw ServerException("Este nombre de usuario ya está en uso", 401);
    }

    body.userUID = IdHelper.createID;
    final response = {
      "token": generarJWT(body.toJson()),
    };
    await tablaUsuarios.insert(body.toJson());
    log(tablaUsuarios.toString());

    return response;
  }

  static Future<Map<String, dynamic>> loginUser(UserModel body) async {
    final tablaUsuarios = dataBase.collection("usuarios");

    final userMap = await tablaUsuarios.findOne(
        where.eq("user_name", body.userName).eq("password", body.password));

    if (userMap == null) {
      throw ServerException("Usuario o contraseña incorrecto", 401);
    }

    final userModel = UserModel.fromJson(userMap);
    final token = generarJWT(userModel.toJson());
    final decode = decodificarJWT(token);
    final response = {
      "token": token,
      "decode": decode,
    };
    log(tablaUsuarios.toString());

    return response;
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
