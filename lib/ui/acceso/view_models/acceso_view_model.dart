import 'package:flutter/foundation.dart';

import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/usuario.dart';

class AccesoViewModel extends ChangeNotifier {
  AccesoViewModel({required this._usuariosRepository});
  final UsuariosRepository _usuariosRepository;
  Usuario get usuario => _usuariosRepository.obtenerUsuarioDemo();
  String get correo => usuario.correo;
  String get nombre => usuario.nombre;
  String get claveInicial => 'espai2026';
  Usuario acceder() => usuario;
}
