// For Google Cloud Run, set _hostname to '0.0.0.0'.
import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_server/api/api_server.dart';
import 'package:dart_server/mongo_connection.dart';
import 'package:shelf/shelf_io.dart' as io;

const _hostname = '148.0.10.36';

void main(List<String> args) async {
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

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
  final service = Service();
  final server = await io.serve(service.handler, _hostname, port);

  // final server = await io.serve(handler, _hostname, port);
  log('Serving at http://${server.address.host}:${server.port}');
}
