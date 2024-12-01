import 'package:flutter/material.dart';
import 'package:evolugym/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                '/home/belavitek/Área de Trabalho/PÓS MóVEIS/Flutter/evolugym/lib/assets/images/logo.png', // Caminho para a imagem
                height: 200,
                width: 200,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Icon(Icons.error, size: 100, color: Colors.red);
                },
              ),
              const SizedBox(height: 120),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.segundaRoute);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF24BE9A),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
