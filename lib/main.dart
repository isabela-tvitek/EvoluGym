import 'package:evolugym/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/routes/app_routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolugym',
      theme: ThemeService.light,
      darkTheme: ThemeService.dark,
      themeMode:
          Provider.of<ThemeService>(context).isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.homeRoute,
    );
  }
}
