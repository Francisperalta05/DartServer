import 'dart:convert';
import 'dart:developer';

import 'package:dart_server/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ListController {
  static Future<List<Map<String, dynamic>>> getItems() async {
    List<Map<String, dynamic>> items = [];

    final collection = dataBase.collection("listaitems");
    await collection.find().forEach((element) {
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

  static Future<Map<String, dynamic>> addItem(Map<String, dynamic> body) async {
    final listCollection = dataBase.collection("listaitems");
    final response = await listCollection.insert(body);
    log(json.encode(response));
    return body;
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

  static Future<Map<String, dynamic>> setWarRoom(
      Map<String, dynamic> body) async {
    final warroom = {
      "isWarRoom": body["isWarRoom"],
      "users": [
        "22300849704",
        "05900111849",
        "40220724633",
        "40220904086",
        "40220943159",
        "00118314723"
      ],
    };

    final collection = dataBase.collection("warroom");

    await collection.drop();

    await collection.insert(warroom);

    log(body.toString());
    return body;
  }

  static Future<Map<String, dynamic>> isWarRoom() async {
    final collection = dataBase.collection("warroom");

    final item = await collection.find().toList();

    return item.first;
  }
}
