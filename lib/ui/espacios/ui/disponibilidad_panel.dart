import 'package:material_ui/material_ui.dart';

import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/franja_disponibilidad.dart';
import '../../core/formatos.dart';
import '../../core/ui/reservas/fila_franja.dart';
import '../../core/ui/reservas/selector_dia.dart';

class DisponibilidadPanel extends StatelessWidget {
  const DisponibilidadPanel({
    super.key,
    required this.dias,
    required this.indiceDia,
    required this.alSeleccionarDia,
    required this.estaDisponible,
    required this.haPasado,
    required this.referencia,
  });
  final List<DisponibilidadDia> dias;
  final int indiceDia;
  final ValueChanged<int> alSeleccionarDia;

  final bool Function(FranjaDisponibilidad franja) estaDisponible;

  final bool Function(FranjaDisponibilidad franja) haPasado;
  final DateTime referencia;

  @override
  Widget build(BuildContext context) {
    final franjas = [
      for (final franja in dias[indiceDia].franjas)
        if (!haPasado(franja)) franja,
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectorDia(
              dias: [for (final d in dias) d.fecha],
              seleccionado: indiceDia,
              habilitados: [
                for (final d in dias) d.franjas.any(estaDisponible),
              ],
              alSeleccionar: alSeleccionarDia,
              referencia: referencia,
            ),
            const SizedBox(height: 8),
            if (franjas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No quedan franjas este día.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            for (var i = 0; i < franjas.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              FilaFranja(
                horario: Formatos.intervalo(franjas[i].inicio, franjas[i].fin),
                estado: estaDisponible(franjas[i])
                    ? EstadoFranja.libre
                    : EstadoFranja.ocupada,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
