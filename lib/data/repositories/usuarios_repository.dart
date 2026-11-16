import '../../domain/models/usuario.dart';
import '../services/datos_simulados_service.dart';
import 'conversiones.dart';

class UsuariosRepository {
  UsuariosRepository({required DatosSimuladosService service}) {
    final origen = service.leerUsuarios();
    comprobarIdentificadores(origen.map((u) => u.id));
    _usuarios = List.unmodifiable(origen.map(convertirUsuario));
  }
  late final List<Usuario> _usuarios;
  Usuario? obtenerPorId(String id) {
    for (final u in _usuarios) {
      if (u.id == id) return u;
    }
    return null;
  }

  Usuario obtenerUsuarioDemo() =>
      obtenerPorId('u1') ?? (throw StateError('Falta el usuario de ejemplo'));
}
