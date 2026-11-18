import 'package:flutter/foundation.dart';

import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/usuario.dart';

class EspaciosViewModel extends ChangeNotifier {
  EspaciosViewModel({
    required EspaciosRepository espaciosRepository,
    required UsuariosRepository usuariosRepository,
  }) : _espaciosRepository = espaciosRepository,
       _usuario = usuariosRepository.obtenerUsuarioDemo();

  static const todasLasActividades = 'Todas';

  final EspaciosRepository _espaciosRepository;
  final Usuario _usuario;

  String get iniciales => _usuario.iniciales;

  String _consulta = '';
  String get consulta => _consulta;

  String _actividad = todasLasActividades;
  String get actividad => _actividad;

  List<String> get actividades => List.unmodifiable([
    todasLasActividades,
    ...{
      for (final espacio in _espaciosRepository.obtenerTodos())
        ...espacio.actividades,
    },
  ]);

  List<Espacio> get espacios {
    final consulta = _consulta.trim().toLowerCase();
    return List.unmodifiable(
      _espaciosRepository.obtenerTodos().where(
        (e) =>
            (_actividad == todasLasActividades ||
                e.admiteActividad(_actividad)) &&
            (e.nombre.toLowerCase().contains(consulta) ||
                e.ubicacion.toLowerCase().contains(consulta)),
      ),
    );
  }

  void buscar(String consulta) {
    _consulta = consulta;
    notifyListeners();
  }

  void filtrarPorActividad(String actividad) {
    _actividad = actividad;
    notifyListeners();
  }
}
