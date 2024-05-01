import 'package:mongo_dart/mongo_dart.dart';

Db dataBase = Db("");

class MongoConnection {
  static Future<Db> connect() async {
    final db = await Db.create(
        "mongodb+srv://dartserver:GxMXJ2LEGI7K0xef@dartserver.fintslv.mongodb.net/dartserver");

    await db.open();

    return db;
  }
}
