import 'package:dart_server/models/balance_model.dart';

import '../helpers/id_helper.dart';
import '../mongo_connection.dart';

class BalanceController {
  static Future<bool> setBalance(
      BalanceModel balance, Map<String, dynamic> headers) async {
    try {
      balance.dateCreated = DateTime.now();
      balance.itemId = IdHelper.createID;
      final collection = dataBase.collection("balance");

      final result = await collection.insert(balance.toJson);

      return true;
    } on Exception {
      return false;
    }
  }
}
