class ComentarioDto {
  const ComentarioDto({
    required this.id,
    required this.espacioId,
    required this.puntuacion,
    required this.texto,
    required this.autorId,
    required this.fechaIso,
  });
  final String id;
  final String espacioId;
  final int puntuacion;
  final String texto;
  final String autorId;
  final String fechaIso;
}
