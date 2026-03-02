import 'package:app_tareas/componentes/tarjeta_tarea.dart';
import 'package:app_tareas/core/colores_app.dart';
import 'package:app_tareas/modelos/tarea.dart';
import 'package:app_tareas/pantallas/agregar_tarea.dart';
import 'package:app_tareas/pantallas/detalle_tarea.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaTareasHome extends StatefulWidget {
  const PantallaTareasHome({super.key});

  @override
  State<PantallaTareasHome> createState() => _PantallaTareasHomeState();
}

class _PantallaTareasHomeState extends State<PantallaTareasHome> {
  List<Tarea> tareas = [
  ];

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    final prefs = await SharedPreferences.getInstance();
    final tareasString = prefs.getString('tareas');

    if (tareasString != null) {
      final List<dynamic> listaJson = jsonDecode(tareasString);
      setState(() {
        tareas = listaJson
            .map((item) => Tarea.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _guardarTareas() async {
    final prefs = await SharedPreferences.getInstance();
    final listaJson = tareas.map((t) => t.toJson()).toList();
    await prefs.setString('tareas', jsonEncode(listaJson));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //boton agregar nueva tarea
        SizedBox(
          width: 260,
          child: ElevatedButton(
            onPressed: () async {
              //va a mandar a pantallAgregarTarea y cuando termine va a
              //recibir un objeto tarea que se va almacenar en nuevaTarea
              final nuevaTarea = await Navigator.push<Tarea>(
                context,
                MaterialPageRoute(builder: (context) => PantallaAgregarTarea()),
              );
              if (nuevaTarea != null) {
                setState(() {
                  tareas.add(nuevaTarea);
                });
                _guardarTareas();
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ColoresApp.acentuado),
              foregroundColor: WidgetStatePropertyAll(ColoresApp.primario),
            ),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text(
                  'Agregar nueva tarea',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
        //Lista de tareas con listview builder, expander es para que ocupe el espacio que resta
        Expanded(
          child: ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              final t = tareas[index];
              return GestureDetector(
                onTap: () async {
                  //va a la pantalla detalle y espera el resultado que guarda en accion
                  final accion = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaDetalleTarea(
                        nombre: t.nombre,
                        fecha: t.fechaLimite,
                        notas: t.notas,
                      ),
                    ),
                  );
                  if (accion is String) {
                    //se selecciona el boton eliminar tarea
                    if (accion == 'eliminar') {
                      setState(() {
                        tareas.removeAt(index);
                      });
                      _guardarTareas();
                      //se selecciona el boton marcar como completada
                    } else if (accion == 'completada') {
                      setState(() {
                        tareas[index].completada = true;
                      });
                      _guardarTareas();
                    }
                    //se selecciona el boton editar, devuelve un objeto
                  } else if (accion is Tarea) {
                    setState(() {
                      tareas[index] = accion;
                    });
                    _guardarTareas();
                  }
                },
                //muestra la tarea con el componente tarjeta
                child: TarjetaTarea(
                  nombre: t.nombre,
                  fechaLimite: t.fechaLimite,
                  completa: t.completada,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
