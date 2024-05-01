// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_server.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ServiceRouter(Service service) {
  final router = Router();
  router.mount(
    r'/api/v1',
    service._api.call,
  );
  return router;
}

Router _$ApiRouter(Api service) {
  final router = Router();
  router.add(
    'GET',
    r'/messages',
    service._messages,
  );
  router.add(
    'GET',
    r'/messages/',
    service._messages,
  );
  router.add(
    'POST',
    r'/register',
    service._registerUser,
  );
  router.add(
    'GET',
    r'/users',
    service._getUsers,
  );
  router.add(
    'GET',
    r'/user/<userName>',
    service._getUserByName,
  );
  router.all(
    r'/<ignored|.*>',
    service._notFound,
  );
  return router;
}
