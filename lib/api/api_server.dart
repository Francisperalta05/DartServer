import 'dart:convert';
import 'dart:developer';

import 'package:dart_server/get_users.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

import '../mongo_connection.dart';
part 'api_server.g.dart';

class Service {
  // Other routers can be mounted...
  @Route.mount('/api/v1')
  Router get _api => Api().router;

  shelf.Handler get handler => _$ServiceRouter(this).call;
}

class Api {
  // A handler can have more that one route :)
  @Route.get('/messages')
  @Route.get('/messages/')
  Future<shelf.Response> _messages(shelf.Request request) async =>
      shelf.Response.ok('[]');

  @Route.post("/register")
  Future<shelf.Response> _registerUser(shelf.Request request) async {
    try {
      final users = await Users(dataBase)
          .registerUser(json.decode(await request.readAsString()));
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.get("/users")
  Future<shelf.Response> _getUsers(shelf.Request request) async {
    try {
      final users = await Users(dataBase).getUsers();
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.get('/user/<userName>')
  Future<shelf.Response> _getUserByName(
      shelf.Request request, String userName) async {
    try {
      final users = await Users(dataBase).getUserByName(userName);
      return shelf.Response.ok(json.encode(users));
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
