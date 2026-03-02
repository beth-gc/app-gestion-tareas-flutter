import 'package:flutter/material.dart';

class TarjetaTarea extends StatelessWidget {
  final String nombre;
  final DateTime fechaLimite;
  final bool completa;

  const TarjetaTarea({
    super.key,
    required this.nombre,
    required this.fechaLimite,
    required this.completa,
  });

  String _tiempoRestanteTexto() {
    final ahora = DateTime.now();
    final diff = fechaLimite.difference(ahora);

    if (diff.isNegative) {
      return 'Vencida';
    }

    // Si faltan 24 horas o más → días
    if (diff.inHours >= 24) {
      final dias = diff.inDays; // entero de días completos
      if (dias == 1) {
        return '1 día restante';
      } else {
        return '$dias días restantes';
      }
    } else {
      // Menos de 24 horas → horas
      final horas = diff.inHours; // entero de horas
      if (horas <= 0) {
        // Por si faltan minutos pero 0 horas
        return 'Menos de 1 hora';
      } else if (horas == 1) {
        return '1 hora restante';
      } else {
        return '$horas horas restantes';
      }
    }
  }

  Color _colorPorFecha() {
    final ahora = DateTime.now();
    final diff = fechaLimite.difference(ahora);

    if (diff.isNegative) {
      return const Color(0xE59E9E9E);
    } else if (diff.inHours <= 12) {
      return const Color(0xE4F56258); // Alta
    } else if (diff.inHours <= 48) {
      return const Color(0xE4F0E26A); // Media
    } else {
      return const Color(0xE46FE673); // Baja
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorFondo = _colorPorFecha();
    final textoTiempo = _tiempoRestanteTexto();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Icon(Icons.timelapse),
                Text(
                  textoTiempo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(
                      completa ? Icons.check_circle : Icons.pending_actions,
                      color: completa
                          ? const Color(0xFF255AB6)
                          : const Color(0xFF92240E),
                      size: 20,
                    ),
                    const SizedBox(width: 6),

                    Text(
                      completa ? 'Completada' : 'Pendiente',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: completa
                            ? const Color(0xFF255AB6)
                            : const Color(0xFF92240E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
