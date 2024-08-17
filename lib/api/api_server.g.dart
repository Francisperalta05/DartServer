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
    'POST',
    r'/registerUser',
    service._registerUser,
  );
  router.add(
    'POST',
    r'/loginUser',
    service._loginUser,
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
  router.add(
    'GET',
    r'/items',
    service._getItems,
  );
  router.add(
    'POST',
    r'/addItem',
    service._addItem,
  );
  router.add(
    'POST',
    r'/removeItem/<itemID>',
    service._removeItem,
  );
  router.all(
    r'/<ignored|.*>',
    service._notFound,
  );
  return router;
}
