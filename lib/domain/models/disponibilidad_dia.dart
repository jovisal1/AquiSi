import 'franja_disponibilidad.dart';

class DisponibilidadDia {
  DisponibilidadDia({
    required this.espacioId,
    required this.fecha,
    required List<FranjaDisponibilidad> franjas,
  }) : franjas = List.unmodifiable(franjas);
  final String espacioId;
  final DateTime fecha;
  final List<FranjaDisponibilidad> franjas;
}
