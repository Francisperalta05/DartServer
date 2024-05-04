import 'dart:developer';

import 'package:dart_server/jwt/jwt.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'mongo_connection.dart';

class Users {
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> body) async {
    final response = {
      "token": generateJwt(body),
    };
    final coll = dataBase.collection("usuarios");

    // await coll.remove(where.all("numero", [2]));
    log(coll.toString());

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
