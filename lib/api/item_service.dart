import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

import '../controllers/list_controller.dart';
import '../models/item_model.dart';

part 'item_service.g.dart';

class ItemService {
  @Route.get("/items")
  Future<shelf.Response> _getItems(shelf.Request request) async {
    try {
      final users = await ItemController.getItems(request.headers);
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      final response = json.decode(e.toString().replaceAll("Exception: ", ""));
      if (response["statusCode"] == 401) {
        return shelf.Response.unauthorized("");
      }
      return shelf.Response.badRequest(body: json.encode(response));
    }
  }

  @Route.post('/addItem')
  Future<shelf.Response> _addItem(shelf.Request request) async {
    try {
      final body = await request.readAsString();

      final item = ItemModel.fromJson(json.decode(body));

      final result = await ItemController.addItem(item, request.headers);
      return shelf.Response.ok(json.encode(result));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  @Route.post('/removeItem/<itemID>')
  Future<shelf.Response> _removeItem(
      shelf.Request request, String itemID) async {
    try {
      final result = await ItemController.removeItem(itemID);
      if (result) {
        return shelf.Response.ok(json.encode(result));
      } else {
        return shelf.Response.badRequest(body: "Este elemento no existe");
      }
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  Router get router => _$ItemServiceRouter(this);
}
