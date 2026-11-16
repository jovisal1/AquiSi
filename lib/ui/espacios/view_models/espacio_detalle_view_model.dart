import 'package:flutter/foundation.dart';

import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';
import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/comentario.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';

class EspacioDetalleViewModel extends ChangeNotifier {
  EspacioDetalleViewModel({
    required String espacioId,
    required EspaciosRepository espaciosRepository,
    required this._usuariosRepository,
    required ComentariosRepository comentariosRepository,
    required DisponibilidadRepository disponibilidadRepository,
    required DateTime referencia,
  }) : espacio =
           espaciosRepository.obtenerPorId(espacioId) ??
           (throw StateError('Espacio inexistente')) {
    _comentarios.addAll(comentariosRepository.obtenerPorEspacio(espacioId));
    disponibilidad = disponibilidadRepository.obtenerSieteDias(
      espacioId,
      referencia,
    );
  }
  final Espacio espacio;
  final UsuariosRepository _usuariosRepository;
  late final List<DisponibilidadDia> disponibilidad;
  final List<Comentario> _comentarios = [];
  List<Comentario> get comentarios => List.unmodifiable(_comentarios);
  double? get media => _comentarios.isEmpty
      ? null
      : _comentarios.fold<int>(0, (t, c) => t + c.puntuacion) /
            _comentarios.length;
  int _imagenActual = 0;
  int get imagenActual => _imagenActual;
  int _puntuacion = 5;
  int get puntuacion => _puntuacion;
  String _textoOpinion = '';
  String get textoOpinion => _textoOpinion;
  bool get puedePublicar => _textoOpinion.trim().isNotEmpty;
  void cambiarImagen(int valor) {
    _imagenActual = valor;
    notifyListeners();
  }

  void cambiarPuntuacion(int valor) {
    _puntuacion = valor;
    notifyListeners();
  }

  void editarOpinion(String valor) {
    _textoOpinion = valor;
    notifyListeners();
  }

  void publicarOpinion() {
    if (!puedePublicar) return;
    _comentarios.insert(
      0,
      Comentario(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        espacioId: espacio.id,
        autor: _usuariosRepository.obtenerUsuarioDemo(),
        puntuacion: _puntuacion,
        texto: _textoOpinion.trim(),
        fecha: DateTime.now(),
      ),
    );
    _textoOpinion = '';
    _puntuacion = 5;
    notifyListeners();
  }
}
