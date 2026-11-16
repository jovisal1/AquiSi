import 'package:material_ui/material_ui.dart';

import '../../../domain/models/disponibilidad_dia.dart';
import '../../core/formatos.dart';
import '../../core/ui/etiqueta.dart';
import '../../core/ui/panel.dart';

class DisponibilidadPanel extends StatelessWidget {
  const DisponibilidadPanel({super.key, required this.dias});
  final List<DisponibilidadDia> dias;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final dia in dias)
        Panel(
          hijo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatos.fecha(dia.fecha),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final franja in dia.franjas)
                    Etiqueta(
                      icono: franja.disponible
                          ? Icons.check_circle_outline
                          : Icons.block,
                      texto:
                          '${Formatos.hora(franja.inicio)}–${Formatos.hora(franja.fin)}\n${franja.disponible ? 'Libre' : 'Ocupada'}',
                      color: franja.disponible
                          ? Colors.teal.shade800
                          : Colors.brown.shade800,
                    ),
                ],
              ),
            ],
          ),
        ),
    ],
  );
}
