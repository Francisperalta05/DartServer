import 'dart:convert';

import 'package:dart_server/controllers/user_controller.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

import '../models/user_model.dart';

part 'user_service.g.dart';

class UserService {
  @Route.post("/registerUser")
  Future<shelf.Response> _registerUser(shelf.Request request) async {
    try {
      final data = await request.readAsString();
      final user = UserModel.fromJson(json.decode(data));
      final users = await UserController.registerUser(user);
      return shelf.Response.ok(json.encode(users));
    } on Exception catch (e) {
      return shelf.Response.badRequest(body: e);
    }
  }

  @Route.post("/loginUser")
  Future<shelf.Response> _loginUser(shelf.Request request) async {
    try {
      final data = await request.readAsString();
      final user = UserModel.fromJson(json.decode(data));
      final users = await UserController.loginUser(user);
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

  Router get router => _$UserServiceRouter(this);
}
