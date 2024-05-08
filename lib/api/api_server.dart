import 'dart:convert';

import 'package:dart_server/controllers/list_controller.dart';
import 'package:dart_server/controllers/user_controller.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

part 'api_server.g.dart';

class Service {
  // Other routers can be mounted...
  @Route.mount('/api/v1')
  Router get _api => Api().router;

  shelf.Handler get handler => _$ServiceRouter(this).call;
}

class Api {
  @Route.post("/register")
  Future<shelf.Response> _registerUser(shelf.Request request) async {
    try {
      final users = await UserController.registerUser(
          json.decode(await request.readAsString()));
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.get("/users")
  Future<shelf.Response> _getUsers(shelf.Request request) async {
    try {
      final users = await UserController.getUsers();
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.get('/user/<userName>')
  Future<shelf.Response> _getUserByName(
      shelf.Request request, String userName) async {
    try {
      final users = await UserController.getUserByName(userName);
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  @Route.get("/items")
  Future<shelf.Response> _getItems(shelf.Request request) async {
    try {
      final users = await ListController.getItems();
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.post('/addItem')
  Future<shelf.Response> _addItem(shelf.Request request) async {
    try {
      final body = await request.readAsString();
      final result = await ListController.addItem(json.decode(body));
      return shelf.Response.ok(json.encode(result));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  @Route.post('/removeItem/<itemID>')
  Future<shelf.Response> _removeItem(
      shelf.Request request, String itemID) async {
    try {
      final result = await ListController.removeItem(itemID);
      if (result) {
        return shelf.Response.ok(json.encode(result));
      } else {
        return shelf.Response.badRequest(body: "Este elemento no existe");
      }
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  @Route.post('/isWarRoom')
  Future<shelf.Response> _isWarRoom(shelf.Request request) async {
    try {
      final result = await ListController.isWarRoom(
          json.decode(await request.readAsString()));

      return shelf.Response.ok(json.encode(result));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e.toString());
    }
  }

  // Embedded URL parameters may also be associated with a regular-expression
  // that the pattern must match.
  // @Route.get('/user/<userId|[0-9]+>')
  // shelf.Response _userNumber(shelf.Request request, String userId) =>
  //     shelf.Response.ok('User has the user-number: $userId');

  // This nested catch-all, will only catch /api/v1/.* when mounted above.
  // Notice that ordering if annotated handlers and mounts is significant.
  @Route.all('/<ignored|.*>')
  shelf.Response _notFound(shelf.Request request) =>
      shelf.Response.notFound('Page not found');

  // The generated function _$ApiRouter can be used to expose a [Router] for
  // this object.
  Router get router => _$ApiRouter(this);
}
