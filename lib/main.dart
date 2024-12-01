import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'routes/app_routes.dart';

void main() {
  // Inicializa o databaseFactory para Desktop
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.linux || 
      defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolugym',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.homeRoute,
    );
  }
}
