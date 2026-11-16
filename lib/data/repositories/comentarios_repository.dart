import '../../domain/models/comentario.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';
import 'espacios_repository.dart';
import 'usuarios_repository.dart';

class ComentariosRepository {
  ComentariosRepository({
    required DatosSimuladosService service,
    required EspaciosRepository espacios,
    required UsuariosRepository usuarios,
  }) {
    final origen = service.leerComentarios();
    comprobarIdentificadores(origen.map((c) => c.id));
    _comentarios = List.unmodifiable(
      origen.map((dto) {
        final autor = usuarios.obtenerPorId(dto.autorId);
        comprobar(
          autor != null && espacios.obtenerPorId(dto.espacioId) != null,
          'Referencia de opinión inexistente',
        );
        comprobar(
          dto.puntuacion >= 1 &&
              dto.puntuacion <= 5 &&
              dto.texto.trim().isNotEmpty,
          'Opinión inválida',
        );
        return Comentario(
          id: dto.id,
          espacioId: dto.espacioId,
          autor: autor!,
          puntuacion: dto.puntuacion,
          texto: dto.texto,
          fecha: DateTime.parse(dto.fechaIso),
        );
      }),
    );
  }
  late final List<Comentario> _comentarios;
  List<Comentario> obtenerPorEspacio(String id) {
    final lista = _comentarios.where((c) => c.espacioId == id).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
    return List.unmodifiable(lista);
  }

  double? obtenerMedia(String id) {
    final lista = obtenerPorEspacio(id);
    return lista.isEmpty
        ? null
        : lista.fold<int>(0, (t, c) => t + c.puntuacion) / lista.length;
  }
}
