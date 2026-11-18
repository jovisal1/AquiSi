import 'package:flutter/foundation.dart';

import '../../../data/repositories/comentarios_repository.dart';
import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/reserva.dart';
import '../../../domain/models/usuario.dart';

class PerfilViewModel extends ChangeNotifier {
  PerfilViewModel({
    required UsuariosRepository usuariosRepository,
    required ReservasRepository reservasRepository,
    required ComentariosRepository comentariosRepository,
    required DateTime referencia,
  }) : usuario = usuariosRepository.obtenerUsuarioDemo() {
    final reservas = reservasRepository.obtenerPorUsuario(usuario.id);
    reservasProximas = reservas
        .where(
          (r) =>
              r.estado != EstadoReserva.cancelada && r.fin.isAfter(referencia),
        )
        .length;
    reservasRealizadas = reservas
        .where(
          (r) =>
              r.estado == EstadoReserva.confirmada &&
              !r.fin.isAfter(referencia),
        )
        .length;
    opinionesPublicadas = comentariosRepository
        .obtenerPorAutor(usuario.id)
        .length;
  }
  final Usuario usuario;
  String get iniciales => usuario.iniciales;

  late final int reservasProximas;

  late final int reservasRealizadas;

  late final int opinionesPublicadas;

  bool _notificaciones = true;
  bool get notificaciones => _notificaciones;
  void cambiarNotificaciones(bool valor) {
    _notificaciones = valor;
    notifyListeners();
  }

  String get version => '1.0.0';
}
