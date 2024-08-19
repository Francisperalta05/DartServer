// For Google Cloud Run, set _hostname to '0.0.0.0'.
import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_server/api/api_server.dart';
import 'package:dart_server/mongo_connection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

// Middleware para añadir los encabezados CORS
Middleware corsMiddleware = (Handler handler) {
  return (Request request) async {
    // Manejar la solicitud preflight (OPTIONS)
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Access-Control-Allow-Credentials': 'true',
      });
    }

    // Pasar la solicitud al siguiente middleware/controlador
    final Response response = await handler(request);

    // Añadir los encabezados CORS a la respuesta
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Allow-Credentials': 'true',
    });
  };
};

void main(List<String> args) async {
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

  final ip = InternetAddress.anyIPv4;

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '80';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }
  dataBase = await MongoConnection.connect();
  log("DataBase Done ${dataBase.toString()}");

  final service = ApiService();

  // Aplica el middleware de CORS
  final handler = const Pipeline()
      .addMiddleware(corsMiddleware) // Aquí se aplica el middleware CORS
      .addHandler(service.handler);

  final server = await io.serve(handler, ip, port);

  log('Serving at http://${server.address.host}:${server.port}');

  // setTimer();
}



// Timer? timer;

// void setTimer() {
//   timer?.cancel();
//   timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     log(DateTime.now().millisecondsSinceEpoch.toString());

//     // timer.cancel();
//   });
// }
