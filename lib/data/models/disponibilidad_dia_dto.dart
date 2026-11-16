import 'franja_disponibilidad_dto.dart';

class DisponibilidadDiaDto {
  DisponibilidadDiaDto({
    required this.espacioId,
    required List<FranjaDisponibilidadDto> franjas,
    required this.fechaIso,
  }) : franjas = List.unmodifiable(franjas);
  final String espacioId;
  final List<FranjaDisponibilidadDto> franjas;
  final String fechaIso;
}
