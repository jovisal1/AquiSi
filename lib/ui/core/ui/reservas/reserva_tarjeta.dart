import 'package:material_ui/material_ui.dart';

import '../../../../config/tema_app.dart';
import '../../../../domain/models/reserva.dart';
import '../../formatos.dart';
import '../textos/dato_icono.dart';
import 'fila_importe.dart';

String etiquetaEstado(EstadoReserva estado) => switch (estado) {
  EstadoReserva.confirmada => 'Confirmada',
  EstadoReserva.pendiente => 'Pendiente',
  EstadoReserva.cancelada => 'Cancelada',
};

Color colorEstado(EstadoReserva estado) => switch (estado) {
  EstadoReserva.confirmada => TemaApp.exito,
  EstadoReserva.pendiente => TemaApp.aviso,
  EstadoReserva.cancelada => TemaApp.error,
};

class ReservaTarjeta extends StatelessWidget {
  const ReservaTarjeta({
    super.key,
    required this.reserva,
    this.mostrarDesglose = false,
  });
  final Reserva reserva;
  final bool mostrarDesglose;

  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    final horas = reserva.duracion.inHours;
    String dinero(int centimos) => Formatos.dinero(centimos, reserva.moneda);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiquetaEstado(reserva.estado).toUpperCase(),
              style: temaTexto.labelSmall?.copyWith(
                color: colorEstado(reserva.estado),
              ),
            ),
            const SizedBox(height: 6),
            Text(reserva.espacio.nombre, style: temaTexto.titleLarge),
            const SizedBox(height: 2),
            Text(
              '${reserva.actividad} · ${reserva.asistentes} asistentes',
              style: temaTexto.bodySmall,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${Formatos.fecha(reserva.inicio)} · ${Formatos.hora(reserva.inicio)}–${Formatos.hora(reserva.fin)} · $horas h',
                    style: temaTexto.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!mostrarDesglose) ...[
                  const SizedBox(width: 12),
                  Text(
                    dinero(reserva.precioTotalCentimos),
                    style: temaTexto.titleMedium,
                  ),
                ],
              ],
            ),
            if (!mostrarDesglose) ...[
              const SizedBox(height: 4),
              Text(
                reserva.serviciosContratados.isEmpty
                    ? 'Sin extras · IVA incluido'
                    : 'Extras: ${reserva.serviciosContratados.map((s) => s.nombre).join(', ')} · IVA incluido',
                style: temaTexto.bodySmall,
              ),
            ],
            if (mostrarDesglose) ...[
              const Divider(),
              FilaImporte(
                etiqueta: 'Tarifa por hora',
                importe: dinero(reserva.tarifaHoraCentimos),
              ),
              FilaImporte(
                etiqueta: 'Alquiler · $horas horas',
                importe: dinero(reserva.tarifaHoraCentimos * horas),
              ),
              if (reserva.serviciosContratados.isEmpty)
                const FilaImporte(etiqueta: 'Sin extras', importe: '—'),
              for (final s in reserva.serviciosContratados)
                FilaImporte(
                  etiqueta: s.nombre,
                  importe: dinero(s.precioCentimos),
                ),
              FilaImporte(
                etiqueta: 'Subtotal de extras',
                importe: dinero(reserva.totalServiciosCentimos),
              ),
              const Divider(),
              FilaImporte(
                etiqueta: 'Total · IVA incluido',
                importe: dinero(reserva.precioTotalCentimos),
                destacada: true,
              ),
            ],
            const Divider(),
            DatoIcono(
              icono: Icons.person_outline,
              texto:
                  '${reserva.espacio.contacto.nombre} · ${reserva.espacio.contacto.telefono}',
            ),
            DatoIcono(
              icono: Icons.mail_outline,
              texto: reserva.espacio.contacto.correo,
            ),
          ],
        ),
      ),
    );
  }
}
