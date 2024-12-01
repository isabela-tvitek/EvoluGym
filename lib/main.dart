import 'package:flutter/material.dart';
import 'package:evolugym/routes/app_routes.dart';

void main() {
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
