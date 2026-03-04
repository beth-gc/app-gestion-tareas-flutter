import 'package:app_tareas/core/colores_app.dart';
import 'package:app_tareas/modelos/tarea.dart';
import 'package:app_tareas/pantallas/agregar_tarea.dart';
import 'package:flutter/material.dart';

class PantallaDetalleTarea extends StatelessWidget {
  final String nombre;
  final DateTime fecha;
  final String notas;

  const PantallaDetalleTarea({
    super.key,
    required this.nombre,
    required this.fecha,
    required this.notas,
  });

  //metodo para saber prioridad/status de la tarea
  String _textoPrioridad() {
    final ahora = DateTime.now();
    final diff = fecha.difference(ahora);

    if (diff.isNegative) {
      return 'Vencida';
    } else if (diff.inHours <= 12) {
      return 'Alta';
    } else if (diff.inHours <= 48) {
      return 'Media';
    } else {
      return 'Baja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informacion de tarea',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: ColoresApp.primario,
        foregroundColor: Colors.white,
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
          Container(
            width: double.infinity,
            height: double.infinity,
            child: bodyDetalle(context),
          ),
        ],
      ),
    );
  }

  Column bodyDetalle(BuildContext context) {
    final prioridad = _textoPrioridad();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna de textos
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: formato_textos(prioridad),
        ),

        SizedBox(height: 80),

        // Columna de botones
        Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                //boton eliminar tarea regresa a la pantalla de home la string eliminar
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'eliminar'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColoresApp.acentuado,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      ColoresApp.primario,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Eliminar tarea',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                //boton marcar completada regresa a la pantalla de home el string completada
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'completada'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColoresApp.acentuado,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      ColoresApp.primario,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Marcar completada',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.done_outline_outlined),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                //boton agregar tarea va a la pantalla de agregar tarea y luego espera que esta
                //le mande un objeto tarea
                child: ElevatedButton(
                  onPressed: () async {
                    final tareaEditada = await Navigator.push<Tarea>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaAgregarTarea(
                          nombreInicial: nombre,
                          fechaInicial: fecha,
                          notasInicial: notas,
                        ),
                      ),
                    );
                    if (tareaEditada != null) {
                      Navigator.pop(context, tareaEditada);//si se edito manda la tarea a home
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColoresApp.acentuado,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      ColoresApp.primario,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Editar tarea',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column formato_textos(String prioridad) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre de la tarea
            Row(
              children: [
                Text(
                  'Nombre de la tarea: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Prioridad
            Row(
              children: [
                Text(
                  'Prioridad: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    prioridad,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Fecha
            Row(
              children: [
                Text(
                  'Fecha: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    "${fecha.day}/${fecha.month}/${fecha.year}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Hora
            Row(
              children: [
                Text(
                  'Hora: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    "${fecha.hour}:${fecha.minute}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Notas extras
            Row(
              children: [
                Text(
                  'Notas extras: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    notas,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
  }
}
