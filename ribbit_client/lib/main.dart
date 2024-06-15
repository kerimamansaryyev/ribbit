import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ribbit_client/src/app.dart';
import 'package:ribbit_client/src/di/injectable_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const RibbitClientApp());
}
