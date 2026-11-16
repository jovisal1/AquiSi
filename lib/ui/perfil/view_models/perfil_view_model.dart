import 'package:flutter/foundation.dart';

import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/usuario.dart';

class PerfilViewModel extends ChangeNotifier {
  PerfilViewModel({required UsuariosRepository usuariosRepository})
    : usuario = usuariosRepository.obtenerUsuarioDemo();
  final Usuario usuario;
  String get iniciales =>
      usuario.nombre.split(' ').map((p) => p[0]).take(2).join();
  bool _notificaciones = true;
  bool get notificaciones => _notificaciones;
  void cambiarNotificaciones(bool valor) {
    _notificaciones = valor;
    notifyListeners();
  }

  String get version => '1.0.0';
}
