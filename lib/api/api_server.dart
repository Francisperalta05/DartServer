import 'package:dart_server/api/item_service.dart';
import 'package:dart_server/api/user_service.dart';
import 'package:shelf/shelf.dart' as shelf;

import 'package:shelf_router/shelf_router.dart';

part 'api_server.g.dart';

class ApiService {
  static const String route = "/api";
  // Other routers can be mounted...
  @Route.mount(route)
  Router get _apiService => Api().router;
  @Route.mount(route)
  Router get _itemService => ItemService().router;
  @Route.mount(route)
  Router get _userService => UserService().router;

  shelf.Handler get handler => _$ApiServiceRouter(this).call;
}

class Api {
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
