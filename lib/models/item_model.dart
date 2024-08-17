// To parse this JSON data, do
//
//     final lista = listaFromJson(jsonString);

import 'dart:convert';

ItemModel listaFromJson(String str) => ItemModel.fromJson(json.decode(str));

String listaToJson(ItemModel data) => json.encode(data.toJson);

class ItemModel {
  ItemModel({
    this.itemId,
    this.name,
    this.price,
    this.dateCreated,
    this.userUID,
  });

  String? itemId;
  String? name;
  int? price;
  DateTime? dateCreated;
  String? userUID;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        userUID: json["user_uid"],
        itemId: json["item_id"] ?? "",
        name: json["name"] ?? "",
        price: json["price"] ?? 0,
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
      );

  Map<String, dynamic> get toJson => {
        "name": name,
        "price": price,
        "item_id": itemId,
        "date_created": dateCreated?.toIso8601String(),
        "user_uid": userUID,
      };
}
