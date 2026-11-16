import 'servicio_contratado_dto.dart';

class ReservaDto {
  ReservaDto({
    required this.id,
    required this.actividad,
    required this.asistentes,
    required List<ServicioContratadoDto> serviciosContratados,
    required this.tarifaHoraCentimos,
    required this.precioTotalCentimos,
    required this.moneda,
    required this.espacioId,
    required this.usuarioId,
    required this.inicioIso,
    required this.finIso,
    required this.codigoEstado,
  }) : serviciosContratados = List.unmodifiable(serviciosContratados);
  final String id;
  final String actividad;
  final int asistentes;
  final List<ServicioContratadoDto> serviciosContratados;
  final int tarifaHoraCentimos;
  final int precioTotalCentimos;
  final String moneda;
  final String espacioId;
  final String usuarioId;
  final String inicioIso;
  final String finIso;
  final String codigoEstado;
}
