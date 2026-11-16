import 'package:flutter/foundation.dart';

import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/reserva.dart';

class MisReservasViewModel extends ChangeNotifier {
  MisReservasViewModel({
    required ReservasRepository reservasRepository,
    required UsuariosRepository usuariosRepository,
  }) : reservas = reservasRepository.obtenerPorUsuario(
         usuariosRepository.obtenerUsuarioDemo().id,
       );
  final List<Reserva> reservas;
}
