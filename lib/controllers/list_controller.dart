import 'dart:convert';
import 'dart:developer';

import 'package:dart_server/controllers/user_controller.dart';
import 'package:dart_server/models/error_model.dart';
import 'package:dart_server/models/item_model.dart';
import 'package:dart_server/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

class ItemController {
  static Future<List<Map<String, dynamic>>> getItems(String userUID) async {
    List<Map<String, dynamic>> items = [];

    final collection = dataBase.collection("listaitems");
    await collection.find(where.eq("user_uid", userUID)).forEach((element) {
      log(element.runtimeType.toString());

      element.forEach((key, value) {
        if (value is DateTime) {
          element[key] = value.toIso8601String();
        }
      });

      items.add(element);
    });

    return items;
  }

  static Future<Map<String, dynamic>> addItem(
      ItemModel body, Map<String, String> header) async {
    try {
      final token =
          header["authorization"].toString().replaceAll("Bearer ", "");
      final user = UserController.getUserByToken(token);
      body.dateCreated = DateTime.now();
      body.itemId = Uuid().v4().toUpperCase();
      body.userUID = user.userUID;
      final listCollection = dataBase.collection("listaitems");
      final response = await listCollection.insert(body.toJson);
      log(json.encode(response));
      return body.toJson;
    } on Exception catch (e) {
      return ErrorModel(e.toString()).toJson;
    }
  }

  static Future<bool> removeItem(String itemID) async {
    try {
      final data = ObjectId.parse(itemID);
      final collection = dataBase.collection("listaitems");

      final item = await collection.findOne(where.eq("_id", data));

      if (item == null) {
        return false;
      }

      final response = await collection.deleteOne(where.eq("_id", data));
      log(response.toString());
      return true;
    } on Exception {
      return false;
    }
  }
}
