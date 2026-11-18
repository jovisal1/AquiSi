import 'package:flutter/foundation.dart';

import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/disponibilidad_repository.dart';
import '../../../data/repositories/espacios_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/comentario.dart';
import '../../../domain/models/disponibilidad_dia.dart';
import '../../../domain/models/espacio.dart';
import '../../../domain/models/franja_disponibilidad.dart';

class EspacioDetalleViewModel extends ChangeNotifier {
  EspacioDetalleViewModel({
    required String espacioId,
    required EspaciosRepository espaciosRepository,
    required UsuariosRepository usuariosRepository,
    required ComentariosRepository comentariosRepository,
    required DisponibilidadRepository disponibilidadRepository,
    required DateTime referencia,
  }) : _usuariosRepository = usuariosRepository,
       _referencia = referencia,
       espacio =
           espaciosRepository.obtenerPorId(espacioId) ??
           (throw StateError('Espacio inexistente')) {
    _comentarios.addAll(comentariosRepository.obtenerPorEspacio(espacioId));
    disponibilidad = disponibilidadRepository.obtenerSieteDias(
      espacioId,
      referencia,
    );
    final primerDiaLibre = disponibilidad.indexWhere(
      (dia) => dia.franjas.any(estaDisponible),
    );
    _indiceDia = primerDiaLibre < 0 ? 0 : primerDiaLibre;
  }
  final Espacio espacio;
  final UsuariosRepository _usuariosRepository;
  final DateTime _referencia;
  late final List<DisponibilidadDia> disponibilidad;

  DateTime get referencia => _referencia;

  bool estaDisponible(FranjaDisponibilidad franja) =>
      franja.disponible && franja.inicio.isAfter(_referencia);

  bool haPasado(FranjaDisponibilidad franja) =>
      !franja.inicio.isAfter(_referencia);

  int _seccionInformacion = 0;

  int get seccionInformacion => _seccionInformacion;

  void seleccionarSeccionInformacion(int indice) {
    if (indice < 0 || indice > 2 || indice == _seccionInformacion) return;
    _seccionInformacion = indice;
    notifyListeners();
  }

  int _indiceDia = 0;

  int get indiceDia => _indiceDia;

  void seleccionarDia(int indice) {
    if (indice < 0 || indice >= disponibilidad.length) return;
    _indiceDia = indice;
    notifyListeners();
  }
  String get iniciales => _usuariosRepository.obtenerUsuarioDemo().iniciales;

  final List<Comentario> _comentarios = [];
  List<Comentario> get comentarios => List.unmodifiable(_comentarios);
  double? get media => _comentarios.isEmpty
      ? null
      : _comentarios.fold<int>(0, (t, c) => t + c.puntuacion) /
            _comentarios.length;
  List<int> get distribucion => List.unmodifiable([
    for (var estrellas = 5; estrellas >= 1; estrellas--)
      _comentarios.where((c) => c.puntuacion == estrellas).length,
  ]);
  int _imagenActual = 0;
  int get imagenActual => _imagenActual;
  int _puntuacion = 0;
  int get puntuacion => _puntuacion;
  String _textoOpinion = '';
  String get textoOpinion => _textoOpinion;
  bool get puedePublicar =>
      _puntuacion > 0 && _textoOpinion.trim().isNotEmpty;
  void cambiarImagen(int valor) {
    _imagenActual = valor;
    notifyListeners();
  }

  void cambiarPuntuacion(int valor) {
    if (valor < 1 || valor > 5) return;
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
    _puntuacion = 0;
    notifyListeners();
  }
}
