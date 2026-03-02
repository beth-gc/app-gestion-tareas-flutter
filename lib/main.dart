import 'package:app_tareas/core/colores_app.dart';
import 'package:flutter/material.dart';
import 'package:app_tareas/pantallas/home_tareas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColoresApp.primario,
          title: Center(
            child: Text(
              "Tareas pendientes",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            // Fondo
            Positioned.fill(
              child: Image.asset(
                "assets/images/wallpaper.png",
                fit: BoxFit.cover,
              ),
            ),
            PantallaTareasHome(),
          ],
        ),
      ),
    );
  }
}
