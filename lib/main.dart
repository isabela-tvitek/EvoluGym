import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:evolugym/services/exercise_service.dart';
import 'package:evolugym/routes/app_routes.dart';

void main() {
  // Configuração do Dio
  final dio = Dio();
  
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  MyApp({required this.dio});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Passando a instância de Dio para o ExerciseService
        Provider(create: (_) => ExerciseService(dio)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Evolugym',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.homeRoute,
      ),
    );
  }
}
