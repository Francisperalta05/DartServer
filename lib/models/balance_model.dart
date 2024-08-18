// To parse this JSON data, do
//
//     final lista = listaFromJson(jsonString);

import 'dart:convert';

BalanceModel listaFromJson(String str) =>
    BalanceModel.fromJson(json.decode(str));

String listaToJson(BalanceModel data) => json.encode(data.toJson);

class BalanceModel {
  BalanceModel({
    this.itemId,
    this.price,
    this.dateCreated,
    this.userUID,
  });

  String? itemId;
  int? price;
  DateTime? dateCreated;
  String? userUID;

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        userUID: json["user_uid"],
        itemId: json["item_id"] ?? "",
        price: json["price"] ?? 0,
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
      );

  Map<String, dynamic> get toJson => {
        "price": price,
        "item_id": itemId,
        "date_created": dateCreated?.toIso8601String(),
        "user_uid": userUID,
      };
}
