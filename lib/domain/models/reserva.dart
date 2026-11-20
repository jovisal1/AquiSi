import 'espacio.dart';
import 'servicio_contratado.dart';
import 'tramo_reserva.dart';
import 'usuario.dart';

enum EstadoReserva { confirmada, pendiente, cancelada }

enum ModalidadReserva { porHoras, porDias }

class Reserva {
  Reserva({
    required this.id,
    required this.espacio,
    required this.usuario,
    required this.actividad,
    required this.modalidad,
    required List<TramoReserva> tramos,
    required this.asistentes,
    required this.estado,
    required List<ServicioContratado> serviciosContratados,
    required this.tarifaCentimos,
    required this.precioTotalCentimos,
    required this.moneda,
  }) : tramos = List.unmodifiable(tramos),
       serviciosContratados = List.unmodifiable(serviciosContratados);
  final String id;
  final Espacio espacio;
  final Usuario usuario;
  final String actividad;
  final ModalidadReserva modalidad;

  // Por horas: una franja por tramo, todas del mismo día.
  // Por días: un tramo por día completo.
  final List<TramoReserva> tramos;
  final int asistentes;
  final EstadoReserva estado;
  final List<ServicioContratado> serviciosContratados;

  // Precio por hora o por día, según la modalidad.
  final int tarifaCentimos;
  final int precioTotalCentimos;
  final String moneda;

  DateTime get inicio => tramos.first.inicio;
  DateTime get fin => tramos.last.fin;
  int get horas => tramos.fold(0, (total, tramo) => total + tramo.horas);
  int get dias => tramos.length;
  int get unidades => modalidad == ModalidadReserva.porDias ? dias : horas;
  int get alquilerCentimos => tarifaCentimos * unidades;
  int get totalServiciosCentimos => serviciosContratados.fold(
    0,
    (total, servicio) => total + servicio.precioCentimos,
  );
}
