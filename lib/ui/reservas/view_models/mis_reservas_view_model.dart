import 'package:flutter/foundation.dart';

import '../../../data/repositories/reservas_repository.dart';
import '../../../data/repositories/usuarios_repository.dart';
import '../../../domain/models/reserva.dart';

class MisReservasViewModel extends ChangeNotifier {
  MisReservasViewModel({
    required ReservasRepository reservasRepository,
    required UsuariosRepository usuariosRepository,
    required DateTime referencia,
  }) {
    final usuario = usuariosRepository.obtenerUsuarioDemo();
    iniciales = usuario.iniciales;
    final todas = reservasRepository.obtenerPorUsuario(usuario.id);
    bool esProxima(Reserva r) =>
        r.estado != EstadoReserva.cancelada && r.fin.isAfter(referencia);
    proximas = List.unmodifiable(
      todas.where(esProxima).toList()
        ..sort((a, b) => a.inicio.compareTo(b.inicio)),
    );
    historial = List.unmodifiable(
      todas.where((r) => !esProxima(r)).toList()
        ..sort((a, b) => b.inicio.compareTo(a.inicio)),
    );
  }

  late final String iniciales;

  late final List<Reserva> proximas;

  late final List<Reserva> historial;

  bool _verHistorial = false;
  bool get verHistorial => _verHistorial;
  List<Reserva> get visibles => _verHistorial ? historial : proximas;

  void mostrarHistorial(bool valor) {
    if (valor == _verHistorial) return;
    _verHistorial = valor;
    notifyListeners();
  }

  final Set<String> _desplegadas = {};

  bool estaDesplegada(String id) => _desplegadas.contains(id);

  void alternarDetalle(String id) {
    if (!_desplegadas.remove(id)) _desplegadas.add(id);
    notifyListeners();
  }
}
