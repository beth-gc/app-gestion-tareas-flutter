import 'package:app_tareas/core/colores_app.dart';
import 'package:app_tareas/modelos/tarea.dart';
import 'package:flutter/material.dart';

class PantallaAgregarTarea extends StatefulWidget {
  final String? nombreInicial;
  final DateTime? fechaInicial;
  final String? notasInicial;

  const PantallaAgregarTarea({
    super.key,
    this.nombreInicial,
    this.fechaInicial,
    this.notasInicial,
  });

  @override
  State<PantallaAgregarTarea> createState() => _PantallaAgregarTareaState();
}

class _PantallaAgregarTareaState extends State<PantallaAgregarTarea> {
  DateTime? fechaSeleccionada;
  TimeOfDay? horaSeleccionada;
  String nombreTarea = '';
  String notas = '';

  //validar que no esten vacios los campos
  bool get formularioCompleto {
    return nombreTarea != '' &&
        fechaSeleccionada != null &&
        horaSeleccionada != null;
  }

  @override
  void initState() {
    super.initState();
    //se cargan datos iniciales si los hay
    if (widget.nombreInicial != null) {
      nombreTarea = widget.nombreInicial!;
    }

    if (widget.notasInicial != null) {
      notas = widget.notasInicial!;
    }

    if (widget.fechaInicial != null) {
      fechaSeleccionada = widget.fechaInicial;
      horaSeleccionada = TimeOfDay.fromDateTime(widget.fechaInicial!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreInicial == null ? 'Agregar nueva tarea' : 'Editar tarea',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: ColoresApp.primario,
        foregroundColor: Colors.white,
      ),
      backgroundColor: ColoresApp.secundario,
      body: bodyAgregarPantalla(context),
    );
  }

  Column bodyAgregarPantalla(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //nombre tarea
        TextFormField(
          maxLength: 30,
          initialValue: nombreTarea,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Introduce el nombre de la tarea',
            filled: true,
            fillColor: ColoresApp.acentuado,
          ),
          onChanged: (valor) {
            setState(() {
              nombreTarea = valor;
            });
          },
        ),
        //notas
        TextFormField(
          maxLength: 120,
          maxLines: 1,
          minLines: 1,
          initialValue: notas,
          decoration: const InputDecoration(
            labelText: 'Notas',
            hintText: 'Escribe detalles adicionales de la tarea',
            filled: true,
            fillColor: ColoresApp.acentuado,
          ),
          onChanged: (valor) {
            setState(() {
              notas = valor;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //fecha limite
            ElevatedButton(
              onPressed: () async {
                DateTime? fecha = await showDatePicker(
                  context: context,
                  initialDate: fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                );
                if (fecha != null) {
                  setState(() {
                    fechaSeleccionada = fecha;
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColoresApp.primario),
                foregroundColor: WidgetStatePropertyAll(ColoresApp.acentuado),
              ),
              child: Text(
                'Fecha',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            //hora limite
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? hora = await showTimePicker(
                  context: context,
                  initialTime: horaSeleccionada ?? TimeOfDay.now(),
                );
                if (hora != null) {
                  setState(() {
                    horaSeleccionada = hora;
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColoresApp.primario),
                foregroundColor: WidgetStatePropertyAll(ColoresApp.acentuado),
              ),
              child: Text(
                'Hora',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        //boton guardar
        ElevatedButton(
          //se habilita el boton de guardar solo si estan llenos todos los datos
          onPressed: formularioCompleto
              ? () {
                  final fechaHoraLimite = DateTime(
                    fechaSeleccionada!.year,
                    fechaSeleccionada!.month,
                    fechaSeleccionada!.day,
                    horaSeleccionada!.hour,
                    horaSeleccionada!.minute,
                  );

                  //crear el objeto Tarea
                  final nuevaTarea = Tarea(
                    nombre: nombreTarea,
                    fechaLimite: fechaHoraLimite,
                    notas: notas,
                  );

                  //regresar a la pantalla de home o detalle
                  Navigator.pop(context, nuevaTarea);
                }
              : null,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ColoresApp.primario),
            foregroundColor: WidgetStatePropertyAll(ColoresApp.acentuado),
          ),
          child: Text(
            'Guardar tarea',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
