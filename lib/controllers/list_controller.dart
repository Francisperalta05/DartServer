import 'dart:convert';
import 'dart:developer';

import 'package:dart_server/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ListController {
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
}
