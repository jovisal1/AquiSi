import 'package:material_ui/material_ui.dart';

import '../../../domain/models/reserva.dart';
import '../formatos.dart';
import 'dato_icono.dart';
import 'etiqueta.dart';
import 'fila_importe.dart';
import 'panel.dart';

String etiquetaEstado(EstadoReserva estado) => switch (estado) {
  EstadoReserva.confirmada => 'Confirmada',
  EstadoReserva.pendiente => 'Pendiente',
  EstadoReserva.cancelada => 'Cancelada',
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
    final color = switch (reserva.estado) {
      EstadoReserva.confirmada => Colors.teal.shade800,
      EstadoReserva.pendiente => Colors.brown.shade800,
      EstadoReserva.cancelada => Colors.red.shade800,
    };
    return Panel(
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reserva.espacio.nombre,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Etiqueta(
            texto: etiquetaEstado(reserva.estado),
            icono: Icons.circle,
            color: color,
          ),
          DatoIcono(
            icono: Icons.event_outlined,
            texto: '${reserva.actividad} · ${Formatos.fecha(reserva.inicio)}',
          ),
          DatoIcono(
            icono: Icons.schedule,
            texto:
                '${Formatos.hora(reserva.inicio)} – ${Formatos.hora(reserva.fin)} · ${reserva.duracion.inHours} horas',
          ),
          DatoIcono(
            icono: Icons.people_outline,
            texto: '${reserva.asistentes} asistentes',
          ),
          const Divider(),
          if (mostrarDesglose) ...[
            FilaImporte(
              etiqueta: 'Tarifa por hora',
              importe: Formatos.dinero(
                reserva.tarifaHoraCentimos,
                reserva.moneda,
              ),
            ),
            FilaImporte(
              etiqueta: 'Alquiler · ${reserva.duracion.inHours} horas',
              importe: Formatos.dinero(
                reserva.tarifaHoraCentimos * reserva.duracion.inHours,
                reserva.moneda,
              ),
            ),
          ],
          if (reserva.serviciosContratados.isEmpty) const Text('Sin extras'),
          for (final s in reserva.serviciosContratados)
            FilaImporte(
              etiqueta: s.nombre,
              importe: Formatos.dinero(s.precioCentimos, reserva.moneda),
            ),
          if (mostrarDesglose)
            FilaImporte(
              etiqueta: 'Subtotal de extras',
              importe: Formatos.dinero(
                reserva.totalServiciosCentimos,
                reserva.moneda,
              ),
            ),
          FilaImporte(
            etiqueta: 'Total · IVA incluido',
            importe: Formatos.dinero(
              reserva.precioTotalCentimos,
              reserva.moneda,
            ),
            destacada: true,
          ),
          const Divider(),
          DatoIcono(
            icono: Icons.person_outline,
            texto:
                '${reserva.espacio.contacto.nombre} · ${reserva.espacio.contacto.telefono}',
          ),
          Text(reserva.espacio.contacto.correo),
        ],
      ),
    );
  }
}
