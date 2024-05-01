import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class Users {
  final Db dataBase;
  Users(this.dataBase);

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> body) async {
    dataBase.dropCollection("usuarioss");
    return body;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
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

  Future<List<Map<String, dynamic>>> getUserByName(String userName) async {
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
