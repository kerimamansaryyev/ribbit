import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:ribbit_server/src/injectable_config/di_init.dart';

Future<void> init(InternetAddress ip, int port) async {
  await configureDependencies();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(
    handler,
    ip,
    port,
  );
}
